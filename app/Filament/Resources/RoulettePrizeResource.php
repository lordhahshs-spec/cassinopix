<?php

namespace App\Filament\Resources;

use App\Filament\Resources\RoulettePrizeResource\Pages;
use App\Models\RoulettePrize;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;

class RoulettePrizeResource extends Resource
{
    protected static ?string $model = RoulettePrize::class;
    protected static ?string $navigationIcon = 'heroicon-o-trophy';
    protected static ?string $navigationGroup = 'Roleta';
    protected static ?string $navigationLabel = 'Prêmios';
    protected static ?string $modelLabel = 'Prêmio';
    protected static ?string $pluralModelLabel = 'Prêmios da roleta';
    protected static ?string $slug = 'roleta-premios';
    protected static ?int $navigationSort = 2;

    public static function canAccess(): bool
    {
        return auth()->user()->hasRole('admin');
    }

    public static function form(Form $form): Form
    {
        return $form->schema([
            Forms\Components\Section::make()
                ->description('A roda tem 8 fatias: vale a ordem de cadastro e só os 8 primeiros ativos aparecem. Com menos de 8 eles se repetem.')
                ->schema([
                    Forms\Components\TextInput::make('name')->label('Texto na fatia')->placeholder('R$ 5,00')->required()->maxLength(20),
                    Forms\Components\TextInput::make('value')->label('Valor creditado')->numeric()->minValue(0)->prefix('R$')->required()
                        ->helperText('0 = fatia sem prêmio (ex.: "Perdeu")'),
                    Forms\Components\TextInput::make('probability')->label('Peso / chance')->numeric()->minValue(0)->required()
                        ->helperText('Quanto maior, mais sai. A chance real é o peso dividido pela soma dos pesos.'),
                    Forms\Components\Toggle::make('status')->label('Ativo')->default(true),
                ])->columns(2),
        ]);
    }

    public static function table(Table $table): Table
    {
        return $table
            ->defaultSort('id')
            ->columns([
                Tables\Columns\TextColumn::make('id')->label('#'),
                Tables\Columns\TextColumn::make('name')->label('Fatia')->searchable(),
                Tables\Columns\TextColumn::make('value')->label('Valor')->money('BRL'),
                Tables\Columns\TextColumn::make('probability')->label('Peso'),
                Tables\Columns\TextColumn::make('chance')->label('Chance')
                    ->state(function (RoulettePrize $record) {
                        $sum = RoulettePrize::where('status', 1)->orderBy('id')->limit(8)->pluck('probability')->sum();
                        return $record->status && $sum > 0 ? number_format($record->probability / $sum * 100, 1, ',', '.') . '%' : '—';
                    }),
                Tables\Columns\ToggleColumn::make('status')->label('Ativo'),
            ])
            ->actions([
                Tables\Actions\EditAction::make(),
                Tables\Actions\DeleteAction::make(),
            ]);
    }

    public static function getPages(): array
    {
        return [
            'index'  => Pages\ListRoulettePrizes::route('/'),
            'create' => Pages\CreateRoulettePrize::route('/create'),
            'edit'   => Pages\EditRoulettePrize::route('/{record}/edit'),
        ];
    }
}
