<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Activity;
use App\Models\Article;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    public function run(): void
    {
        // 1. Nettoyage (On vide les collections pour ne pas avoir de doublons)
        Activity::truncate();
        Article::truncate();
        // Optionnel : User::truncate(); // Décommente si tu veux supprimer les utilisateurs aussi

        $this->command->info('🧹 Base de données nettoyée !');

        // 2. Création des Activités (Yoga, Méditation, etc.)
        $activites = [
            [
                'titre' => 'Salutation au Soleil',
                'description' => 'Un enchaînement dynamique de postures de yoga pour réveiller le corps et l\'esprit dès le matin.',
                'duree_minutes' => 15,
                'categorie' => 'Yoga',
                'image_url' => 'https://images.unsplash.com/photo-1544367563-12123d8965cd?auto=format&fit=crop&w=800&q=80',
            ],
            [
                'titre' => 'Méditation Guidée : Lâcher Prise',
                'description' => 'Une séance audio pour apprendre à accepter ses émotions et réduire le stress quotidien.',
                'duree_minutes' => 10,
                'categorie' => 'Méditation',
                'image_url' => 'https://images.unsplash.com/photo-1506126613408-eca07ce68773?auto=format&fit=crop&w=800&q=80',
            ],
            [
                'titre' => 'Respiration Carrée (Box Breathing)',
                'description' => 'Technique de respiration puissante utilisée pour retrouver son calme en situation de stress intense.',
                'duree_minutes' => 5,
                'categorie' => 'Respiration',
                'image_url' => 'https://images.unsplash.com/photo-1518241353330-0f7941c2d9b5?auto=format&fit=crop&w=800&q=80',
            ],
            [
                'titre' => 'Séance HIIT : Énergie Maximale',
                'description' => 'Entraînement par intervalles à haute intensité pour booster le cardio et l\'endorphine.',
                'duree_minutes' => 20,
                'categorie' => 'Sport',
                'image_url' => 'https://images.unsplash.com/photo-1517836357463-d25dfeac3438?auto=format&fit=crop&w=800&q=80',
            ]
        ];

        foreach ($activites as $data) {
            Activity::create($data);
        }
        $this->command->info('🧘 Activités créées avec succès.');

        // 3. Création des Articles (Conseils, Blog)
        $articles = [
            [
                'titre' => '5 astuces pour un sommeil réparateur',
                'contenu' => "Le sommeil est la clé de la santé mentale. 1. Évitez les écrans 1h avant... 2. Gardez la chambre fraîche... 3. Essayez la lecture...",
                'auteur' => 'Dr. Sophie Zen',
                'tags' => ['Sommeil', 'Santé', 'Conseils'],
                'date_publication' => now()->subDays(2),
                'image_url' => 'https://images.unsplash.com/photo-1511295742362-92c96b504802?auto=format&fit=crop&w=800&q=80'
            ],
            [
                'titre' => 'Pourquoi l\'hydratation change votre humeur',
                'contenu' => "Saviez-vous qu'une légère déshydratation peut augmenter l'anxiété ? Boire de l'eau est le geste bien-être le plus simple...",
                'auteur' => 'Marc Eau',
                'tags' => ['Nutrition', 'Humeur'],
                'date_publication' => now()->subDays(10),
                'image_url' => 'https://images.unsplash.com/photo-1548839140-29a749e1cf4d?auto=format&fit=crop&w=800&q=80'
            ],
            [
                'titre' => 'Comprendre le Burn-out',
                'contenu' => "L'épuisement professionnel ne prévient pas. Apprenez à reconnaître les signes avant-coureurs : fatigue chronique, cynisme...",
                'auteur' => 'Psychologie Mag',
                'tags' => ['Travail', 'Mental', 'Prévention'],
                'date_publication' => now()->subMonth(1),
                'image_url' => 'https://images.unsplash.com/photo-1499209974431-9dddcece7f88?auto=format&fit=crop&w=800&q=80'
            ]
        ];

        foreach ($articles as $data) {
            Article::create($data);
        }
        $this->command->info('📰 Articles créés avec succès.');

        // 4. Création d'un User de test (si tu veux tester le login sans t'inscrire à chaque fois)
        // Vérifie d'abord s'il n'existe pas déjà
        if (!User::where('email', 'admin@flow.com')->exists()) {
            User::create([
                'prenom' => 'Admin',
                'nom' => 'Flow',
                'email' => 'admin@flow.com',
                'password' => Hash::make('password'), // Mot de passe facile pour les tests
                'role' => 'ADMIN',
                'favoris_ids' => [],
                'date_inscription' => now(),
            ]);
            $this->command->info('👤 Utilisateur de test créé (admin@flow.com / password)');
        }
    }
}