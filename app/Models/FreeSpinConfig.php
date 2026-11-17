<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class FreeSpinConfig extends Model
{
    protected $table = 'freespin_config';

    protected $fillable = ['active', 'game_id', 'game_code', 'game_name', 'rounds', 'bet', 'min_deposit', 'max_times', 'expire_days', 'win_rollover'];

    protected $casts = ['active' => 'boolean'];

    public static function current(): self
    {
        return static::firstOrCreate(['id' => 1], ['active' => 0, 'rounds' => 10, 'min_deposit' => 20, 'max_times' => 1, 'expire_days' => 7]);
    }
}
