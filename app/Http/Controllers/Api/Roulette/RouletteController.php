<?php

namespace App\Http\Controllers\Api\Roulette;

use App\Http\Controllers\Controller;
use App\Models\RouletteConfig;
use App\Models\RouletteHistory;
use App\Services\Roulette;

class RouletteController extends Controller
{
    /** Dados da roda + giros e últimos prêmios do jogador (se logado) */
    public function index()
    {
        $user = auth('api')->user();
        $cfg = RouletteConfig::current();

        $fsCfg = \App\Models\FreeSpinConfig::current();
        $freeSpins = $user ? \App\Services\FreeSpins::activeFor($user->id)->map(fn ($f) => [
            'id'         => $f->id,
            'game_id'    => $f->game_id,
            'game_code'  => $f->game_code,
            'game_name'  => $f->game_name,
            'rounds'     => (int) $f->rounds,
            'remaining'  => $f->rounds_remaining,
            'bet'        => (float) $f->bet,
            'expires_at' => optional($f->expires_at)->toIso8601String(),
        ])->values() : [];

        return response()->json([
            'active'  => (bool) $cfg->active,
            'offer'   => [
                'roulette' => $cfg->active && $cfg->deposit_spins > 0
                    ? ['spins' => (int) $cfg->deposit_spins, 'min' => (float) $cfg->deposit_min, 'max_times' => (int) $cfg->deposit_max_times]
                    : null,
                'freespin' => $fsCfg->active && $fsCfg->game_code
                    ? ['rounds' => (int) $fsCfg->rounds, 'min' => (float) $fsCfg->min_deposit, 'max_times' => (int) $fsCfg->max_times,
                       'game_id' => $fsCfg->game_id, 'game_code' => $fsCfg->game_code, 'game_name' => $fsCfg->game_name]
                    : null,
            ],
            'free_spins' => $freeSpins,
            'slots'   => Roulette::slots(Roulette::prizes()),
            'logged'  => (bool) $user,
            'spins'   => $user ? Roulette::spinsOf($user->id) : 0,
            'deposit' => ['spins' => (int) $cfg->deposit_spins, 'min' => (float) $cfg->deposit_min],
            'history' => $user
                ? RouletteHistory::where('user_id', $user->id)->latest('id')->limit(5)
                    ->get(['prize_name', 'prize_value', 'created_at'])
                : [],
        ]);
    }

    public function spin()
    {
        $user = auth('api')->user();
        if (!$user) {
            return response()->json(['error' => 'Entre na sua conta para girar.'], 401);
        }

        try {
            $res = Roulette::spin($user->id);
        } catch (\Throwable $e) {
            \Log::error('[Roleta] ' . $e->getMessage());
            return response()->json(['error' => 'Erro ao girar. Tente novamente.'], 500);
        }

        if (is_string($res)) {
            return response()->json(['error' => $res], 400);
        }

        return response()->json(['status' => true] + $res);
    }
}
