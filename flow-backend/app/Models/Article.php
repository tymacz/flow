<?php

namespace App\Models;

use MongoDB\Laravel\Eloquent\Model;

class Article extends Model
{
    protected $collection = 'articles';

    protected $fillable = [
        'titre', 'description', 'image_url',
        'duree_affichage', 'duree_secondes',
        'type', 'media_url'
    ];
}