<?php

namespace App\Models;

use MongoDB\Laravel\Eloquent\Model;

class MoodLog extends Model
{
    protected $collection = 'humeurs_log';

    protected $fillable = [
        'utilisateur_id', 'emotion_id',
        'intensite', 'note_personnelle', 'date_heure',
        // Champs "cache" optionnels pour éviter des requêtes (dénormalisation)
        'emotion_snapshot_nom',
        'emotion_snapshot_emoji'
    ];

    protected $casts = [
        'date_heure' => 'datetime'
    ];

    public function user() {
        return $this->belongsTo(User::class);
    }

    public function emotion() {
        return $this->belongsTo(Emotion::class);
    }
}