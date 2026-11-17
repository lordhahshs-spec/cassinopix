<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class RouletteSpin extends Model
{
    protected $table = 'roulette_spins';

    protected $fillable = ['user_id','spins_available','reason','expires_at'];

    protected $casts = ['expires_at' => 'datetime'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
