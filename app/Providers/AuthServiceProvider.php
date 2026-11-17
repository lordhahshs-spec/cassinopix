<?php

namespace App\Providers;

// use Illuminate\Support\Facades\Gate;
use Illuminate\Foundation\Support\Providers\AuthServiceProvider as ServiceProvider;

class AuthServiceProvider extends ServiceProvider
{
    /**
     * The model to policy mappings for the application.
     *
     * @var array<class-string, class-string>
     */
    protected $policies = [
        //
    ];

    /**
     * Register any authentication / authorization services.
     */
    public function boot(): void
    {
        // Usuário logado em cache (60s) para não consultar o banco a cada requisição
        \Illuminate\Support\Facades\Auth::provider('cached-eloquent', function ($app, array $config) {
            return new \App\Auth\CachedUserProvider($app['hash'], $config['model']);
        });

        // Qualquer alteração no usuário limpa o cache dele na hora
        \App\Models\User::saved(fn($user) => \Illuminate\Support\Facades\Cache::forget('auth_user_' . $user->getKey()));
        \App\Models\User::deleted(fn($user) => \Illuminate\Support\Facades\Cache::forget('auth_user_' . $user->getKey()));
    }
}
