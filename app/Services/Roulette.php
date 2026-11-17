<?php

namespace App\Services;

use App\Helpers\Core as Helper;
use App\Models\RouletteConfig;
use App\Models\RouletteHistory;
use App\Models\RoulettePrize;
use App\Models\RouletteSpin;
use App\Models\Setting;
use App\Models\Wallet;
use Illuminate\Support\Facades\DB;

/**
 * Roleta da Sorte: roda de 8 fatias, prêmio sorteado no servidor por peso (probabilidade).
 */
class Roulette
{
    public const SLOTS = 8;

    /** Prêmios ativos (máx. 8) na ordem em que aparecem na roda */
    public static function prizes()
    {
        return RoulettePrize::where('status', 1)->orderBy('id')->limit(self::SLOTS)->get();
    }

    /** As 8 fatias da roda: com menos de 8 prêmios eles se repetem */
    public static function slots($prizes): array
    {
        $slots = [];
        $n = count($prizes);
        for ($i = 0; $n && $i < self::SLOTS; $i++) {
            $p = $prizes[$i % $n];
            $slots[] = ['id' => $p->id, 'name' => $p->name, 'value' => (float) $p->value];
        }
        return $slots;
    }

    public static function spinsOf(int $userId): int
    {
        return (int) RouletteSpin::where('user_id', $userId)
            ->where('spins_available', '>', 0)
            ->where(function ($q) { $q->whereNull('expires_at')->orWhere('expires_at', '>', now()); })
            ->sum('spins_available');
    }

    /** Dá giros a um jogador */
    public static function grant(int $userId, int $spins, string $reason = null, ?int $days = null): void
    {
        if ($spins <= 0) {
            return;
        }
        if ($days === null) {
            $days = (int) RouletteConfig::current()->spins_expire_days;
        }
        RouletteSpin::create([
            'user_id'         => $userId,
            'spins_available' => $spins,
            'reason'          => $reason,
            'expires_at'      => $days > 0 ? now()->addDays($days) : null,
        ]);
    }

    public static function onSignup(int $userId): void
    {
        try {
            $cfg = RouletteConfig::current();
            if ($cfg->active && $cfg->signup_spins > 0) {
                self::grant($userId, (int) $cfg->signup_spins, 'Bônus de cadastro');
            }
        } catch (\Throwable $e) {
            \Log::warning('[Roleta] cadastro: ' . $e->getMessage());
        }
    }

    public static function onDeposit(int $userId, float $amount, int $transactionId): void
    {
        try {
            $cfg = RouletteConfig::current();
            if ($cfg->active && $cfg->deposit_spins > 0 && $amount >= (float) $cfg->deposit_min
                && \App\Models\DepositBonusLog::claim($userId, 'roulette', $transactionId, $amount, (int) $cfg->deposit_max_times)) {
                self::grant($userId, (int) $cfg->deposit_spins, 'Bônus de depósito');
            }
        } catch (\Throwable $e) {
            \Log::warning('[Roleta] depósito: ' . $e->getMessage());
        }
    }

    /**
     * Gira: consome 1 giro, sorteia, credita no saldo (+ rollover de bônus) e registra.
     * @return array|string  dados do giro ou mensagem de erro
     */
    public static function spin(int $userId)
    {
        $cfg = RouletteConfig::current();
        if (!$cfg->active) {
            return 'A roleta está desativada no momento.';
        }

        $prizes = self::prizes();
        if ($prizes->isEmpty()) {
            return 'Nenhum prêmio disponível no momento.';
        }

        return DB::transaction(function () use ($userId, $prizes, $cfg) {
            $spin = RouletteSpin::where('user_id', $userId)
                ->where('spins_available', '>', 0)
                ->where(function ($q) { $q->whereNull('expires_at')->orWhere('expires_at', '>', now()); })
                ->orderByRaw('expires_at IS NULL, expires_at ASC')
                ->lockForUpdate()
                ->first();

            if (!$spin) {
                return 'Você não tem giros disponíveis.';
            }

            // sorteio por peso
            $total = max(1, (int) $prizes->sum('probability'));
            $rand = random_int(1, $total);
            $acc = 0;
            $won = $prizes->first();
            foreach ($prizes as $p) {
                $acc += (int) $p->probability;
                if ($rand <= $acc) { $won = $p; break; }
            }

            // fatia onde o ponteiro para
            $options = [];
            $n = count($prizes);
            for ($i = 0; $i < self::SLOTS; $i++) {
                if ((int) $prizes[$i % $n]->id === (int) $won->id) $options[] = $i;
            }
            $slot = $options ? $options[array_rand($options)] : 0;

            $spin->spins_available - 1 > 0
                ? $spin->decrement('spins_available')
                : $spin->delete();

            RouletteHistory::create([
                'user_id'     => $userId,
                'prize_id'    => $won->id,
                'prize_name'  => $won->name,
                'prize_value' => $won->value,
            ]);

            $wallet = Wallet::where('user_id', $userId)->lockForUpdate()->first();
            $value = (float) $won->value;
            if ($value > 0 && $wallet) {
                $wallet->increment('balance', $value);
                $mult = $cfg->prize_rollover !== null ? (float) $cfg->prize_rollover : (float) optional(Setting::first())->rollover;
                Helper::addRollover($wallet, $value, $mult);
                $wallet->refresh();
            }

            return [
                'prize'           => ['id' => $won->id, 'name' => $won->name, 'value' => $value],
                'slot'            => $slot,
                'balance'         => $wallet ? (float) $wallet->balance : 0,
                'spins_remaining' => self::spinsOf($userId),
            ];
        });
    }
}
