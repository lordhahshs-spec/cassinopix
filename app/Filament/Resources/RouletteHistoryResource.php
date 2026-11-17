<?php

namespace App\Filament\Resources;

use App\Filament\Resources\RouletteHistoryResource\Pages;
use App\Models\RouletteHistory;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class RouletteHistoryResource extends Resource
{
    protected static ?string $model = RouletteHistory::class;
    protected static ?string $navigationIcon = 'heroicon-o-clock';
    protected static ?string $navigationGroup = 'Roleta';
    protected static ?string $navigationLabel = 'Histórico';
    protected static ?string $pluralModelLabel = 'Histórico';
    protected static ?string $slug = 'roleta-historico';
    protected static ?int $navigationSort = 4;

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
        return $table
            ->defaultSort('id', 'desc')
            ->columns([
                Tables\Columns\TextColumn::make('user.email')->label('Jogador')->searchable(),
                Tables\Columns\TextColumn::make('prize_name')->label('Prêmio'),
                Tables\Columns\TextColumn::make('prize_value')->label('Valor')->money('BRL'),
                Tables\Columns\TextColumn::make('created_at')->label('Data')->dateTime('d/m/Y H:i'),
            ])
            ->actions([]);
    }

    public static function getPages(): array
    {
        return ['index' => Pages\ListRouletteHistory::route('/')];
    }
}
