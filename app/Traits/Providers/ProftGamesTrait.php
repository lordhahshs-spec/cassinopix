<?php

namespace App\Traits\Providers;

use App\Helpers\Core as Helper;
use App\Models\Game;
use App\Models\GamesKey;
use App\Models\Order;
use App\Models\Provider;
use App\Models\User;
use App\Models\Wallet;
use Illuminate\Http\Client\Pool;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use Illuminate\Support\Facades\Storage;

/**
 * ProftGames
 *  - Lançamento: POST https://proftgames.com/gateway.php
 *  - Catálogo:   POST https://proftgames.com/api {"action":"public_config"}
 *  - Callbacks:  {callback_url}gold_api/user_balance e {callback_url}gold_api/game_callback
 *    callback_url = https://SEUSITE/proftgames/
 */
trait ProftGamesTrait
{
    protected static string $proftBaseUrl = 'https://proftgames.com';

    /* ------------------------------------------------------------------ */
    /* Credenciais                                                         */
    /* ------------------------------------------------------------------ */

    private static function proftGamesKeys(): array
    {
        $k = GamesKey::first();
        $a = $k ? $k->getAttributes() : [];

        return [
            'code'   => trim((string)($a['proftgames_code'] ?? '')),
            'token'  => trim((string)($a['proftgames_token'] ?? '')),
            'secret' => trim((string)($a['proftgames_secret'] ?? '')),
        ];
    }

    /** URL que vai no campo "callback_url" do agente no painel da ProftGames. */
    public static function proftGamesCallbackUrl(): string
    {
        return rtrim(url('/'), '/') . '/proftgames/';
    }

    private static function proftLog(string $msg, array $ctx = []): void
    {
        Log::info('[ProftGames] ' . $msg, $ctx);
    }

    /* ------------------------------------------------------------------ */
    /* Saldo                                                               */
    /* ------------------------------------------------------------------ */

    private static function proftWalletTotal($wallet): float
    {
        if (!$wallet) return 0.0;
        return round((float) $wallet->getAttributes()['balance'], 2);
    }

    private static function proftBalanceJson(float $saldo, string $msg = '')
    {
        $saldo = round(max(0, $saldo), 2);
        return response()->json(['msg' => $msg, 'balance' => $saldo, 'user_balance' => $saldo], 200);
    }

    /* ------------------------------------------------------------------ */
    /* Lançamento                                                          */
    /* ------------------------------------------------------------------ */

    public static function proftGamesLaunch(Game $game, User $user): array
    {
        $keys = self::proftGamesKeys();
        if ($keys['token'] === '' || $keys['secret'] === '') {
            return ['error' => 'ProftGames não configurada no painel.'];
        }

        $payload = [
            'agentToken'   => $keys['token'],
            'secretKey'    => $keys['secret'],
            'user_code'    => $user->email,
            'game_code'    => (string)$game->game_code,
            'user_balance' => self::proftWalletTotal(Wallet::where('user_id', $user->id)->first()),
            'lang'         => 'pt',
            'currency'     => 'BRL',
        ];
        if (!empty($game->provider?->code)) {
            $payload['provider_code'] = $game->provider->code;
        }

        try {
            $response = Http::timeout(20)->acceptJson()
                ->withOptions(['curl' => [CURLOPT_IPRESOLVE => CURL_IPRESOLVE_V4]])
                ->post(self::$proftBaseUrl . '/gateway.php', $payload);
            $data = $response->json() ?? [];
        } catch (\Throwable $e) {
            self::proftLog('LAUNCH ERRO', ['msg' => $e->getMessage()]);
            return ['error' => 'Falha ao conectar no provedor.'];
        }

        if ((int)($data['status'] ?? 0) === 1 && !empty($data['launch_url'])) {
            // jogador já existe na ProftGames: envia free spins que estavam esperando
            \App\Services\FreeSpins::sendPending($user);
            return ['launch_url' => $data['launch_url']];
        }

        self::proftLog('LAUNCH RECUSADO', ['game' => $game->game_code, 'resp' => $data]);
        return ['error' => $data['message'] ?? $data['msg'] ?? 'Jogo indisponível no momento.'];
    }

    /* ------------------------------------------------------------------ */
    /* Callbacks                                                           */
    /* ------------------------------------------------------------------ */

    private static function proftInput(Request $request): array
    {
        $in = json_decode($request->getContent(), true);
        return is_array($in) ? $in : $request->all();
    }

    /** POST /proftgames/gold_api/user_balance */
    public static function proftGamesUserBalance(Request $request)
    {
        if ($request->isMethod('get')) {
            return response()->json(['ok' => true, 'rota' => 'proftgames user_balance ativa']);
        }
        $in   = self::proftInput($request);
        self::proftLog('user_balance', ['user_code' => $in['user_code'] ?? null, 'ip' => $request->ip()]);
        $user = User::where('email', (string)($in['user_code'] ?? ''))->first();
        if (!$user) {
            return response()->json(['msg' => 'INVALID_USER', 'balance' => 0], 200);
        }

        $saldo = self::proftWalletTotal(Wallet::where('user_id', $user->id)->first());
        if ($saldo <= 0) {
            return response()->json(['msg' => 'INSUFFICIENT_USER_FUNDS', 'balance' => 0], 200);
        }

        return self::proftBalanceJson($saldo);
    }

    /** POST /proftgames/gold_api/game_callback */
    public static function proftGamesGameCallback(Request $request)
    {
        if ($request->isMethod('get')) {
            return response()->json(['ok' => true, 'rota' => 'proftgames game_callback ativa']);
        }
        $in   = self::proftInput($request);
        self::proftLog('game_callback', ['user_code' => $in['user_code'] ?? null, 'txn' => $in['slot']['txn_id'] ?? null, 'bet' => $in['slot']['bet'] ?? null, 'win' => $in['slot']['win'] ?? null, 'ip' => $request->ip()]);
        $keys = self::proftGamesKeys();

        if ($keys['secret'] === '' || !hash_equals($keys['secret'], (string)($in['agent_secret'] ?? ''))) {
            self::proftLog('CALLBACK AGENTE INVÁLIDO', ['agent_code' => $in['agent_code'] ?? null]);
            return response()->json(['msg' => 'INVALID_AGENT', 'balance' => 0], 401);
        }

        $user = User::where('email', (string)($in['user_code'] ?? ''))->first();
        if (!$user) {
            return response()->json(['msg' => 'INVALID_USER', 'balance' => 0], 200);
        }

        $slot     = is_array($in['slot'] ?? null) ? $in['slot'] : [];
        $bet      = round(max(0, (float)($slot['bet'] ?? 0)), 2);
        $win      = round(max(0, (float)($slot['win'] ?? 0)), 2);
        $txnId    = substr((string)($slot['txn_id'] ?? ''), 0, 191);
        $roundId  = (string)($slot['round_id'] ?? $txnId);
        $gameCode = (string)($slot['game_code'] ?? '');
        $engine   = strtoupper((string)($slot['provider_code'] ?? ''));
        $isFree   = !empty($slot['is_free_spin']) || !empty($slot['free_spin_id']);
        $freeId   = !empty($slot['free_spin_id']) ? (int) $slot['free_spin_id'] : null;
        $isBonus  = (($slot['txn_type'] ?? null) === 'bonus');

        if ($txnId === '') {
            return self::proftBalanceJson(self::proftWalletTotal(Wallet::where('user_id', $user->id)->first()));
        }

        try {
            return DB::transaction(function () use ($user, $bet, $win, $txnId, $roundId, $gameCode, $engine, $isFree, $freeId, $isBonus) {
                $wallet = Wallet::where('user_id', $user->id)->lockForUpdate()->first();
                if (!$wallet) {
                    return response()->json(['msg' => 'INVALID_USER', 'balance' => 0], 200);
                }

                // Idempotência: txn_id já processado → só devolve o saldo
                if (Order::where('transaction_id', $txnId)->where('providers', 'proftgames')->exists()) {
                    return self::proftBalanceJson(self::proftWalletTotal($wallet));
                }

                // Rodada grátis (free spins): não debita aposta, credita o ganho no pacote
                if ($isFree && !$isBonus && \App\Services\FreeSpins::handleRound($user, $wallet, $freeId, $gameCode, $win)) {
                    Order::create([
                        'user_id'        => $user->id,
                        'session_id'     => $roundId,
                        'transaction_id' => $txnId,
                        'game'           => $gameCode,
                        'game_uuid'      => $gameCode,
                        'type'           => $win > 0 ? 'win' : 'bet',
                        'type_money'     => 'free_spin',
                        'amount'         => $win,
                        'providers'      => 'proftgames',
                        'refunded'       => false,
                        'round_id'       => $roundId,
                        'status'         => true,
                    ]);
                    return self::proftBalanceJson(self::proftWalletTotal(Wallet::where('user_id', $user->id)->first()));
                }

                // Passo de bônus sem valores
                if ($bet <= 0 && $win <= 0) {
                    return self::proftBalanceJson(self::proftWalletTotal($wallet));
                }

                $saldoAnt = self::proftWalletTotal($wallet);

                // Só os MINIGAMES podem ter a aposta recusada
                if ($engine === 'MINIGAMES' && $bet > $saldoAnt + 0.001) {
                    return self::proftBalanceJson($saldoAnt, 'INSUFFICIENT_USER_FUNDS');
                }

                // Carteira única: a aposta sai do saldo (a rodada já aconteceu, nunca recusa)
                $changeBonus = 'balance';
                if ($bet > 0) {
                    $novo = round((float) $wallet->balance - $bet, 2);
                    $wallet->update(['balance' => max(0, $novo)]);
                }

                $type = $win > 0 ? 'win' : 'bet';

                Order::create([
                    'user_id'        => $user->id,
                    'session_id'     => $roundId,
                    'transaction_id' => $txnId,
                    'game'           => $gameCode,
                    'game_uuid'      => $gameCode,
                    'type'           => $type,
                    'type_money'     => $changeBonus,
                    'amount'         => $win > 0 ? $win : $bet,
                    'providers'      => 'proftgames',
                    'refunded'       => false,
                    'round_id'       => $roundId,
                    'status'         => true,
                ]);

                // Credita o prêmio (rollover) + afiliados
                Helper::generateGameHistory($user->id, $type, $win, $bet, $changeBonus, $txnId);

                return self::proftBalanceJson(self::proftWalletTotal(Wallet::where('user_id', $user->id)->first()));
            });
        } catch (\Throwable $e) {
            self::proftLog('CALLBACK ERRO', ['txn' => $txnId, 'msg' => $e->getMessage()]);
            // Nunca responder erro numa rodada que já aconteceu: devolve o saldo atual
            return self::proftBalanceJson(self::proftWalletTotal(Wallet::where('user_id', $user->id)->first()));
        }
    }

    /* ------------------------------------------------------------------ */
    /* Importação do catálogo                                             */
    /* ------------------------------------------------------------------ */

    private static function proftCleanImageUrl(?string $url): string
    {
        $url = html_entity_decode(trim((string)$url), ENT_QUOTES);
        $url = preg_replace('/(&quot;?|")+$/', '', $url);
        return filter_var($url, FILTER_VALIDATE_URL) ? $url : '';
    }

    private static function proftCoverPath(string $providerCode, string $gameCode, string $imageUrl): string
    {
        $ext = strtolower(pathinfo((string)parse_url($imageUrl, PHP_URL_PATH), PATHINFO_EXTENSION));
        if (!in_array($ext, ['png', 'jpg', 'jpeg', 'webp', 'avif', 'svg', 'gif'], true)) {
            $ext = 'png';
        }
        $slug = preg_replace('/[^A-Za-z0-9_-]+/', '_', $providerCode . '_' . $gameCode);
        return 'ProftGames/' . trim($slug, '_') . '.' . $ext;
    }

    private static function proftUpsertProvider(string $code, ?string $name = null, ?int $status = null): int
    {
        $prov = Provider::firstOrNew(['code' => mb_substr($code, 0, 50)]);
        if ($status !== null) {
            $prov->status = $status;
        }
        if (!$prov->exists) {
            $prov->name   = mb_substr($name ?: $code, 0, 50);
            if ($status === null) $prov->status = 1;
            $prov->rtp    = 90;
            $prov->views  = 1;
        }
        if (empty($prov->cover)) {
            // Reaproveita a logo já enviada em storage/app/public/Provedores/{CODE}.webp|png
            foreach (['webp', 'png', 'jpg', 'svg'] as $ext) {
                $file = 'Provedores/' . str_replace(' ', '', strtoupper($code)) . '.' . $ext;
                if (Storage::disk('public')->exists($file)) {
                    $prov->cover = $file;
                    break;
                }
            }
        }
        $prov->distribution = 'proftgames';
        $prov->save();

        return (int)$prov->id;
    }

    /** Catálogo da ProftGames (public_config), guardado 10 min para o modal e a importação usarem o mesmo. */
    public static function proftGamesCatalog(bool $fresh = false): array
    {
        if ($fresh) {
            Cache::forget('proftgames_public_config');
        }

        return Cache::remember('proftgames_public_config', 600, function () {
            $response = Http::timeout(60)->acceptJson()->post(self::$proftBaseUrl . '/api', ['action' => 'public_config']);
            $data = $response->json() ?? [];
            if (empty($data['ok']) || !is_array($data['games'] ?? null)) {
                throw new \RuntimeException('Resposta inválida do public_config da ProftGames.');
            }
            return $data;
        });
    }

    /** Lista de provedores do catálogo: code, nome, qtd de jogos, se já existe aqui e se está ativo. */
    public static function proftGamesProviderList(bool $fresh = false): array
    {
        $data = self::proftGamesCatalog($fresh);

        $counts = [];
        foreach ($data['games'] as $g) {
            $code = trim((string)($g['provider_code'] ?? ''));
            if ($code !== '') $counts[$code] = ($counts[$code] ?? 0) + 1;
        }

        $order = [];
        foreach (($data['providers'] ?? []) as $p) {
            $code = trim((string)($p['provider_code'] ?? ''));
            if ($code !== '') $order[$code] = ['position' => (int)($p['position'] ?? 999), 'name' => $p['name'] ?? null];
        }

        $local = Provider::whereIn('code', array_keys($counts))->get()->keyBy('code');

        $list = [];
        foreach ($counts as $code => $qty) {
            $prov = $local[$code] ?? null;
            $list[] = [
                'code'     => $code,
                'name'     => $prov->name ?? ($order[$code]['name'] ?? $code),
                'games'    => $qty,
                'exists'   => (bool)$prov,
                'active'   => $prov ? (int)$prov->status === 1 : true,
                'position' => $order[$code]['position'] ?? 999,
            ];
        }
        usort($list, fn($a, $b) => [$a['position'], $a['code']] <=> [$b['position'], $b['code']]);

        return $list;
    }

    /**
     * Importa / atualiza provedores e jogos a partir do public_config.
     * $selection = ['CODIGO' => ['import' => bool, 'active' => bool], ...]  (null = importa tudo, mantém status)
     */
    public static function proftGamesImport(?array $selection = null): array
    {
        @set_time_limit(0);
        $started = microtime(true);

        $data = self::proftGamesCatalog();

        $wants = function (string $code) use ($selection): bool {
            return $selection === null || !empty($selection[$code]['import']);
        };
        $activeOf = function (string $code) use ($selection): ?int {
            return $selection === null ? null : (!empty($selection[$code]['active']) ? 1 : 0);
        };

        $providerIds = [];
        $seenGames   = [];
        $created = $updated = 0;

        // Provedores (pela ordem oficial)
        $provList = is_array($data['providers'] ?? null) ? $data['providers'] : [];
        usort($provList, fn($a, $b) => (int)($a['position'] ?? 0) <=> (int)($b['position'] ?? 0));
        foreach ($provList as $p) {
            $code = trim((string)($p['provider_code'] ?? ''));
            if ($code === '' || isset($providerIds[$code]) || !$wants($code)) continue;
            $providerIds[$code] = self::proftUpsertProvider($code, $p['name'] ?? null, $activeOf($code));
        }

        foreach ($data['games'] as $g) {
            $pCode = trim((string)($g['provider_code'] ?? ''));
            $gCode = trim((string)($g['game_code'] ?? ''));
            if ($pCode === '' || $gCode === '' || !$wants($pCode)) continue;

            if (!isset($providerIds[$pCode])) {
                $providerIds[$pCode] = self::proftUpsertProvider($pCode, null, $activeOf($pCode));
            }

            $image = self::proftCleanImageUrl($g['image_url'] ?? '');
            $game  = Game::firstOrNew(['provider_id' => $providerIds[$pCode], 'game_code' => $gCode]);
            $isNew = !$game->exists;

            $game->game_id      = $gCode;
            $game->game_name    = mb_substr((string)($g['name'] ?? $gCode), 0, 191);
            $game->game_type    = mb_substr(strtolower((string)($g['category'] ?? 'slot')), 0, 191);
            $game->distribution = 'proftgames';
            $game->technology   = 'html5';
            if ($image !== '') {
                $game->cover_url = $image;
                $game->cover     = self::proftCoverPath($pCode, $gCode, $image);
            }
            $active = $activeOf($pCode);
            if ($active !== null) {
                $game->status = (string)$active;
            }
            if ($isNew) {
                if ($active === null) $game->status = 1;
                $game->views     = 0;
                $game->show_home = 1;
            }
            $game->save();
            $isNew ? $created++ : $updated++;
            $seenGames[] = $game->id;
        }

        // Jogos que saíram do catálogo → inativos
        $disabled = Game::where('distribution', 'proftgames')
            ->whereIn('provider_id', array_values($providerIds) ?: [0])
            ->whereNotIn('id', $seenGames ?: [0])
            ->where('status', '1')
            ->update(['status' => '0']);

        // Provedores ProftGames sem jogos ativos → inativos
        Provider::where('distribution', 'proftgames')
            ->whereDoesntHave('games', fn($q) => $q->where('status', '1'))
            ->update(['status' => 0]);

        // Restos de imagens antigas
        try {
            if (Storage::disk('public')->exists('PlayFiver')) {
                Storage::disk('public')->deleteDirectory('PlayFiver');
            }
        } catch (\Throwable $e) {
        }

        // Baixa as capas que faltam enquanto houver tempo (o resto baixa sozinho no 1º acesso)
        $downloaded = self::proftDownloadCovers($started + 40);

        Cache::forget('proftgames_public_config');

        return [
            'providers'  => count($providerIds),
            'created'    => $created,
            'updated'    => $updated,
            'disabled'   => $disabled,
            'downloaded' => $downloaded,
        ];
    }

    private static function proftDownloadCovers(float $deadline): int
    {
        $disk  = Storage::disk('public');
        $count = 0;

        $pending = Game::where('distribution', 'proftgames')
            ->whereNotNull('cover_url')
            ->get(['id', 'cover', 'cover_url'])
            ->filter(fn($g) => $g->cover && !$disk->exists($g->cover))
            ->values();

        foreach ($pending->chunk(20) as $chunk) {
            if (microtime(true) > $deadline) break;
            $chunk = $chunk->values();
            $responses = Http::pool(fn(Pool $pool) => $chunk->map(
                fn($g) => $pool->as((string)$g->id)->timeout(8)->get($g->cover_url)
            )->all());

            foreach ($chunk as $g) {
                $r = $responses[(string)$g->id] ?? null;
                if ($r instanceof \Illuminate\Http\Client\Response && $r->successful() && strlen($r->body()) > 100) {
                    $disk->put($g->cover, $r->body());
                    $count++;
                }
            }
        }

        return $count;
    }

    /** GET /storage/ProftGames/{file} — só cai aqui se a capa ainda não existe no disco. */
    public static function proftGamesCover(string $file)
    {
        $path = 'ProftGames/' . $file;
        $game = Game::where('cover', $path)->whereNotNull('cover_url')->first();
        if (!$game) abort(404);

        try {
            $r = Http::timeout(10)->get($game->cover_url);
            if ($r->successful() && strlen($r->body()) > 100) {
                Storage::disk('public')->put($path, $r->body());
                return response($r->body(), 200, [
                    'Content-Type'  => $r->header('Content-Type') ?: 'image/png',
                    'Cache-Control' => 'public, max-age=604800',
                ]);
            }
        } catch (\Throwable $e) {
        }

        return redirect()->away($game->cover_url);
    }
}
