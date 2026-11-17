<?php

use App\Http\Controllers\Api\Games\GameController;
use Illuminate\Support\Facades\Route;

// ProftGames — callback_url no painel deles: https://SEUSITE/proftgames/
Route::match(['get', 'post'], '/proftgames/gold_api/user_balance', [GameController::class, 'webhookProftGamesUserBalance']);
Route::match(['get', 'post'], '/proftgames/{key}/gold_api/user_balance', [GameController::class, 'webhookProftGamesUserBalance']);
Route::match(['get', 'post'], '/proftgames/gold_api/game_callback', [GameController::class, 'webhookProftGamesGameCallback']);
Route::match(['get', 'post'], '/proftgames/{key}/gold_api/game_callback', [GameController::class, 'webhookProftGamesGameCallback']);

// Capas dos jogos: só é chamada quando a imagem ainda não está em storage/app/public/ProftGames
Route::get('/storage/ProftGames/{file}', [GameController::class, 'proftGamesCoverImage'])->where('file', '[A-Za-z0-9_.\-]+');
