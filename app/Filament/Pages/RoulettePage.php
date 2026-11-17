<?php

namespace App\Filament\Pages;

use App\Models\RouletteConfig;
use App\Models\User;
use App\Services\Roulette;
use Filament\Actions\Action;
use Filament\Forms\Components\Section;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Forms\Concerns\InteractsWithForms;
use Filament\Forms\Form;
use Filament\Notifications\Notification;
use Filament\Pages\Page;

class RoulettePage extends Page
{
    use InteractsWithForms;

    protected static ?string $navigationIcon = 'heroicon-o-sparkles';
    protected static ?string $navigationGroup = 'Roleta';
    protected static ?string $navigationLabel = 'Configuração';
    protected static ?string $title = 'Roleta do Pix';
    protected static ?string $slug = 'roleta';
    protected static ?int $navigationSort = 1;

    protected static string $view = 'filament.pages.roulette-page';

    public ?array $data = [];

    public static function canAccess(): bool
    {
        return auth()->user()->hasRole('admin');
    }

    public function mount(): void
    {
        $this->form->fill(RouletteConfig::current()->toArray());
    }

    public function form(Form $form): Form
    {
        return $form
            ->schema([
                Section::make('Roleta')
                    ->description('Página /promotions do site (Roleta do Pix). Os prêmios ficam em Roleta › Prêmios (até 8 ativos, um por fatia).')
                    ->schema([
                        Toggle::make('active')->label('Roleta ativa'),
                        TextInput::make('spins_expire_days')->label('Validade dos giros (dias)')->numeric()->minValue(0)
                            ->helperText('0 = não expira')->required(),
                        TextInput::make('prize_rollover')->label('Rollover do prêmio (x)')->numeric()->minValue(0)
                            ->helperText('Vazio = usa o rollover de bônus das Configurações. 0 = prêmio sem rollover.'),
                    ])->columns(3),
                Section::make('Giros automáticos')
                    ->schema([
                        TextInput::make('signup_spins')->label('Giros no cadastro')->numeric()->minValue(0)->required()
                            ->helperText('0 = desligado'),
                        TextInput::make('deposit_spins')->label('Giros por depósito')->numeric()->minValue(0)->required()
                            ->helperText('0 = desligado'),
                        TextInput::make('deposit_min')->label('Depósito mínimo p/ ganhar giros')->numeric()->minValue(0)->prefix('R$')->required(),
                        TextInput::make('deposit_max_times')->label('Quantas vezes cada jogador ganha por depósito')->numeric()->minValue(0)->required()
                            ->helperText('0 = ilimitado (ganha em todo depósito acima do mínimo)'),
                    ])->columns(4),
            ])
            ->statePath('data');
    }

    public function submit(): void
    {
        $data = $this->form->getState();
        if (($data['prize_rollover'] ?? '') === '') {
            $data['prize_rollover'] = null;
        }
        RouletteConfig::current()->update($data);

        Notification::make()->title('Roleta atualizada')->success()->send();
    }

    protected function getHeaderActions(): array
    {
        return [
            Action::make('dar_giros')
                ->label('Dar giros')
                ->icon('heroicon-o-gift')
                ->color('success')
                ->form([
                    Select::make('target')->label('Para quem')->options([
                        'user' => 'Um jogador',
                        'all'  => 'Todos os jogadores',
                        'zero' => 'Só quem está sem giros',
                    ])->default('user')->live()->required(),
                    Select::make('user_id')->label('Jogador')
                        ->searchable()
                        ->getSearchResultsUsing(fn (string $search) => User::where('email', 'like', "%{$search}%")
                            ->orWhere('name', 'like', "%{$search}%")->orWhere('id', $search)
                            ->limit(30)->pluck('email', 'id')->toArray())
                        ->getOptionLabelUsing(fn ($value) => optional(User::find($value))->email)
                        ->visible(fn ($get) => $get('target') === 'user')
                        ->required(fn ($get) => $get('target') === 'user'),
                    TextInput::make('spins')->label('Quantidade de giros')->numeric()->minValue(1)->default(1)->required(),
                    TextInput::make('days')->label('Validade (dias)')->numeric()->minValue(0)
                        ->default(fn () => RouletteConfig::current()->spins_expire_days)->helperText('0 = não expira'),
                ])
                ->action(function (array $data) {
                    $spins = (int) $data['spins'];
                    $days = isset($data['days']) && $data['days'] !== '' ? (int) $data['days'] : null;

                    if ($data['target'] === 'user') {
                        Roulette::grant((int) $data['user_id'], $spins, 'Admin', $days);
                        $total = 1;
                    } else {
                        $total = 0;
                        User::query()->select('id')->chunkById(500, function ($users) use ($data, $spins, $days, &$total) {
                            foreach ($users as $u) {
                                if ($data['target'] === 'zero' && Roulette::spinsOf($u->id) > 0) {
                                    continue;
                                }
                                Roulette::grant($u->id, $spins, 'Admin', $days);
                                $total++;
                            }
                        });
                    }

                    Notification::make()->title("{$spins} giro(s) enviados para {$total} jogador(es)")->success()->send();
                }),
        ];
    }
}
