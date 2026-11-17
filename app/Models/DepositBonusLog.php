<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class DepositBonusLog extends Model
{
    protected $table = 'deposit_bonus_log';

    protected $fillable = ['user_id', 'type', 'transaction_id', 'amount'];

    /**
     * Reserva o bônus deste depósito. Retorna false se o depósito já pagou esse bônus
     * ou se o jogador já atingiu o limite de vezes (0 = ilimitado).
     */
    public static function claim(int $userId, string $type, int $transactionId, float $amount, int $maxTimes): bool
    {
        if (static::where('type', $type)->where('transaction_id', $transactionId)->exists()) {
            return false;
        }
        if ($maxTimes > 0 && static::where('user_id', $userId)->where('type', $type)->count() >= $maxTimes) {
            return false;
        }
        try {
            static::create(['user_id' => $userId, 'type' => $type, 'transaction_id' => $transactionId, 'amount' => $amount]);
            return true;
        } catch (\Illuminate\Database\QueryException $e) {
            return false; // corrida: outro processo já registrou
        }
    }
}
