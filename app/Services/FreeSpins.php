<?php

namespace App\Services;

use App\Helpers\Core as Helper;
use App\Models\DepositBonusLog;
use App\Models\FreeSpin;
use App\Models\FreeSpinConfig;
use App\Models\Game;
use App\Models\GamesKey;
use App\Models\Setting;
use App\Models\User;
use App\Models\Wallet;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

/**
 * Rodadas grátis da ProftGames — POST https://proftgames.com/api/v1/free_spins
 * (mesmas credenciais do lançamento). Os giros são jogados no jogo e chegam
 * pelo game_callback com slot.is_free_spin / slot.free_spin_id.
 */
class FreeSpins
{
    private const URL = 'https://proftgames.com/api/v1/free_spins';

    private const ERRORS = [
        'INVALID_USER'       => 'Jogador ainda não existe na ProftGames (é criado quando ele abre um jogo).',
        'FREESPINS_DISABLED' => 'Rodadas grátis estão desativadas na ProftGames.',
        'INVALID_GAME'       => 'Esse jogo não aceita rodadas grátis (só PG Soft, Pragmatic Play e Minigames).',
        'INVALID_ROUNDS'     => 'Quantidade de rodadas fora do limite permitido.',
        'INVALID_BET'        => 'Valor por giro não aceito por esse jogo.',
        'BET_TOO_HIGH'       => 'Valor por giro acima do máximo permitido.',
        'INVALID_EXPIRY'     => 'Validade fora do limite permitido.',
        'NOT_FOUND'          => 'Pacote não encontrado na ProftGames.',
        'IP_NOT_ALLOWED'     => 'IP do servidor não liberado na whitelist da ProftGames.',
    ];

    public static function log(string $msg, array $ctx = []): void
    {
        Log::info('[FreeSpins] ' . $msg, $ctx);
    }

    /** @return array [http, data] */
    private static function request(array $body): array
    {
        $k = GamesKey::first();
        $a = $k ? $k->getAttributes() : [];
        $token = trim((string) ($a['proftgames_token'] ?? ''));
        $secret = trim((string) ($a['proftgames_secret'] ?? ''));
        if ($token === '' || $secret === '') {
            throw new \RuntimeException('Configure o Token e a Secret da ProftGames em API de jogos.');
        }

        $res = Http::timeout(15)->connectTimeout(8)->acceptJson()
            ->withOptions(['curl' => [CURLOPT_IPRESOLVE => CURL_IPRESOLVE_V4]])
            ->post(self::URL, ['agentToken' => $token, 'secretKey' => $secret] + $body);

        $data = $res->json();
        self::log('REQ ' . ($body['action'] ?? ''), ['body' => $body, 'http' => $res->status(), 'resp' => substr($res->body(), 0, 500)]);
        if (!is_array($data)) {
            throw new \RuntimeException('Resposta inválida da ProftGames (HTTP ' . $res->status() . ')');
        }
        return [$res->status(), $data];
    }

    private static function error(int $http, array $data): string
    {
        $code = (string) ($data['code'] ?? '');
        if (isset(self::ERRORS[$code])) return self::ERRORS[$code];
        if ($http === 401) return 'Credenciais da ProftGames inválidas.';
        if ($http === 403) return self::ERRORS['IP_NOT_ALLOWED'];
        return (string) ($data['message'] ?? $data['msg'] ?? ('Erro da ProftGames (HTTP ' . $http . ')'));
    }

    /** Limites e apostas aceitas por jogo (cache 10 min). */
    public static function options(): array
    {
        return Cache::remember('proftgames_freespin_options', 600, function () {
            [$http, $data] = self::request(['action' => 'options']);
            if ($http !== 200 || (int) ($data['status'] ?? 0) !== 1) {
                throw new \RuntimeException(self::error($http, $data));
            }
            return $data;
        });
    }

    /** Apostas aceitas para o jogo (vazio = não informado). */
    public static function betsFor(string $gameCode): array
    {
        try {
            foreach ((self::options()['games'] ?? []) as $g) {
                if ((string) ($g['game_code'] ?? '') === $gameCode) {
                    $b = array_map('floatval', $g['bets'] ?? []);
                    sort($b);
                    return $b;
                }
            }
        } catch (\Throwable $e) {
        }
        return [];
    }

    private static function pickBet(string $gameCode, ?float $bet): ?float
    {
        $bets = self::betsFor($gameCode);
        if (!$bets) return $bet;
        if (!$bet || $bet <= 0) return $bets[0];
        $best = $bets[0];
        foreach ($bets as $b) if (abs($b - $bet) < abs($best - $bet)) $best = $b;
        return $best;
    }

    /**
     * Cria o pacote local e envia para a ProftGames.
     * Se o jogador ainda não existe lá, fica "pending" e é enviado quando ele abrir um jogo.
     */
    public static function grant(User $user, ?Game $game, string $gameCode, string $gameName, int $rounds, ?float $bet, int $days, string $origin, ?int $transactionId = null): FreeSpin
    {
        $fs = FreeSpin::create([
            'user_id'        => $user->id,
            'game_id'        => $game?->id,
            'game_code'      => $gameCode,
            'game_name'      => $gameName,
            'rounds'         => $rounds,
            'bet'            => $bet,
            'status'         => 'pending',
            'origin'         => $origin,
            'transaction_id' => $transactionId,
            'expires_at'     => now()->addDays(max(1, $days)),
        ]);
        self::send($fs);
        return $fs->fresh();
    }

    /** Envia (ou reenvia) um pacote pendente para a ProftGames. */
    public static function send(FreeSpin $fs): bool
    {
        if ($fs->external_id || !in_array($fs->status, ['pending', 'failed'])) {
            return (bool) $fs->external_id;
        }
        $user = $fs->user;
        if (!$user) return false;

        $days = max(1, (int) ceil(now()->diffInHours($fs->expires_at ?? now()->addDays(7), false) / 24));
        try {
            $bet = self::pickBet($fs->game_code, $fs->bet ? (float) $fs->bet : null);
            [$http, $data] = self::request([
                'action'          => 'create',
                'user_code'       => $user->email,
                'game_code'       => $fs->game_code,
                'rounds'          => (int) $fs->rounds,
                'bet'             => $bet !== null ? round($bet, 2) : null,
                'expires_in_days' => $days,
                'reference'       => 'fs-' . $fs->id,
            ]);
            if ($http === 200 && (int) ($data['status'] ?? 0) === 1 && !empty($data['free_spin']['id'])) {
                $r = $data['free_spin'];
                $fs->update([
                    'external_id' => (int) $r['id'],
                    'rounds'      => (int) ($r['rounds'] ?? $fs->rounds),
                    'bet'         => isset($r['bet']) ? (float) $r['bet'] : $bet,
                    'status'      => 'active',
                    'error'       => null,
                    'expires_at'  => !empty($r['expires_at']) ? \Carbon\Carbon::parse($r['expires_at'])->setTimezone(config('app.timezone')) : $fs->expires_at,
                ]);
                return true;
            }
            $code = (string) ($data['code'] ?? '');
            $fs->update([
                'status' => $code === 'INVALID_USER' ? 'pending' : 'failed',
                'error'  => mb_substr(self::error($http, $data), 0, 250),
            ]);
        } catch (\Throwable $e) {
            $fs->update(['status' => 'pending', 'error' => mb_substr($e->getMessage(), 0, 250)]);
        }
        return false;
    }

    /** Chamado quando o jogador abre um jogo: envia pacotes que ficaram pendentes. */
    public static function sendPending(User $user): void
    {
        FreeSpin::where('user_id', $user->id)->where('status', 'pending')->whereNull('external_id')
            ->where(function ($q) { $q->whereNull('expires_at')->orWhere('expires_at', '>', now()); })
            ->limit(5)->get()->each(fn ($fs) => self::send($fs));
    }

    public static function cancel(FreeSpin $fs): void
    {
        if ($fs->external_id) {
            [$http, $data] = self::request(['action' => 'cancel', 'id' => (int) $fs->external_id]);
            if (!($http === 404 || ($data['code'] ?? '') === 'NOT_FOUND') && ($http !== 200 || (int) ($data['status'] ?? 0) !== 1)) {
                throw new \RuntimeException(self::error($http, $data));
            }
        }
        $fs->update(['status' => 'cancelled']);
    }

    /** Bônus automático do depósito (chamado pelo webhook do PIX). */
    public static function onDeposit(int $userId, float $amount, int $transactionId): void
    {
        try {
            $cfg = FreeSpinConfig::current();
            if (!$cfg->active || !$cfg->game_code || $cfg->rounds < 1 || $amount < (float) $cfg->min_deposit) {
                return;
            }
            if (!DepositBonusLog::claim($userId, 'freespin', $transactionId, $amount, (int) $cfg->max_times)) {
                return;
            }
            $user = User::find($userId);
            if (!$user) return;
            self::grant($user, $cfg->game_id ? Game::find($cfg->game_id) : null, $cfg->game_code, (string) $cfg->game_name,
                (int) $cfg->rounds, $cfg->bet ? (float) $cfg->bet : null, (int) $cfg->expire_days, 'deposit', $transactionId);
        } catch (\Throwable $e) {
            self::log('onDeposit erro', ['user' => $userId, 'msg' => $e->getMessage()]);
        }
    }

    /**
     * Rodada grátis vinda do game_callback. Credita o ganho (+ rollover) sem debitar aposta.
     * Retorna false se não achou pacote (aí o callback segue o fluxo normal).
     */
    public static function handleRound(User $user, Wallet $wallet, ?int $externalId, string $gameCode, float $win): bool
    {
        $q = FreeSpin::where('user_id', $user->id);
        $fs = $externalId
            ? (clone $q)->where('external_id', $externalId)->lockForUpdate()->first()
            : null;
        if (!$fs) {
            $fs = (clone $q)->where('game_code', $gameCode)->whereIn('status', ['active', 'pending'])
                ->orderBy('id')->lockForUpdate()->first();
        }
        if (!$fs) return false;

        $played = min((int) $fs->rounds, (int) $fs->rounds_played + 1);
        $fs->update([
            'rounds_played' => $played,
            'total_win'     => round((float) $fs->total_win + $win, 2),
            'status'        => $played >= (int) $fs->rounds ? 'completed' : 'active',
        ]);

        if ($win > 0) {
            $wallet->increment('balance', $win);
            $cfg = FreeSpinConfig::current();
            $mult = $cfg->win_rollover !== null ? (float) $cfg->win_rollover : (float) optional(Setting::first())->rollover;
            Helper::addRollover($wallet, $win, $mult);
        }
        return true;
    }

    /** Pacotes do jogador que ainda dá pra jogar. */
    public static function activeFor(int $userId)
    {
        FreeSpin::where('user_id', $userId)->whereIn('status', ['active', 'pending'])
            ->whereNotNull('expires_at')->where('expires_at', '<=', now())->update(['status' => 'expired']);

        return FreeSpin::where('user_id', $userId)->whereIn('status', ['active', 'pending'])
            ->whereColumn('rounds_played', '<', 'rounds')->orderBy('id')->get();
    }
}
