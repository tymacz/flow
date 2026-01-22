<?php

namespace App\Models;

use MongoDB\Laravel\Eloquent\Model;

class Activity extends Model
{
    protected $connection = 'mongodb';
    protected $collection = 'activities';

    protected $fillable = ['titre', 'description', 'duree_minutes', 'categorie', 'image_url'];
}