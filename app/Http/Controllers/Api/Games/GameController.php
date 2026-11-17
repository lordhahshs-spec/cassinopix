<?php

namespace App\Http\Controllers\Api\Games;

use App\Http\Controllers\Controller;
use App\Models\Game;
use App\Models\GameFavorite;
use App\Models\GameLike;
use App\Models\GamesKey;
use App\Models\Gateway;
use App\Models\Provider;
use App\Models\Wallet;
use App\Traits\Providers\ProftGamesTrait;


use Illuminate\Http\Request;

class GameController extends Controller
{
    use ProftGamesTrait;

    /**
     * @dev victormsalatiel
     * Display a listing of the resource.
     */
    public function index()
    {
        $providers = Provider::with(['games', 'games.provider'])
            ->whereHas('games')
            ->orderBy('name', 'desc')
            ->where('status', 1)
            ->get();

        return response()->json(['providers' => $providers]);
    }

    /**
     * @dev victormsalatiel
     * @return \Illuminate\Http\JsonResponse
     */
    public function featured()
    {
        $featured_games = Game::with(['provider'])
            ->where('is_featured', 1)
            ->where('status', 1)
            ->get();

        return response()->json(['featured_games' => $featured_games]);
    }

    /**
     * Source Provider
     *
     * @dev victormsalatiel
     * @param Request $request
     * @param $token
     * @param $action
     * @return \Illuminate\Http\JsonResponse|void
     */
    public function sourceProvider(Request $request, $token, $action)
    {
        $tokenOpen = \Helper::DecToken($token);
        $validEndpoints = ['session', 'icons', 'spin', 'freenum'];

        if (in_array($action, $validEndpoints)) {
            if (isset($tokenOpen['status']) && $tokenOpen['status']) {
                $game = Game::whereStatus(1)->where('game_code', $tokenOpen['game'])->first();
                if (!empty($game)) {
                    $controller = \Helper::createController($game->game_code);

                    switch ($action) {
                        case 'session':
                            return $controller->session($token);
                        case 'spin':
                            return $controller->spin($request, $token);
                        case 'freenum':
                            return $controller->freenum($request, $token);
                        case 'icons':
                            return $controller->icons();
                    }
                }
            }
        } else {
            return response()->json([], 500);
        }
    }

    /**
     * @dev victormsalatiel
     * Store a newly created resource in storage.
     */
    public function toggleFavorite($id)
    {
        if (auth('api')->check()) {
            $checkExist = GameFavorite::where('user_id', auth('api')->id())->where('game_id', $id)->first();
            if (!empty($checkExist)) {
                if ($checkExist->delete()) {
                    return response()->json(['status' => true, 'message' => 'Removido com sucesso']);
                }
            } else {
                $gameFavoriteCreate = GameFavorite::create([
                    'user_id' => auth('api')->id(),
                    'game_id' => $id
                ]);

                if ($gameFavoriteCreate) {
                    return response()->json(['status' => true, 'message' => 'Criado com sucesso']);
                }
            }
        }
    }

    /**
     * @dev victormsalatiel
     * Store a newly created resource in storage.
     */
    public function toggleLike($id)
    {
        if (!auth('api')->check()) {
            return response()->json(['status' => false, 'message' => 'Faça login para curtir.'], 401);
        }

        $userId = auth('api')->id();
        // game_likes não tem coluna id: apaga direto pela dupla usuário/jogo
        $query = GameLike::where('user_id', $userId)->where('game_id', $id);

        if ($query->exists()) {
            $query->delete();
            $liked = false;
        } else {
            GameLike::insert(['user_id' => $userId, 'game_id' => $id, 'created_at' => now(), 'updated_at' => now()]);
            $liked = true;
        }

        return response()->json([
            'status'     => true,
            'message'    => $liked ? 'Criado com sucesso' : 'Removido com sucesso',
            'hasLike'    => $liked,
            'totalLikes' => GameLike::where('game_id', $id)->count(),
        ]);
    }

    /**
     * @dev victormsalatiel
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $game = Game::with(['categories', 'provider'])->whereStatus(1)->find($id);
        if (!empty($game)) {
            $wallet = null;
            $token = null;

            if (auth('api')->check()) {
                $wallet = Wallet::where('user_id', auth('api')->id())->first();
                $token = \Helper::MakeToken([
                    'id' => auth('api')->id(),
                    'game' => $game->game_code
                ]);
            }

            $game->increment('views');

            switch ($game->distribution) {
                case 'proftgames':
                    if (!auth('api')->check()) {
                        return response()->json(['error' => 'Faça login para jogar.', 'status' => false], 401);
                    }
                    $proft = self::proftGamesLaunch($game, auth('api')->user());
                    if (!empty($proft['launch_url'])) {
                        return response()->json([
                            'game' => $game,
                            'gameUrl' => $proft['launch_url'],
                            'token' => $token
                        ]);
                    }
                    return response()->json(['error' => $proft['error'] ?? 'Jogo indisponível no momento.', 'status' => false], 400);
            }
        }
        return response()->json(['error' => '', 'status' => false], 400);
    }

    /**
     * @dev victormsalatiel
     * Show the form for editing the specified resource.
     */
    public function allGames(Request $request)
    {
        $query = Game::query();
        $query->with(['provider', 'categories']);

        if (!empty($request->provider) && $request->provider != 'all') {
            $query->where('provider_id', $request->provider);
        }

        if (!empty($request->category) && $request->category != 'all') {
            $query->whereHas('categories', function ($categoryQuery) use ($request) {
                $categoryQuery->where('slug', $request->category);
            });
        }

        if (isset($request->searchTerm) && !empty($request->searchTerm) && strlen($request->searchTerm) > 2) {
            $term = trim($request->searchTerm);
            $query->where(function ($q) use ($term) {
                $q->where('game_name', 'like', '%' . $term . '%')
                  ->orWhere('game_code', 'like', '%' . $term . '%')
                  ->orWhereHas('provider', fn($p) => $p->where('name', 'like', '%' . $term . '%'));
            });
        } else {
            $query->orderBy('views', 'desc');
        }

        $games = $query
            ->where('status', 1)
            ->paginate(12)->appends(request()->query());

        return response()->json(['games' => $games]);
    }




    public function webhookProftGamesUserBalance(Request $request)
    {
        return self::proftGamesUserBalance($request);
    }

    public function webhookProftGamesGameCallback(Request $request)
    {
        return self::proftGamesGameCallback($request);
    }

    public function proftGamesCoverImage(string $file)
    {
        return self::proftGamesCover($file);
    }


}
