<?php

namespace App\Models;

use MongoDB\Laravel\Eloquent\Model; // N'oublie pas : MongoDB !

class UserActivity extends Model
{
    protected $connection = 'mongodb';
    protected $collection = 'user_activities';

    protected $fillable = ['user_id', 'activity_title', 'activity_type', 'duration_minutes'];

    protected $casts = [
        'created_at' => 'datetime',
    ];
}
