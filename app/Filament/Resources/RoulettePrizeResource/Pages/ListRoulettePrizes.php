<?php

namespace App\Filament\Resources\RoulettePrizeResource\Pages;

use App\Filament\Resources\RoulettePrizeResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListRoulettePrizes extends ListRecords
{
    protected static string $resource = RoulettePrizeResource::class;

    protected function getHeaderActions(): array
    {
        return [Actions\CreateAction::make()];
    }
}
