<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class RoulettePrize extends Model
{
    protected $table = 'roulette_prizes';

    protected $fillable = ['name','value','probability','status'];

    protected $casts = ['value' => 'float', 'probability' => 'integer', 'status' => 'boolean'];
}
