<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class RouletteHistory extends Model
{
    protected $table = 'roulette_history';

    protected $fillable = ['user_id','prize_id','prize_name','prize_value'];

    protected $casts = ['prize_value' => 'float'];

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
