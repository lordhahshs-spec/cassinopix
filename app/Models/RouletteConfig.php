<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class RouletteConfig extends Model
{
    protected $table = 'roulette_config';

    protected $fillable = ['active','signup_spins','deposit_spins','deposit_min','deposit_max_times','spins_expire_days','prize_rollover'];

    protected $casts = ['active' => 'boolean'];

    public static function current(): self
    {
        return static::firstOrCreate(['id' => 1], ['active' => 1, 'spins_expire_days' => 7]);
    }
}
