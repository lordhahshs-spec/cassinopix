<?php

namespace App\Filament\Pages;

use App\Services\UnusedFilesScanner;
use Filament\Notifications\Notification;
use Filament\Pages\Page;

class LimparArquivosPage extends Page
{
    protected static ?string $navigationIcon = 'heroicon-o-sparkles';

    protected static string $view = 'filament.pages.limpar-arquivos';

    protected static ?string $navigationLabel = 'Limpar cache e arquivos';

    protected static ?string $title = 'Limpar cache, logs e arquivos';

    protected static ?string $slug = 'limpar-arquivos';

    protected static bool $shouldRegisterNavigation = false;

    /** Caminhos marcados na lista. */
    public array $selected = [];

    /** Logs marcados para zerar. */
    public array $selectedLogs = [];

    /** Filtro por nome. */
    public string $search = '';

    /** Pasta exibida ('' = todas). */
    public string $folder = '';

    public static function canAccess(): bool
    {
        return auth()->check() && auth()->user()->hasRole('admin');
    }

    protected function scanner(): UnusedFilesScanner
    {
        return app(UnusedFilesScanner::class);
    }

    public function mount(): void
    {
        $this->selectedLogs = array_column($this->scanner()->logs(), 'path');
    }

    public function clearCache(): void
    {
        $done = $this->scanner()->clearCache();

        Notification::make()
            ->title('Cache limpo')
            ->body($done ? 'Limpou: ' . implode(', ', $done) . '.' : 'Nada para limpar.')
            ->success()
            ->send();
    }

    public function clearLogs(): void
    {
        if (empty($this->selectedLogs)) {
            Notification::make()->title('Nenhum log marcado')->warning()->send();
            return;
        }

        $r = $this->scanner()->clearLogs($this->selectedLogs);
        $this->selectedLogs = array_column($this->scanner()->logs(), 'path');

        Notification::make()
            ->title($r['count'] . ' log(s) limpo(s)')
            ->body(UnusedFilesScanner::formatBytes($r['size']) . ' liberados.')
            ->success()
            ->send();
    }

    /** Cache + todos os logs + uploads temporários, num clique. */
    public function quickClean(): void
    {
        $s = $this->scanner();
        $s->clearCache();
        $l = $s->clearLogs(array_column($s->logs(), 'path'));
        $t = $s->cleanLivewireTmp();
        $this->selectedLogs = array_column($s->logs(), 'path');

        Notification::make()
            ->title('Limpeza rápida concluída')
            ->body('Cache limpo, ' . $l['count'] . ' log(s) zerado(s) e ' . $t['count'] . ' temporário(s) apagado(s). '
                . UnusedFilesScanner::formatBytes($l['size'] + $t['size']) . ' liberados.')
            ->success()
            ->send();
    }

    public function scan(): void
    {
        $result = $this->scanner()->scan();
        $this->selected = [];

        Notification::make()
            ->title('Varredura concluída')
            ->body(count($result['unused']) . ' arquivo(s) sem uso, ' . UnusedFilesScanner::formatBytes($result['unused_size']) . '.')
            ->success()
            ->send();
    }

    public function selectAllVisible(): void
    {
        $this->selected = array_values(array_unique(array_merge(
            $this->selected,
            array_column($this->filteredItems(), 'path')
        )));
    }

    public function clearSelection(): void
    {
        $this->selected = [];
    }

    public function moveSelected(): void
    {
        if (empty($this->selected)) {
            Notification::make()->title('Nenhum arquivo selecionado')->warning()->send();
            return;
        }

        $this->moveToTrash($this->selected);
    }

    public function moveAll(): void
    {
        $result = $this->scanner()->lastResult();
        $this->moveToTrash(array_column($result['unused'] ?? [], 'path'));
    }

    protected function moveToTrash(array $paths): void
    {
        $r = $this->scanner()->moveToTrash($paths);
        $this->selected = [];

        Notification::make()
            ->title($r['moved'] . ' arquivo(s) movido(s) para a lixeira')
            ->body(UnusedFilesScanner::formatBytes($r['size']) . ' saíram do site. Dá para restaurar até esvaziar a lixeira.')
            ->success()
            ->send();
    }

    public function restoreBatch(string $id): void
    {
        $n = $this->scanner()->restoreBatch($id);

        Notification::make()
            ->title($n . ' arquivo(s) restaurado(s)')
            ->body('Faça uma nova varredura para atualizar a lista.')
            ->success()
            ->send();
    }

    public function emptyBatch(string $id): void
    {
        $bytes = $this->scanner()->emptyTrash($id);

        Notification::make()
            ->title('Lote excluído definitivamente')
            ->body(UnusedFilesScanner::formatBytes($bytes) . ' liberados no servidor.')
            ->success()
            ->send();
    }

    public function emptyAllTrash(): void
    {
        $bytes = $this->scanner()->emptyTrash();

        Notification::make()
            ->title('Lixeira esvaziada')
            ->body(UnusedFilesScanner::formatBytes($bytes) . ' liberados no servidor.')
            ->success()
            ->send();
    }

    public function cleanTmp(): void
    {
        $r = $this->scanner()->cleanLivewireTmp();

        Notification::make()
            ->title($r['count'] . ' upload(s) temporário(s) removido(s)')
            ->body(UnusedFilesScanner::formatBytes($r['size']) . ' liberados.')
            ->success()
            ->send();
    }

    protected function filteredItems(): array
    {
        $items = $this->scanner()->lastResult()['unused'] ?? [];
        $term = mb_strtolower(trim($this->search));

        return array_values(array_filter($items, function ($i) use ($term) {
            if ($this->folder !== '' && $i['folder'] !== $this->folder) {
                return false;
            }

            return $term === '' || str_contains(mb_strtolower($i['path']), $term);
        }));
    }

    protected function getViewData(): array
    {
        $result = $this->scanner()->lastResult();
        $items = $this->filteredItems();

        $folders = [];
        foreach ($result['unused'] ?? [] as $i) {
            $folders[$i['folder']] ??= ['count' => 0, 'size' => 0];
            $folders[$i['folder']]['count']++;
            $folders[$i['folder']]['size'] += $i['size'];
        }
        ksort($folders);

        $sizeByPath = array_column($result['unused'] ?? [], 'size', 'path');
        $selectedSize = array_sum(array_map(fn ($p) => $sizeByPath[$p] ?? 0, $this->selected));

        return [
            'result'       => $result,
            'items'        => array_slice($items, 0, 500),
            'itemsTotal'   => count($items),
            'folders'      => $folders,
            'trash'        => $this->scanner()->trashBatches(),
            'logs'         => $this->scanner()->logs(),
            'tmp'          => $this->scanner()->livewireTmpInfo(),
            'selectedSize' => $selectedSize,
            'fmt'          => fn ($b) => UnusedFilesScanner::formatBytes($b),
        ];
    }
}
