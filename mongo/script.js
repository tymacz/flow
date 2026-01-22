// script.js
const mongoose = require('mongoose');

// 1. Connexion à ta base Docker (localhost:27017)
// "mon_projet" sera le nom de la base de données
mongoose.connect('mongodb://localhost:27017/mon_projet')
  .then(() => console.log('✅ Connecté à MongoDB via Docker !'))
  .catch(err => console.error('❌ Erreur de connexion:', err));

// 2. Définition du "Schéma" 
// C'est l'équivalent de ta structure de table, mais flexible
const UtilisateurSchema = new mongoose.Schema({
  nom: String,
  email: String,
  date_inscription: { type: Date, default: Date.now }, // Champ auto
  preferences: {
    theme: String,
    notifications: Boolean
  }
});

// 3. Création du Modèle
// Mongoose va créer une collection nommée "utilisateurs" (au pluriel, en minuscule)
const Utilisateur = mongoose.model('Utilisateur', UtilisateurSchema);

// 4. Fonction pour insérer la donnée
async function initialiserBase() {
  try {
    // On crée un nouvel utilisateur
    const premierUser = new Utilisateur({
      nom: "Tymacz",
      email: "tymacz@test.com",
      preferences: { 
        theme: "sombre", 
        notifications: true 
      }
    });

    // On sauvegarde dans la base (C'est là que la collection se crée réellement)
    await premierUser.save();
    console.log('🎉 Utilisateur sauvegardé avec succès !');

    // On vérifie en affichant tout ce qu'il y a dans la base
    const tousLesUsers = await Utilisateur.find();
    console.log('📂 Contenu de la collection :', tousLesUsers);

  } catch (error) {
    console.error('Erreur :', error);
  } finally {
    // On coupe la connexion proprement à la fin
    mongoose.connection.close();
  }
}

initialiserBase();