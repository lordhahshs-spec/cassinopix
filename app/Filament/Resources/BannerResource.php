<?php

namespace App\Filament\Resources;

use App\Filament\Resources\BannerResource\Pages;
use App\Filament\Resources\BannerResource\RelationManagers;
use App\Models\Banner;
use Filament\Forms;
use Filament\Forms\Form;
use Filament\Resources\Resource;
use Filament\Tables;
use Filament\Tables\Table;
use Illuminate\Database\Eloquent\Builder;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\SoftDeletingScope;

class BannerResource extends Resource
{
    protected static ?string $model = Banner::class;

    protected static ?string $navigationIcon = 'heroicon-o-paint-brush';

    /**
     * @dev @victormsalatiel
     * @return bool
     */
    public static function canAccess(): bool
    {
        return auth()->user()->hasRole('admin');
    }

    /**
     * @param Form $form
     * @return Form
     */
    public static function form(Form $form): Form
    {
        return $form
            ->schema([
                Forms\Components\Section::make()
                    ->description('')
                    ->schema([
                        Forms\Components\Group::make()->schema([
                            Forms\Components\Group::make()
                            ->schema([
                                Forms\Components\Select::make('link_provider')
                                    ->label('Provedor')
                                    ->placeholder('Todos os provedores')
                                    ->options(fn() => \App\Models\Provider::orderBy('name')->pluck('name', 'id')->toArray())
                                    ->searchable()
                                    ->live()
                                    ->dehydrated(false)
                                    ->afterStateUpdated(fn(Forms\Set $set) => $set('link_game', null)),
                                Forms\Components\Select::make('link_game')
                                    ->label('Jogo do banner')
                                    ->helperText('Pesquise o jogo: o link é preenchido sozinho.')
                                    ->searchable()
                                    ->live()
                                    ->dehydrated(false)
                                    ->getSearchResultsUsing(function (string $search, Forms\Get $get) {
                                        return \App\Models\Game::query()
                                            ->when($get('link_provider'), fn($q, $p) => $q->where('provider_id', $p))
                                            ->where('game_name', 'like', '%' . $search . '%')
                                            ->orderBy('game_name')
                                            ->limit(50)
                                            ->pluck('game_name', 'id')
                                            ->toArray();
                                    })
                                    ->options(function (Forms\Get $get) {
                                        if (!$get('link_provider')) return [];
                                        return \App\Models\Game::where('provider_id', $get('link_provider'))
                                            ->orderBy('game_name')->limit(300)->pluck('game_name', 'id')->toArray();
                                    })
                                    ->getOptionLabelUsing(fn($value) => \App\Models\Game::find($value)?->game_name)
                                    ->afterStateHydrated(function (Forms\Components\Select $component, Forms\Get $get) {
                                        if (preg_match('#/games/play/(\d+)/#', (string) $get('link'), $m)) {
                                            $component->state((int) $m[1]);
                                        }
                                    })
                                    ->afterStateUpdated(function ($state, Forms\Set $set) {
                                        $game = $state ? \App\Models\Game::find($state) : null;
                                        if ($game) {
                                            $set('link', '/games/play/' . $game->id . '/' . ($game->game_code ?: $game->game_id));
                                        }
                                    }),
                                Forms\Components\TextInput::make('link')
                                    ->label('Link')
                                    ->placeholder('Digite o link do banner')
                                    ->maxLength(191),
                                Forms\Components\Select::make('type')
                                    ->label('Selecione o tipo')
                                    ->options([
                                        'carousel' => 'Banner na Carousel',
                                        'home' => 'Banner na Home',
                                    ])
                                    ->required(),
                            ])->columns(2)->columnSpanFull(),

                            Forms\Components\Textarea::make('description')
                                ->placeholder('Digite uma descrição')
                                ->maxLength(65535)
                                ->columnSpanFull(),
                        ])->columns(2),
                        Forms\Components\FileUpload::make('image')
                            ->image()
                            ->required(),
                    ])
            ]);
    }

    /**
     * @param Table $table
     * @return Table
     */
    public static function table(Table $table): Table
    {
        return $table
            ->columns([
                Tables\Columns\ImageColumn::make('image')
                    ->label('Imagem'),
                Tables\Columns\TextColumn::make('link')
                    ->label('Link')
                    ->searchable(),
                Tables\Columns\TextColumn::make('type')
                    ->label('Tipo')
                    ->searchable(),
                Tables\Columns\TextColumn::make('created_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
                Tables\Columns\TextColumn::make('updated_at')
                    ->dateTime()
                    ->sortable()
                    ->toggleable(isToggledHiddenByDefault: true),
            ])
            ->filters([
                //
            ])
            ->actions([
                Tables\Actions\EditAction::make(),
            ])
            ->bulkActions([
                Tables\Actions\BulkActionGroup::make([
                    Tables\Actions\DeleteBulkAction::make(),
                ]),
            ])
            ->emptyStateActions([
                Tables\Actions\CreateAction::make(),
            ]);
    }

    public static function getRelations(): array
    {
        return [
            //
        ];
    }

    public static function getPages(): array
    {
        return [
            'index' => Pages\ListBanners::route('/'),
            'create' => Pages\CreateBanner::route('/create'),
            'edit' => Pages\EditBanner::route('/{record}/edit'),
        ];
    }
}
