<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Wallet extends Model
{
    use HasFactory;

    /**
     * The database table used by the model.
     *
     * @var string
     */
    protected $table = 'wallets';
    protected $appends = ['total_balance', 'total_balance_without_bonus', 'rollover_remaining', 'rollover_required', 'rollover_disabled'];

    /**
     * The attributes that are mass assignable.
     *
     * @var array
     */
    protected $fillable = [
        'user_id',
        'currency',
        'symbol',
        'balance',
        'balance_withdrawal',
        'balance_deposit_rollover',
        'rollover_total',
        'balance_bonus',
        'balance_bonus_rollover',
        'balance_cryptocurrency',
        'balance_demo',
        'refer_rewards',
        'total_bet',
        'total_won',
        'total_lose',
        'last_won',
        'last_lose',
        'hide_balance',
        'active',
        'vip_level',
        'vip_points',
        'external_id'
    ];

    /**
     * Cover
     * @return int
     */
    public function getTotalBalanceAttribute()
    {
        // Carteira única: todo o saldo do jogador fica em "balance"
        return (float) ($this->attributes['balance'] ?? 0);
    }

    /**
     * Saldo liberado para saque: o saldo inteiro, desde que o rollover tenha sido cumprido.
     * (a coluna balance_withdrawal não é mais usada)
     */
    public function getBalanceWithdrawalAttribute()
    {
        $balance = (float) ($this->attributes['balance'] ?? 0);
        if ($this->getRolloverDisabledAttribute()) {
            return $balance;
        }
        return (float) ($this->attributes['balance_deposit_rollover'] ?? 0) > 0 ? 0 : $balance;
    }

    /**
     * Quanto ainda falta apostar para liberar o saque.
     */
    public function getRolloverRemainingAttribute()
    {
        if ($this->getRolloverDisabledAttribute()) {
            return 0;
        }
        return max(0, (float) ($this->attributes['balance_deposit_rollover'] ?? 0));
    }

    /**
     * Total de rollover do ciclo atual (para a barra de progresso).
     */
    public function getRolloverRequiredAttribute()
    {
        $restante = $this->getRolloverRemainingAttribute();
        if ($restante <= 0) {
            return 0;
        }
        return max($restante, (float) ($this->attributes['rollover_total'] ?? 0));
    }

    public function getRolloverDisabledAttribute()
    {
        static $semRollover = null;
        if ($semRollover === null) {
            $semRollover = (bool) optional(Setting::first())->disable_rollover;
        }
        return $semRollover;
    }

    /**
     * Cover
     * @return int
     */
    public function getTotalBalanceWithoutBonusAttribute()
    {
        return (float) ($this->attributes['balance'] ?? 0);
    }

    /**
     * @return BelongsTo
     */
    public function user() : BelongsTo
    {
        return $this->belongsTo(User::class);
    }


}
