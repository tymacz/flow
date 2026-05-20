<?php

namespace App\Models;

use MongoDB\Laravel\Eloquent\Model;

class Mood extends Model
{
    protected $connection = 'mongodb';
    protected $collection = 'moods';

    protected $fillable = [
        'user_id',
        'score',         // Note de 1 à 5
        'main_emotion',  // ex: Joie, Tristesse...
        'sub_emotion',   // ex: Excité, Serein...
        'created_at'
    ];

    protected $casts = [
        'created_at' => 'datetime',
    ];
}