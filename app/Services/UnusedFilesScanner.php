<?php

namespace App\Services;

use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\File;

/**
 * Localiza arquivos de mídia em public/storage que não são referenciados
 * em nenhum lugar (banco de dados ou código) e permite movê-los para uma
 * lixeira reversível antes de excluir de vez. Também limpa cache e logs.
 */
class UnusedFilesScanner
{
    /** Pastas dentro de public/storage que nunca entram na limpeza. */
    public const PROTECTED_DIRS = ['themes', 'som'];

    /** Arquivos que nunca entram na limpeza. */
    public const PROTECTED_FILES = ['.gitignore', '.htaccess', 'index.php', 'index.html', 'web.config'];

    /** Arquivos alterados há menos de X horas são ignorados (upload em andamento). */
    public const MIN_AGE_HOURS = 24;

    /** Pastas e extensões de código onde procurar referências. */
    protected const CODE_DIRS = [
        'app', 'config', 'routes', 'resources', 'Modules', 'lang',
        'public/build', 'public/assets/js', 'public/assets/css', 'public/js', 'public/css',
    ];

    protected const CODE_EXT = ['php', 'js', 'mjs', 'vue', 'ts', 'css', 'scss', 'json', 'html', 'htm'];

    protected const IMAGE_EXT = ['png', 'jpg', 'jpeg', 'gif', 'webp', 'avif', 'svg', 'ico', 'bmp'];

    public function storageRoot(): string
    {
        return public_path('storage');
    }

    public function trashRoot(): string
    {
        return storage_path('app/lixeira-arquivos');
    }

    protected function resultFile(): string
    {
        return storage_path('app/limpeza-arquivos-scan.json');
    }

    /**
     * Executa a varredura completa e salva o resultado em JSON.
     */
    public function scan(): array
    {
        @set_time_limit(600);
        @ini_set('memory_limit', '1024M');

        $root = $this->storageRoot();
        $tokens = $this->collectReferenceTokens();

        $unused = [];
        $totalFiles = 0;
        $totalSize = 0;
        $skippedRecent = 0;
        $limit = time() - (self::MIN_AGE_HOURS * 3600);

        if (is_dir($root)) {
            $it = new \RecursiveIteratorIterator(
                new \RecursiveDirectoryIterator($root, \FilesystemIterator::SKIP_DOTS)
            );

            foreach ($it as $file) {
                /** @var \SplFileInfo $file */
                if (!$file->isFile() || $file->isLink()) {
                    continue;
                }

                $rel = $this->relativePath($file->getPathname(), $root);
                $name = $file->getFilename();
                $top = str_contains($rel, '/') ? explode('/', $rel)[0] : '';

                if (in_array($name, self::PROTECTED_FILES, true) || in_array($top, self::PROTECTED_DIRS, true)) {
                    continue;
                }

                $totalFiles++;
                $size = $file->getSize();
                $totalSize += $size;

                if ($this->isReferenced($rel, $name, $tokens)) {
                    continue;
                }

                if ($file->getMTime() > $limit) {
                    $skippedRecent++;
                    continue;
                }

                $ext = strtolower($file->getExtension());
                $unused[] = [
                    'path'     => $rel,
                    'folder'   => $top !== '' ? $top : '(raiz)',
                    'name'     => $name,
                    'size'     => $size,
                    'modified' => date('d/m/Y H:i', $file->getMTime()),
                    'image'    => in_array($ext, self::IMAGE_EXT, true),
                ];
            }
        }

        usort($unused, fn ($a, $b) => [$a['folder'], $b['size']] <=> [$b['folder'], $a['size']]);

        $tmp = $this->livewireTmpInfo();

        $result = [
            'scanned_at'     => now()->format('d/m/Y H:i:s'),
            'total_files'    => $totalFiles,
            'total_size'     => $totalSize,
            'unused'         => $unused,
            'unused_size'    => array_sum(array_column($unused, 'size')),
            'skipped_recent' => $skippedRecent,
            'tmp_count'      => $tmp['count'],
            'tmp_size'       => $tmp['size'],
        ];

        File::put($this->resultFile(), json_encode($result, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));

        return $result;
    }

    public function lastResult(): ?array
    {
        $file = $this->resultFile();
        if (!is_file($file)) {
            return null;
        }

        $data = json_decode((string) file_get_contents($file), true);

        return is_array($data) ? $data : null;
    }

    public function forgetResult(): void
    {
        File::delete($this->resultFile());
    }

    /**
     * Move os arquivos escolhidos para a lixeira, mantendo a estrutura de pastas.
     * Só aceita caminhos que vieram da última varredura.
     */
    public function moveToTrash(array $paths): array
    {
        $result = $this->lastResult();
        if (!$result) {
            return ['moved' => 0, 'size' => 0];
        }

        $allowed = array_flip(array_column($result['unused'], 'path'));
        $root = realpath($this->storageRoot());
        $batch = $this->trashRoot() . '/' . date('Y-m-d_His');

        $moved = 0;
        $size = 0;
        $movedPaths = [];

        foreach (array_unique($paths) as $rel) {
            if (!isset($allowed[$rel])) {
                continue;
            }

            $src = realpath($root . '/' . $rel);
            if ($src === false || !str_starts_with($src, $root . DIRECTORY_SEPARATOR) || !is_file($src)) {
                continue;
            }

            $dest = $batch . '/' . $rel;
            File::ensureDirectoryExists(dirname($dest));
            $bytes = filesize($src);

            if (@rename($src, $dest) || (@copy($src, $dest) && @unlink($src))) {
                $moved++;
                $size += $bytes;
                $movedPaths[$rel] = true;
            }
        }

        // Atualiza o resultado salvo para não listar o que já saiu.
        $result['unused'] = array_values(array_filter($result['unused'], fn ($i) => !isset($movedPaths[$i['path']])));
        $result['unused_size'] = array_sum(array_column($result['unused'], 'size'));
        File::put($this->resultFile(), json_encode($result, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));

        $this->removeEmptyDirs($this->storageRoot());

        return ['moved' => $moved, 'size' => $size];
    }

    /**
     * Lotes que estão na lixeira.
     */
    public function trashBatches(): array
    {
        $root = $this->trashRoot();
        if (!is_dir($root)) {
            return [];
        }

        $batches = [];
        foreach (File::directories($root) as $dir) {
            $files = File::allFiles($dir);
            $batches[] = [
                'id'    => basename($dir),
                'label' => \DateTime::createFromFormat('Y-m-d_His', basename($dir))?->format('d/m/Y H:i:s') ?? basename($dir),
                'count' => count($files),
                'size'  => array_sum(array_map(fn ($f) => $f->getSize(), $files)),
            ];
        }

        usort($batches, fn ($a, $b) => strcmp($b['id'], $a['id']));

        return $batches;
    }

    /**
     * Devolve um lote da lixeira para public/storage.
     */
    public function restoreBatch(string $id): int
    {
        $dir = $this->batchDir($id);
        if (!$dir) {
            return 0;
        }

        $restored = 0;
        foreach (File::allFiles($dir) as $file) {
            $rel = $this->relativePath($file->getPathname(), $dir);
            $dest = $this->storageRoot() . '/' . $rel;

            if (file_exists($dest)) {
                continue;
            }

            File::ensureDirectoryExists(dirname($dest));
            if (@rename($file->getPathname(), $dest)) {
                $restored++;
            }
        }

        $this->removeEmptyDirs($dir);
        if (is_dir($dir) && count(File::allFiles($dir)) === 0) {
            File::deleteDirectory($dir);
        }

        // Força nova varredura, pois os arquivos voltaram.
        $this->forgetResult();

        return $restored;
    }

    /**
     * Exclui de vez um lote (ou todos, se $id for null).
     */
    public function emptyTrash(?string $id = null): int
    {
        $bytes = 0;

        $dirs = $id ? array_filter([$this->batchDir($id)]) : (is_dir($this->trashRoot()) ? File::directories($this->trashRoot()) : []);

        foreach ($dirs as $dir) {
            foreach (File::allFiles($dir) as $f) {
                $bytes += $f->getSize();
            }
            File::deleteDirectory($dir);
        }

        return $bytes;
    }

    /**
     * Uploads temporários do Livewire com mais de 24h.
     */
    public function livewireTmpInfo(): array
    {
        $dir = storage_path('app/livewire-tmp');
        $count = 0;
        $size = 0;
        $limit = time() - 86400;

        if (is_dir($dir)) {
            foreach (File::files($dir) as $f) {
                if ($f->getMTime() < $limit && $f->getFilename() !== '.gitignore') {
                    $count++;
                    $size += $f->getSize();
                }
            }
        }

        return ['count' => $count, 'size' => $size];
    }

    public function cleanLivewireTmp(): array
    {
        $dir = storage_path('app/livewire-tmp');
        $count = 0;
        $size = 0;
        $limit = time() - 86400;

        if (is_dir($dir)) {
            foreach (File::files($dir) as $f) {
                if ($f->getMTime() < $limit && $f->getFilename() !== '.gitignore') {
                    $size += $f->getSize();
                    if (@unlink($f->getPathname())) {
                        $count++;
                    }
                }
            }
        }

        $result = $this->lastResult();
        if ($result) {
            $result['tmp_count'] = 0;
            $result['tmp_size'] = 0;
            File::put($this->resultFile(), json_encode($result, JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES));
        }

        return ['count' => $count, 'size' => $size];
    }

    /* ----------------------------------------------------------------- */
    /* CACHE                                                              */
    /* ----------------------------------------------------------------- */

    /**
     * Limpa os caches do Laravel (config, rotas, views, eventos, cache da aplicação)
     * e do PHP. Devolve a lista do que foi feito.
     */
    public function clearCache(): array
    {
        $done = [];

        try {
            Artisan::call('optimize:clear');
            $done[] = 'config, rotas, views e eventos do Laravel';
        } catch (\Throwable $e) {
            foreach (['config:clear' => 'config', 'route:clear' => 'rotas', 'view:clear' => 'views', 'cache:clear' => 'cache da aplicação'] as $cmd => $label) {
                try {
                    Artisan::call($cmd);
                    $done[] = $label;
                } catch (\Throwable $e) {
                }
            }
        }

        try {
            Artisan::call('filament:clear-cached-components');
            $done[] = 'componentes do Filament';
        } catch (\Throwable $e) {
        }

        if (function_exists('opcache_reset') && @opcache_reset()) {
            $done[] = 'OPcache do PHP';
        }
        if (function_exists('apcu_clear_cache') && @apcu_clear_cache()) {
            $done[] = 'APCu';
        }
        clearstatcache(true);

        return $done;
    }

    /* ----------------------------------------------------------------- */
    /* LOGS                                                               */
    /* ----------------------------------------------------------------- */

    /** Logs do Laravel (storage/logs) e error_log soltos em public/. */
    public function logs(): array
    {
        $list = [];

        $dirs = [storage_path('logs')];
        foreach ($dirs as $dir) {
            if (!is_dir($dir)) {
                continue;
            }
            foreach (File::allFiles($dir) as $f) {
                if (preg_match('/\.(log|txt)$/i', $f->getFilename()) || $f->getFilename() === 'error_log') {
                    $list[] = ['path' => $this->relativePath($f->getPathname(), base_path()), 'size' => $f->getSize()];
                }
            }
        }

        foreach ([base_path('error_log'), public_path('error_log'), public_path('logs.txt')] as $f) {
            if (is_file($f)) {
                $list[] = ['path' => $this->relativePath($f, base_path()), 'size' => filesize($f)];
            }
        }

        usort($list, fn ($a, $b) => $b['size'] <=> $a['size']);

        return $list;
    }

    /**
     * Zera os logs escolhidos. Arquivos diários antigos (laravel-AAAA-MM-DD.log)
     * são apagados; os demais são esvaziados, pois o sistema continua escrevendo neles.
     */
    public function clearLogs(array $paths): array
    {
        $valid = array_column($this->logs(), 'size', 'path');
        $count = 0;
        $size = 0;
        $today = 'laravel-' . date('Y-m-d') . '.log';

        foreach (array_unique($paths) as $rel) {
            if (!isset($valid[$rel])) {
                continue;
            }
            $full = base_path($rel);
            $name = basename($full);

            $ok = preg_match('/^laravel-\d{4}-\d{2}-\d{2}\.log$/', $name) && $name !== $today
                ? @unlink($full)
                : (@file_put_contents($full, '') !== false);

            if ($ok) {
                $count++;
                $size += $valid[$rel];
            }
        }

        return ['count' => $count, 'size' => $size];
    }

    public static function formatBytes(int|float $bytes): string
    {
        $units = ['B', 'KB', 'MB', 'GB'];
        $i = 0;
        while ($bytes >= 1024 && $i < count($units) - 1) {
            $bytes /= 1024;
            $i++;
        }

        return number_format($bytes, $i === 0 ? 0 : 1, ',', '.') . ' ' . $units[$i];
    }

    /* ----------------------------------------------------------------- */

    /**
     * Junta todos os nomes de arquivo citados no banco e no código.
     * Guarda nomes (basename) e caminhos relativos encontrados.
     */
    protected function collectReferenceTokens(): array
    {
        $tokens = [];

        // 1) Banco de dados: todas as colunas de texto de todas as tabelas.
        $database = DB::connection()->getDatabaseName();
        $columns = DB::select(
            "SELECT TABLE_NAME AS t, COLUMN_NAME AS c FROM information_schema.COLUMNS
             WHERE TABLE_SCHEMA = ? AND DATA_TYPE IN ('char','varchar','tinytext','text','mediumtext','longtext','json')",
            [$database]
        );

        $byTable = [];
        foreach ($columns as $col) {
            $byTable[$col->t][] = $col->c;
        }

        foreach ($byTable as $table => $cols) {
            $select = implode(', ', array_map(fn ($c) => '`' . str_replace('`', '``', $c) . '`', $cols));
            $offset = 0;
            $chunk = 2000;

            do {
                $rows = DB::select("SELECT {$select} FROM `" . str_replace('`', '``', $table) . "` LIMIT {$chunk} OFFSET {$offset}");
                foreach ($rows as $row) {
                    foreach ((array) $row as $value) {
                        if (is_string($value) && $value !== '') {
                            $this->extractTokens($value, $tokens);
                        }
                    }
                }
                $offset += $chunk;
            } while (count($rows) === $chunk);
        }

        // 2) Código e assets compilados.
        foreach (self::CODE_DIRS as $dir) {
            $path = base_path($dir);
            if (!is_dir($path)) {
                continue;
            }

            $it = new \RecursiveIteratorIterator(
                new \RecursiveDirectoryIterator($path, \FilesystemIterator::SKIP_DOTS)
            );

            foreach ($it as $file) {
                if (!$file->isFile()) {
                    continue;
                }

                $name = $file->getFilename();
                $ext = strtolower($file->getExtension());
                if (!in_array($ext, self::CODE_EXT, true) && !str_ends_with($name, '.blade.php')) {
                    continue;
                }

                if ($file->getSize() > 30 * 1024 * 1024) {
                    continue;
                }

                $content = @file_get_contents($file->getPathname());
                if ($content !== false) {
                    $this->extractTokens($content, $tokens);
                }
            }
        }

        return $tokens;
    }

    /**
     * Extrai trechos com cara de arquivo (nome.ext ou pasta/nome.ext).
     */
    protected function extractTokens(string $text, array &$tokens): void
    {
        if (str_contains($text, '%')) {
            $text .= ' ' . rawurldecode($text);
        }
        $text = str_replace('\\/', '/', $text);

        if (preg_match_all('~[\w\-.@+]+\.[A-Za-z0-9]{2,5}(?![A-Za-z0-9])~', $text, $m)) {
            foreach ($m[0] as $base) {
                $tokens[strtolower($base)] = true;
            }
        }
    }

    protected function isReferenced(string $rel, string $name, array $tokens): bool
    {
        return isset($tokens[strtolower($name)]);
    }

    protected function relativePath(string $path, string $root): string
    {
        return ltrim(str_replace('\\', '/', substr($path, strlen($root))), '/');
    }

    protected function batchDir(string $id): ?string
    {
        if (!preg_match('/^\d{4}-\d{2}-\d{2}_\d{6}$/', $id)) {
            return null;
        }

        $dir = $this->trashRoot() . '/' . $id;

        return is_dir($dir) ? $dir : null;
    }

    protected function removeEmptyDirs(string $root): void
    {
        if (!is_dir($root)) {
            return;
        }

        $it = new \RecursiveIteratorIterator(
            new \RecursiveDirectoryIterator($root, \FilesystemIterator::SKIP_DOTS),
            \RecursiveIteratorIterator::CHILD_FIRST
        );

        foreach ($it as $item) {
            if ($item->isDir() && !$item->isLink() && count(scandir($item->getPathname())) === 2) {
                @rmdir($item->getPathname());
            }
        }
    }
}
