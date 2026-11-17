<?php

use App\Models\Game;
use Illuminate\Support\Facades\Artisan;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Gateway\SuitPayController;

/*
|--------------------------------------------------------------------------
| Rotas SuitPay (Ecompag Integration)
|--------------------------------------------------------------------------
*/

// Rota existente
Route::post('/suitpay/consult-status-transaction', [SuitPayController::class, 'consultStatusTransactionPix']);

// Rotas protegidas (requerem autenticação)
Route::middleware(['auth'])->group(function () {
    // Processar saque via Ecompag - aceita query params
    Route::get('/suitpay/withdrawal', [SuitPayController::class, 'withdrawal'])
        ->name('suitpay.withdrawal');
    
    // Processar saque via modal - aceita parâmetros na URL
    Route::get('/suitpay/withdrawal/{id}/{action}', [SuitPayController::class, 'withdrawalFromModal'])
        ->name('suitpay.withdrawalFromModal');
    
    // Cancelar saque e devolver saldo - aceita query params
    Route::get('/suitpay/cancelwithdrawal', [SuitPayController::class, 'cancelWithdrawal'])
        ->name('suitpay.cancelwithdrawal');
    
    // Cancelar saque via modal - aceita parâmetros na URL
    Route::get('/suitpay/cancelwithdrawal/{id}/{action}', [SuitPayController::class, 'cancelWithdrawalFromModal'])
        ->name('suitpay.cancelwithdrawalFromModal');
});

// Webhook público da Ecompag (não requer auth)
Route::post('/api/suitpay/webhook', [SuitPayController::class, 'webhook'])
    ->name('suitpay.webhook');

/*
|--------------------------------------------------------------------------
| Clear Cache Route
|--------------------------------------------------------------------------
*/

Route::get('clear', function() {
    Artisan::command('clear', function () {
        Artisan::call('optimize:clear');
        return back();
    });
    return back();
});

/*
|--------------------------------------------------------------------------
| Incluir Grupos de Rotas
|--------------------------------------------------------------------------
*/

include_once(__DIR__ . '/groups/provider/proftgames.php');
include_once(__DIR__ . '/groups/gateways/suitpay.php');
include_once(__DIR__ . '/groups/auth/social.php');
include_once(__DIR__ . '/groups/layouts/app.php');