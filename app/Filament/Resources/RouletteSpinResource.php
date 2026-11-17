<?php

namespace App\Filament\Resources;

use App\Filament\Resources\RouletteSpinResource\Pages;
use App\Models\RouletteSpin;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class RouletteSpinResource extends Resource
{
    protected static ?string $model = RouletteSpin::class;
    protected static ?string $navigationIcon = 'heroicon-o-ticket';
    protected static ?string $navigationGroup = 'Roleta';
    protected static ?string $navigationLabel = 'Giros';
    protected static ?string $pluralModelLabel = 'Giros';
    protected static ?string $slug = 'roleta-giros';
    protected static ?int $navigationSort = 3;

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
            ->modifyQueryUsing(fn ($query) => $query->where('spins_available', '>', 0))
            ->columns([
                Tables\Columns\TextColumn::make('user.email')->label('Jogador')->searchable(),
                Tables\Columns\TextColumn::make('spins_available')->label('Giros'),
                Tables\Columns\TextColumn::make('reason')->label('Origem'),
                Tables\Columns\TextColumn::make('expires_at')->label('Expira em')->dateTime('d/m/Y H:i')->placeholder('Não expira'),
                Tables\Columns\TextColumn::make('created_at')->label('Recebido em')->dateTime('d/m/Y H:i'),
            ])
            ->actions([Tables\Actions\DeleteAction::make()->label('Remover')]);
    }

    public static function getPages(): array
    {
        return ['index' => Pages\ListRouletteSpin::route('/')];
    }
}
