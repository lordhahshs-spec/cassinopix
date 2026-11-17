<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;


class SetDefaultLanguage
{
    /**
     * Handle an incoming request.
     *
     * @param  \Closure(\Illuminate\Http\Request): (\Symfony\Component\HttpFoundation\Response)  $next
     */
    public function handle($request, Closure $next)
    {
        // Só consulta o usuário quando a requisição vem logada (callbacks de jogo não trazem token)
        if ($request->bearerToken()) {
            try {
                if (auth('api')->check()) {
                    app()->setLocale(auth('api')->user()->language);
                }
            } catch (\Throwable $e) {
                // falha momentânea de conexão não derruba a requisição
            }
        }

        return $next($request);
    }
}
