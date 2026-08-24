<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('user_activities', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id'); // Lien vers l'utilisateur
            $table->string('activity_title'); // Titre (ex: "Yoga Matin")
            $table->string('activity_type'); // Type (ex: "Sport", "Méditation")
            $table->integer('duration_minutes'); // Durée (ex: 15)
            $table->timestamps(); // created_at servira de date de réalisation
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('user_activities');
    }
};
