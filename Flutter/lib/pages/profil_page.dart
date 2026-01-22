import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flow/providers/providers.dart';
import 'package:flow/pages/login_page.dart'; // Importe ta login page

// Tes widgets existants
import 'package:flow/widgets/settingSliderLine.dart';
import 'package:flow/widgets/slider.dart';
import 'package:flow/widgets/switch.dart';
import 'package:flow/widgets/settingRedirectionLine.dart';

class ProfilPage extends ConsumerWidget {
  const ProfilPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. On écoute l'état de l'utilisateur
    final authState = ref.watch(authUserProvider);

    return authState.when(
      // CAS 1 : CHARGEMENT
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      
      // CAS 2 : ERREUR (On affiche le login par sécurité)
      error: (err, stack) => const LoginPage(),

      // CAS 3 : DONNÉES DISPONIBLES (Connecté ou Null)
      data: (user) {
        // SI PAS CONNECTÉ -> LOGIN PAGE
        if (user == null) {
          return const LoginPage();
        }

        // SI CONNECTÉ -> TON DESIGN DE PROFIL
        return Scaffold(
          backgroundColor: const Color.fromRGBO(249, 250, 248, 1),
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(249, 250, 248, 1),
            surfaceTintColor: const Color.fromRGBO(249, 250, 248, 1),
            title: const Text('Mon Profil',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: CircleAvatar(
                        radius: 80,
                        // Gestion de l'avatar (fallback si null)
                        backgroundImage: const NetworkImage(
                            'https://i.pinimg.com/1200x/f8/44/0f/f8440f7c70b4a2eb8a9cbce753efffba.jpg'),
                        // Idéalement : user.avatarUrl != null ? NetworkImage(user.avatarUrl!) : ...
                      ),
                    ),
                    const SizedBox(height: 20),
                    // DONNÉES DYNAMIQUES ICI 👇
                    Text(
                      '${user.prenom} ${user.nom}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      user.email,
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 5),
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(99, 102, 241, 1),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () {},
                        child: const Text(
                          'Modifier le profil',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Compte & Sécurité',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    const SizedBox(height: 10),
                    SettingRedirectionLine(
                        text: 'Changer mot de passe',
                        onTap: () {},
                        leading: const Icon(Icons.lock_outline_sharp),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        backgroundColor: Colors.white,
                        color: Colors.black),
                    const SizedBox(height: 10),
                    SettingRedirectionLine(
                        text: 'Gérer mes données',
                        onTap: () {},
                        leading: const Icon(Icons.sd_card_outlined),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        backgroundColor: Colors.white,
                        color: Colors.black),
                    const SizedBox(height: 10),
                    
                    // BOUTON DÉCONNEXION 👇
                    SettingRedirectionLine(
                        text: 'Se déconnecter',
                        onTap: () {
                           // Appel au provider pour déconnecter
                           ref.read(authUserProvider.notifier).logout();
                        },
                        backgroundColor: const Color.fromRGBO(244, 63, 94, 1),
                        color: Colors.white,
                        leading: const Icon(
                          Icons.exit_to_app_outlined,
                          color: Colors.white,
                        )),
                        
                    const SizedBox(height: 20),
                    const Align(
                        alignment: AlignmentGeometry.centerLeft,
                        child: Text(
                          'Mes Préférences',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        )),
                    const SizedBox(height: 20),
                    SettingRedirectionLine(
                        text: 'Objectif quotidien',
                        onTap: () {},
                        leading: const Icon(Icons.access_time),
                        backgroundColor: Colors.white,
                        color: Colors.black),
                    const SizedBox(height: 10),
                    SettingRedirectionLine(
                        text: 'Rappels & Notifications',
                        onTap: () {},
                        backgroundColor: Colors.white,
                        color: Colors.black,
                        leading: const Icon(Icons.notifications_none),
                        trailing: const SwitchCustom()),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: AlignmentGeometry.centerLeft,
                      child: Text(
                        "Accessibilité & confort",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Settingsliderline(
                        text: 'Taille du texte',
                        onTap: () {},
                        backgroundColor: Colors.white,
                        color: Colors.black,
                        leading: const Icon(Icons.text_fields)),
                    const SizedBox(height: 10),
                    SettingRedirectionLine(
                        text: 'Mode Contraste Elevé',
                        onTap: () {},
                        backgroundColor: Colors.white,
                        color: Colors.black,
                        leading: const Icon(Icons.remove_red_eye_outlined),
                        trailing: const SwitchCustom()),
                    const SizedBox(height: 10),
                    SettingRedirectionLine(
                        text: 'Animation réduites',
                        onTap: () {},
                        backgroundColor: Colors.white,
                        color: Colors.black,
                        leading: const Icon(Icons.animation_outlined),
                        trailing: const SwitchCustom()),
                    const SizedBox(height: 20),
                    const Align(
                      alignment: AlignmentGeometry.centerLeft,
                      child: Text(
                        "À propos",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    SettingRedirectionLine(
                        text: 'Aide & Support',
                        onTap: () {},
                        backgroundColor: Colors.white,
                        color: Colors.black),
                    const SizedBox(height: 10),
                    SettingRedirectionLine(
                        text: 'Mentions Légales',
                        onTap: () {},
                        backgroundColor: Colors.white,
                        color: Colors.black),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}