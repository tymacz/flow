<?php

namespace App\Models;

use MongoDB\Laravel\Eloquent\Model;

class Emotion extends Model
{
    protected $collection = 'ref_emotions';

    protected $fillable = ['libelle', 'emoji', 'couleur_hex', 'parent_id'];

    // Relation récursive pour récupérer les sous-émotions
    public function children() {
        return $this->hasMany(Emotion::class, 'parent_id', '_id');
    }

    public function parent() {
        return $this->belongsTo(Emotion::class, 'parent_id', '_id');
    }
}