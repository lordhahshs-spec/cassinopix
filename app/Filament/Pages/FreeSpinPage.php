<?php

namespace App\Filament\Pages;

use App\Models\FreeSpinConfig;
use App\Models\Game;
use App\Models\User;
use App\Services\FreeSpins;
use Filament\Actions\Action;
use Filament\Forms\Components\Placeholder;
use Filament\Forms\Components\Section;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Forms\Concerns\InteractsWithForms;
use Filament\Forms\Form;
use Filament\Notifications\Notification;
use Filament\Pages\Page;

class FreeSpinPage extends Page
{
    use InteractsWithForms;

    protected static ?string $navigationIcon = 'heroicon-o-play-circle';
    protected static ?string $navigationGroup = 'Roleta';
    protected static ?string $navigationLabel = 'Free Spins';
    protected static ?string $title = 'Free Spins por depósito';
    protected static ?string $slug = 'free-spins';
    protected static ?int $navigationSort = 5;

    protected static string $view = 'filament.pages.roulette-page';

    public ?array $data = [];

    public static function canAccess(): bool
    {
        return auth()->user()->hasRole('admin');
    }

    public function mount(): void
    {
        $this->form->fill(FreeSpinConfig::current()->toArray());
    }

    /** Busca de jogos: "Nome — PROVEDOR" */
    public static function searchGames(string $search): array
    {
        return Game::query()->with('provider')
            ->where(function ($q) use ($search) {
                $q->where('game_name', 'like', "%{$search}%")->orWhere('game_code', 'like', "%{$search}%");
            })
            ->limit(40)->get()
            ->mapWithKeys(fn ($g) => [$g->id => $g->game_name . ' — ' . ($g->provider->name ?? $g->provider->code ?? '')])
            ->toArray();
    }

    public static function gameLabel($id): ?string
    {
        $g = Game::with('provider')->find($id);
        return $g ? $g->game_name . ' — ' . ($g->provider->name ?? $g->provider->code ?? '') : null;
    }

    private static function betsHint($gameId): string
    {
        $g = $gameId ? Game::find($gameId) : null;
        if (!$g) return 'Escolha o jogo para ver as apostas aceitas.';
        $bets = FreeSpins::betsFor((string) $g->game_code);
        return $bets
            ? 'Aceitas neste jogo: ' . implode(', ', array_map(fn ($b) => 'R$ ' . number_format($b, 2, ',', '.'), $bets)) . '. Outro valor é ajustado para o mais próximo.'
            : 'Vazio = menor aposta do jogo. Valor fora da lista é ajustado para o mais próximo.';
    }

    public function form(Form $form): Form
    {
        return $form
            ->schema([
                Section::make('Free Spins automáticos no depósito')
                    ->description('Quando o PIX cai (webhook), o jogador recebe as rodadas grátis no jogo escolhido. Só PG Soft, Pragmatic Play e Minigames aceitam free spins na ProftGames.')
                    ->schema([
                        Toggle::make('active')->label('Ativo')->columnSpanFull(),
                        Select::make('game_id')->label('Jogo')
                            ->searchable()
                            ->getSearchResultsUsing(fn (string $search) => self::searchGames($search))
                            ->getOptionLabelUsing(fn ($value) => self::gameLabel($value))
                            ->live()
                            ->required(fn ($get) => (bool) $get('active'))
                            ->columnSpan(2),
                        TextInput::make('rounds')->label('Rodadas grátis')->numeric()->minValue(1)->required(),
                        TextInput::make('bet')->label('Valor por giro')->numeric()->minValue(0)->prefix('R$')
                            ->helperText(fn ($get) => self::betsHint($get('game_id'))),
                        TextInput::make('min_deposit')->label('Depósito mínimo')->numeric()->minValue(0)->prefix('R$')->required(),
                        TextInput::make('max_times')->label('Quantas vezes cada jogador pode ganhar')->numeric()->minValue(0)->required()
                            ->helperText('0 = ilimitado (ganha em todo depósito acima do mínimo)'),
                        TextInput::make('expire_days')->label('Validade (dias)')->numeric()->minValue(1)->required(),
                        TextInput::make('win_rollover')->label('Rollover dos ganhos (x)')->numeric()->minValue(0)
                            ->helperText('Vazio = rollover de bônus das Configurações. 0 = sem rollover.'),
                    ])->columns(3),
            ])
            ->statePath('data');
    }

    public function submit(): void
    {
        $data = $this->form->getState();
        $game = !empty($data['game_id']) ? Game::find($data['game_id']) : null;
        $data['game_code'] = $game?->game_code;
        $data['game_name'] = $game?->game_name;
        foreach (['bet', 'win_rollover'] as $k) {
            if (($data[$k] ?? '') === '') $data[$k] = null;
        }
        FreeSpinConfig::current()->update($data);

        Notification::make()->title('Free spins atualizados')->success()->send();
    }

    protected function getHeaderActions(): array
    {
        return [
            Action::make('dar_free_spins')
                ->label('Dar free spins')
                ->icon('heroicon-o-gift')
                ->color('success')
                ->form([
                    Select::make('user_id')->label('Jogador')->searchable()->required()
                        ->getSearchResultsUsing(fn (string $search) => User::where('email', 'like', "%{$search}%")
                            ->orWhere('name', 'like', "%{$search}%")->orWhere('id', $search)
                            ->limit(30)->pluck('email', 'id')->toArray())
                        ->getOptionLabelUsing(fn ($value) => optional(User::find($value))->email),
                    Select::make('game_id')->label('Jogo')->searchable()->required()
                        ->getSearchResultsUsing(fn (string $search) => self::searchGames($search))
                        ->getOptionLabelUsing(fn ($value) => self::gameLabel($value))
                        ->default(fn () => FreeSpinConfig::current()->game_id),
                    TextInput::make('rounds')->label('Rodadas')->numeric()->minValue(1)->required()
                        ->default(fn () => FreeSpinConfig::current()->rounds),
                    TextInput::make('bet')->label('Valor por giro')->numeric()->minValue(0)->prefix('R$')
                        ->default(fn () => FreeSpinConfig::current()->bet),
                    TextInput::make('days')->label('Validade (dias)')->numeric()->minValue(1)->required()
                        ->default(fn () => FreeSpinConfig::current()->expire_days),
                ])
                ->action(function (array $data) {
                    $user = User::find($data['user_id']);
                    $game = Game::find($data['game_id']);
                    if (!$user || !$game) {
                        Notification::make()->title('Jogador ou jogo inválido')->danger()->send();
                        return;
                    }
                    $fs = FreeSpins::grant($user, $game, (string) $game->game_code, (string) $game->game_name,
                        (int) $data['rounds'], !empty($data['bet']) ? (float) $data['bet'] : null, (int) $data['days'], 'admin');

                    $fs->status === 'active'
                        ? Notification::make()->title("{$fs->rounds} free spins enviados para {$user->email}")->success()->send()
                        : Notification::make()->title($fs->status === 'pending' ? 'Pacote criado — será enviado quando o jogador abrir um jogo' : 'Não foi possível enviar')
                            ->body($fs->error)->warning()->send();
                }),
        ];
    }
}
