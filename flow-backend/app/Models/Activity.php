<?php

namespace App\Models;

use MongoDB\Laravel\Eloquent\Model;

class Activity extends Model
{
    protected $collection = 'activites';

    protected $fillable = [
        'titre', 'description', 'image_url',
        'duree_affichage', 'duree_secondes',
        'type', 'media_url', 'est_premium'
    ];
}