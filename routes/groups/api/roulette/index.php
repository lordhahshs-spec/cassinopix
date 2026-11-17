<?php

use App\Http\Controllers\Api\Roulette\RouletteController;
use Illuminate\Support\Facades\Route;

Route::get('/', [RouletteController::class, 'index']);
Route::post('/spin', [RouletteController::class, 'spin'])->middleware(['auth.jwt', 'throttle:20,1']);
