<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class FreeSpin extends Model
{
    protected $table = 'free_spins';

    protected $fillable = ['user_id', 'game_id', 'game_code', 'game_name', 'rounds', 'rounds_played', 'bet', 'total_win', 'status', 'origin', 'transaction_id', 'external_id', 'error', 'expires_at'];

    protected $casts = ['expires_at' => 'datetime', 'total_win' => 'float', 'bet' => 'float'];

    protected $appends = ['rounds_remaining'];

    public function getRoundsRemainingAttribute(): int
    {
        return max(0, (int) $this->rounds - (int) $this->rounds_played);
    }

    public function user()
    {
        return $this->belongsTo(User::class);
    }
}
