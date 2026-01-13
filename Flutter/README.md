# 🌊 Flow - Votre espace de sérénité

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![Status](https://img.shields.io/badge/status-In_Development-orange.svg)
![License](https://img.shields.io/badge/license-Proprietary-red.svg)

> **Projet scolaire.** > Développé par **Tymacz Inc.**

---

## 📖 À propos du projet

**Flow** est une application mobile cross-platform (iOS/Android/Web) dédiée à l'accompagnement de la santé mentale et à la gestion du stress. 

Dans un contexte post-crise sanitaire où les troubles anxieux ont augmenté de 25%, l'objectif est de fournir une solution numérique de "première ligne" pour désengorger les services de consultation physique. L'application se veut **accessible à tous** (normes RGAA) et repose sur une approche bienveillante ("Calm Tech").

## ✨ Fonctionnalités Principales

L'application s'articule autour de quatre piliers fonctionnels:

* 🧠 **Diagnostic du Stress :** Auto-évaluation basée sur l'échelle scientifique de *Holmes et Rahe*.
* 🫁 **Exercices de Respiration :** Module de Cohérence Cardiaque paramétrable (7-4-8, 5-5, etc.) disponible hors-ligne.
* 📊 **Tracker d'Émotions :** Journal de bord pour suivre l'évolution de son humeur et identifier les déclencheurs de stress.
* 🧘 **Catalogue Détente :** Bibliothèque d'activités et de contenus éducatifs sur la santé mentale.

## 🛠️ Stack Technique

Ce projet met en œuvre une architecture moderne et découplée :

| Composant | Technologie | Détails |
| :--- | :--- | :--- |
| **Mobile (Front)** | ![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat&logo=flutter&logoColor=white) | Langage Dart, Architecture **BLoC**, Mode **Offline-First**. |
| **Backend (API)** | ![Laravel](https://img.shields.io/badge/Laravel-FF2D20?style=flat&logo=laravel&logoColor=white) | Langage PHP, Architecture **MVC**, Sécurité JWT. |
| **Base de Données** | ![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=flat&logo=mongodb&logoColor=white) | **NoSQL** pour la flexibilité des logs émotionnels. |

### Architecture & Design Patterns
* **Mobile :** Pattern BLoC pour la gestion d'état, Repository Pattern pour la gestion des données (Switch API/Cache Local).
* **Sécurité :** Chiffrement AES-256 des données sensibles (HDS), Communication HTTPS (TLS 1.3).
