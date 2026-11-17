<?php

namespace App\Auth;

use Illuminate\Auth\EloquentUserProvider;
use Illuminate\Support\Facades\Cache;

/**
 * Igual ao provider padrão, mas guarda o usuário logado em cache por 60s.
 * Cada requisição com token deixa de abrir conexão no banco só para achar o usuário.
 */
class CachedUserProvider extends EloquentUserProvider
{
    public function retrieveById($identifier)
    {
        $key = 'auth_user_' . $identifier;

        $user = Cache::get($key);
        if ($user) {
            return $user;
        }

        $user = parent::retrieveById($identifier);
        if ($user) {
            Cache::put($key, $user, 60);
        }

        return $user;
    }
}
