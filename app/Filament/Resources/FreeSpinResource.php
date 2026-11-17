<?php

namespace App\Filament\Resources;

use App\Filament\Resources\FreeSpinResource\Pages;
use App\Models\FreeSpin;
use App\Services\FreeSpins;
use Filament\Notifications\Notification;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class FreeSpinResource extends Resource
{
    protected static ?string $model = FreeSpin::class;
    protected static ?string $navigationIcon = 'heroicon-o-queue-list';
    protected static ?string $navigationGroup = 'Roleta';
    protected static ?string $navigationLabel = 'Pacotes de Free Spins';
    protected static ?string $pluralModelLabel = 'Pacotes de Free Spins';
    protected static ?string $slug = 'free-spins-pacotes';
    protected static ?int $navigationSort = 6;

    public static function canAccess(): bool
    {
        return auth()->user()->hasRole('admin');
    }

    public static function canCreate(): bool
    {
        return false;
    }

    public static function table(Table $table): Table
    {
        $status = ['pending' => 'Aguardando', 'active' => 'Ativo', 'completed' => 'Usado', 'expired' => 'Expirado', 'cancelled' => 'Cancelado', 'failed' => 'Falhou'];

        return $table
            ->defaultSort('id', 'desc')
            ->columns([
                Tables\Columns\TextColumn::make('user.email')->label('Jogador')->searchable(),
                Tables\Columns\TextColumn::make('game_name')->label('Jogo')->searchable(),
                Tables\Columns\TextColumn::make('rounds_played')->label('Rodadas')
                    ->formatStateUsing(fn ($state, FreeSpin $r) => "{$r->rounds_played}/{$r->rounds}"),
                Tables\Columns\TextColumn::make('bet')->label('Por giro')->money('BRL'),
                Tables\Columns\TextColumn::make('total_win')->label('Ganhou')->money('BRL'),
                Tables\Columns\TextColumn::make('status')->label('Status')->badge()
                    ->formatStateUsing(fn ($state) => $status[$state] ?? $state)
                    ->color(fn ($state) => match ($state) {
                        'active' => 'success', 'completed' => 'gray', 'pending' => 'warning', 'failed' => 'danger', default => 'gray',
                    })
                    ->tooltip(fn (FreeSpin $r) => $r->error),
                Tables\Columns\TextColumn::make('origin')->label('Origem')
                    ->formatStateUsing(fn ($state) => ['deposit' => 'Depósito', 'admin' => 'Admin'][$state] ?? $state),
                Tables\Columns\TextColumn::make('expires_at')->label('Expira')->dateTime('d/m/Y H:i'),
                Tables\Columns\TextColumn::make('created_at')->label('Criado')->dateTime('d/m/Y H:i'),
            ])
            ->filters([
                Tables\Filters\SelectFilter::make('status')->options($status),
            ])
            ->actions([
                Tables\Actions\Action::make('reenviar')->label('Reenviar')->icon('heroicon-o-arrow-path')
                    ->visible(fn (FreeSpin $r) => in_array($r->status, ['pending', 'failed']))
                    ->action(function (FreeSpin $r) {
                        $r->update(['status' => 'pending']);
                        FreeSpins::send($r)
                            ? Notification::make()->title('Enviado para a ProftGames')->success()->send()
                            : Notification::make()->title('Não enviado')->body($r->fresh()->error)->warning()->send();
                    }),
                Tables\Actions\Action::make('cancelar')->label('Cancelar')->icon('heroicon-o-x-mark')->color('danger')
                    ->requiresConfirmation()
                    ->visible(fn (FreeSpin $r) => in_array($r->status, ['pending', 'active', 'failed']))
                    ->action(function (FreeSpin $r) {
                        try {
                            FreeSpins::cancel($r);
                            Notification::make()->title('Pacote cancelado')->success()->send();
                        } catch (\Throwable $e) {
                            Notification::make()->title('Erro ao cancelar')->body($e->getMessage())->danger()->send();
                        }
                    }),
            ]);
    }

    public static function getPages(): array
    {
        return ['index' => Pages\ListFreeSpins::route('/')];
    }
}
