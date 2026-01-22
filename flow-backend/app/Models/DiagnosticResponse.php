<?php

namespace App\Models;

use MongoDB\Laravel\Eloquent\Model;

class DiagnosticResponse extends Model
{
    protected $collection = 'reponses_diagnostic';

    protected $fillable = [
        'utilisateur_id', 'date_passage', 'score_global', 'reponses'
    ];

    // Mongo gère nativement le JSON, pas besoin de cast "array" complexe
    // Laravel le traitera comme un tableau associatif PHP automatiquement
}