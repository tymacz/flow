<?php

namespace App\Models;

use MongoDB\Laravel\Eloquent\Model;
use Illuminate\Contracts\Auth\Authenticatable as AuthenticatableContract;
use Illuminate\Auth\Authenticatable;
use Laravel\Sanctum\HasApiTokens;
use Illuminate\Support\Str; // <--- IMPORTANT : N'oubliez pas cet import

class User extends Model implements AuthenticatableContract
{
    use Authenticatable, HasApiTokens;

    protected $connection = 'mongodb';
    protected $collection = 'utilisateurs';
    protected $fillable = [
        'prenom', 'nom', 'email', 'password', 'role',
        'avatar_url',
        'preferences',
        'date_inscription', 'favoris_ids'
    ];

    protected $casts = [
        'date_inscription' => 'datetime',
        'favoris_ids' => 'array',
        'preferences' => 'array',
        'password' => 'hashed',
    ];

    /**
     * SURCHARGE DE LA MÉTHODE createToken
     * On réécrit la méthode pour qu'elle accepte notre modèle Mongo
     * et ne plante pas sur le typage strict.
     */
    public function createToken(string $name, array $abilities = ['*'], \DateTimeInterface $expiresAt = null)
    {
        // 1. On crée manuellement la chaîne du token
        $plainTextToken = sprintf(
            '%s%s%s',
            config('sanctum.token_prefix', ''),
            $tokenEntropy = Str::random(40),
            hash('crc32b', $tokenEntropy)
        );

        // 2. On enregistre le token dans MongoDB via la relation
        $token = $this->tokens()->create([
            'name' => $name,
            'token' => hash('sha256', $plainTextToken),
            'abilities' => $abilities,
            'expires_at' => $expiresAt,
        ]);

        // 3. On retourne un objet "NewAccessToken" personnalisé
        // C'est ici qu'on contourne l'erreur "TypeError"
        return new class($token, $token->getKey().'|'.$plainTextToken) {
            public $accessToken;
            public $plainTextToken;

            public function __construct($accessToken, $plainTextToken) {
                $this->accessToken = $accessToken;
                $this->plainTextToken = $plainTextToken;
            }
        };
    }
}