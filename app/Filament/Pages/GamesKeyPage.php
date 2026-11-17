<?php

namespace App\Filament\Pages;

use App\Models\GamesKey;
use App\Http\Controllers\Api\Games\GameController;
use Filament\Actions\Action;
use Filament\Forms\Components\Checkbox;
use Filament\Forms\Components\Grid;
use Filament\Forms\Components\Placeholder;
use Filament\Forms\Set;
use Filament\Forms\Components\Section;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Concerns\InteractsWithForms;
use Filament\Forms\Contracts\HasForms;
use Filament\Forms\Form;
use Filament\Notifications\Notification;
use Filament\Pages\Page;
use Filament\Support\Exceptions\Halt;
use Illuminate\Support\HtmlString;

class GamesKeyPage extends Page implements HasForms
{
    use InteractsWithForms;

    protected static ?string $navigationIcon = 'heroicon-o-document-text';
    protected static string $view = 'filament.pages.games-key-page';
    protected static ?string $title = 'API';

    public ?array $data = [];
    public ?GamesKey $setting;

    public static function canAccess(): bool
    {
        return auth()->user()->hasRole('admin');
    }

    public function mount(): void
    {
        $gamesKey = GamesKey::first();
        if (!empty($gamesKey)) {
            $this->setting = $gamesKey;
            $this->form->fill($this->setting->toArray());
        } else {
            $this->form->fill();
        }
    }

    public function form(Form $form): Form
    {
        return $form
            ->schema([

                Section::make('PROFTGAMES API')
                    ->description(new HtmlString('
                        <div style="display:flex;align-items:center;flex-wrap:wrap;gap:10px;">
                            Catálogo de slots, pesca e originais com callback próprio.
                            <a class="dark:text-white"
                               style="font-size:14px;font-weight:600;display:flex;background-color:#16a34a;padding:10px 16px;border-radius:11px;justify-content:center;"
                               href="https://proftgames.com" target="_blank">PAINEL PROFTGAMES</a>
                            <a class="dark:text-white"
                               style="font-size:14px;font-weight:600;display:flex;background-color:#334155;padding:10px 16px;border-radius:11px;justify-content:center;"
                               href="https://proftgames.com/docs" target="_blank">DOCUMENTAÇÃO</a>
                        </div>
                    '))
                    ->schema([
                        Section::make('CHAVES DE ACESSO PROFTGAMES')
                            ->description('Crie o agente no painel da ProftGames e cole aqui o nome do agente, o agentToken e a secretKey.')
                            ->schema([
                                TextInput::make('proftgames_code')
                                    ->label('NOME DO AGENTE (agent_code)')
                                    ->placeholder('Ex.: MEU-AGENTE')
                                    ->maxLength(191),
                                TextInput::make('proftgames_token')
                                    ->label('AGENT TOKEN')
                                    ->placeholder('Digite aqui o agentToken')
                                    ->maxLength(191),
                                TextInput::make('proftgames_secret')
                                    ->label('SECRET KEY')
                                    ->placeholder('Digite aqui a secretKey')
                                    ->password()
                                    ->revealable()
                                    ->maxLength(191),
                            ])->columns(3),

                        Section::make('CALLBACK URL')
                            ->description('Cole esta URL no campo "callback_url" do agente na ProftGames (termina com /).')
                            ->schema([
                                Placeholder::make('proftgames_callback_url')
                                    ->label('')
                                    ->content(function () {
                                        $url = GameController::proftGamesCallbackUrl();
                                        return new HtmlString('<code style="font-size:14px;user-select:all;word-break:break-all;">' . e($url) . '</code>');
                                    }),
                            ]),
                    ]),
            ])
            ->statePath('data');
    }

    /** Chave de campo segura para o código do provedor (tem espaço, ex.: "PRAGMATIC PLAY"). */
    private static function provKey(string $code): string
    {
        return substr(md5($code), 0, 12);
    }

    protected function getHeaderActions(): array
    {
        return [
            Action::make('importProftGames')
                ->label('Importar jogos ProftGames')
                ->icon('heroicon-o-arrow-down-tray')
                ->modalHeading('Importar catálogo ProftGames')
                ->modalDescription('Marque quais provedores importar e se eles entram ativos. Provedor desmarcado em "Importar" não é tocado.')
                ->modalWidth('2xl')
                ->slideOver()
                ->modalSubmitActionLabel('Importar selecionados')
                ->form(function () {
                    try {
                        $list = GameController::proftGamesProviderList();
                    } catch (\Throwable $e) {
                        return [
                            Placeholder::make('proft_erro')
                                ->label('')
                                ->content('Não consegui ler o catálogo da ProftGames: ' . $e->getMessage()),
                        ];
                    }

                    $keys = array_map(fn($p) => self::provKey($p['code']), $list);
                    $total = array_sum(array_column($list, 'games'));

                    $rows = [
                        Grid::make(['default' => 3])->schema([
                            Placeholder::make('proft_head')
                                ->label('')
                                ->content(new HtmlString('<b>' . count($list) . ' provedores · ' . $total . ' jogos</b>')),
                            Checkbox::make('all_import')
                                ->label('Importar todos')
                                ->default(true)
                                ->live()
                                ->afterStateUpdated(function ($state, Set $set) use ($keys) {
                                    foreach ($keys as $k) $set('imp_' . $k, (bool)$state);
                                }),
                            Checkbox::make('all_active')
                                ->label('Todos ativos')
                                ->default(true)
                                ->live()
                                ->afterStateUpdated(function ($state, Set $set) use ($keys) {
                                    foreach ($keys as $k) $set('act_' . $k, (bool)$state);
                                }),
                        ]),
                    ];

                    foreach ($list as $p) {
                        $k = self::provKey($p['code']);
                        $info = $p['games'] . ' ' . ($p['games'] == 1 ? 'jogo' : 'jogos') . ($p['exists'] ? '' : ' · novo');
                        $rows[] = Grid::make(['default' => 3])->schema([
                            Placeholder::make('lbl_' . $k)
                                ->label('')
                                ->content(new HtmlString('<span style="font-weight:600">' . e($p['name']) . '</span><br><span style="font-size:12px;opacity:.65">' . e($info) . '</span>')),
                            Checkbox::make('imp_' . $k)
                                ->label('Importar')
                                ->default(true),
                            Checkbox::make('act_' . $k)
                                ->label('Ativo')
                                ->default((bool)$p['active']),
                        ]);
                    }

                    return $rows;
                })
                ->action(function (array $data) {
                    try {
                        $selection = [];
                        foreach (GameController::proftGamesProviderList() as $p) {
                            $k = self::provKey($p['code']);
                            $selection[$p['code']] = [
                                'import' => !empty($data['imp_' . $k]),
                                'active' => !empty($data['act_' . $k]),
                            ];
                        }

                        if (!array_filter(array_column($selection, 'import'))) {
                            Notification::make()->title('Nenhum provedor marcado')->warning()->send();
                            return;
                        }

                        $r = GameController::proftGamesImport($selection);
                        Notification::make()
                            ->title('Catálogo importado')
                            ->body("Provedores: {$r['providers']} · Novos: {$r['created']} · Atualizados: {$r['updated']} · Desativados: {$r['disabled']} · Capas baixadas: {$r['downloaded']}")
                            ->success()
                            ->send();
                    } catch (\Throwable $e) {
                        Notification::make()
                            ->title('Erro ao importar')
                            ->body($e->getMessage())
                            ->danger()
                            ->send();
                    }
                }),
        ];
    }

    public function submit(): void
    {
        try {
            if (env('APP_DEMO')) {
                Notification::make()
                    ->title('Atenção')
                    ->body('Você não pode realizar esta alteração na versão demo')
                    ->danger()
                    ->send();
                return;
            }


            $setting = GamesKey::first();

            if (!empty($setting)) {
                if ($setting->update($this->data)) {
                    Notification::make()
                        ->title('Chaves Alteradas')
                        ->body('Suas chaves foram alteradas com sucesso!')
                        ->success()
                        ->send();
                }
            } else {
                if (GamesKey::create($this->data)) {
                    Notification::make()
                        ->title('Chaves Criadas')
                        ->body('Suas chaves foram criadas com sucesso!')
                        ->success()
                        ->send();
                }
            }
        } catch (Halt $exception) {
            Notification::make()
                ->title('Erro ao alterar dados!')
                ->body('Erro ao alterar dados!')
                ->danger()
                ->send();
        }
    }
}
