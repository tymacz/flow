<?php

namespace App\Models;

use MongoDB\Laravel\Eloquent\Model;

class Article extends Model
{
    protected $connection = 'mongodb';
    protected $collection = 'articles';

    protected $fillable = ['titre', 'contenu', 'auteur', 'tags', 'image_url', 'date_publication'];

    protected $casts = [
        'tags' => 'array',
        'date_publication' => 'datetime'
    ];
}