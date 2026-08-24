import 'dart:io'; // Pour gérer le fichier image
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart'; // Pour ouvrir la galerie
import 'package:supabase_flutter/supabase_flutter.dart'; // Pour envoyer l'image

// Tes imports internes
import 'package:flow/providers/providers.dart';
import 'package:flow/pages/login_page.dart';
import 'package:flow/pages/edit_profile_page.dart';
import 'package:flow/widgets/settingSliderLine.dart';
import 'package:flow/widgets/slider.dart';
import 'package:flow/widgets/switch.dart';
import 'package:flow/widgets/settingRedirectionLine.dart';

class ProfilPage extends ConsumerStatefulWidget {
  const ProfilPage({super.key});

  @override
  ConsumerState<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends ConsumerState<ProfilPage> {
  bool _isUploading = false; // État pour afficher le chargement sur l'avatar

  /// 📸 LOGIQUE DE CHANGEMENT DE PHOTO
  Future<void> _changeAvatar() async {
    final picker = ImagePicker();
    
    // 1. Ouvrir la galerie
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery, 
      imageQuality: 60 // On réduit un peu la qualité pour optimiser
    );

    if (image == null) return; // Annulé par l'utilisateur

    setState(() => _isUploading = true);

    try {
      final File file = File(image.path);
      final String fileExt = image.path.split('.').last;
      final String fileName = 'avatars/${DateTime.now().millisecondsSinceEpoch}.$fileExt';

      // 2. Upload vers Supabase (Bucket 'flow-assets')
      await Supabase.instance.client.storage
          .from('flow-assets')
          .upload(fileName, file);

      // 3. Récupérer l'URL publique
      final String publicUrl = Supabase.instance.client.storage
          .from('flow-assets')
          .getPublicUrl(fileName);

      // 4. Mettre à jour l'utilisateur via Laravel
      await ref.read(authUserProvider.notifier).updateUser(avatarUrl: publicUrl);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Photo de profil mise à jour !"), backgroundColor: Colors.green),
        );
      }
    } catch (e) {
      print("Erreur upload: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de l'envoi de l'image"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // On écoute le provider
    final authState = ref.watch(authUserProvider);

    return authState.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => const LoginPage(),
      data: (user) {
        if (user == null) return const LoginPage();

        // Récupération sécurisée des préférences
        final prefs = user.preferences;
        final bool notificationsEnabled = prefs['notifications'] ?? true;
        final bool highContrast = prefs['high_contrast'] ?? false;
        final bool reducedAnimations = prefs['reduced_animations'] ?? false;
        // final double textSize = (prefs['text_size'] ?? 1).toDouble(); // Pour plus tard si tu connectes le slider

        return Scaffold(
          backgroundColor: const Color.fromRGBO(249, 250, 248, 1),
          appBar: AppBar(
            backgroundColor: const Color.fromRGBO(249, 250, 248, 1),
            surfaceTintColor: const Color.fromRGBO(249, 250, 248, 1),
            title: const Text(
              'Mon Profil',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // ---------------------------------------------
                    // 1. ZONE AVATAR (Interactive)
                    // ---------------------------------------------
                    Center(
                      child: GestureDetector(
                        onTap: _isUploading ? null : _changeAvatar,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 80,
                              backgroundColor: Colors.grey.shade200,
                              backgroundImage: user.avatarUrl != null && user.avatarUrl!.isNotEmpty
                                  ? NetworkImage(user.avatarUrl!)
                                  : const NetworkImage('https://i.pinimg.com/1200x/f8/44/0f/f8440f7c70b4a2eb8a9cbce753efffba.jpg'),
                              child: _isUploading
                                  ? const CircularProgressIndicator()
                                  : null,
                            ),
                            // Petite icône caméra
                            Positioned(
                              bottom: 0,
                              right: 5,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color.fromRGBO(99, 102, 241, 1),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 3),
                                ),
                                child: const Icon(Icons.camera_alt, color: Colors.white, size: 22),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // ---------------------------------------------
                    // 2. INFOS UTILISATEUR & ÉDITION
                    // ---------------------------------------------
                    Text(
                      '${user.prenom} ${user.nom}', 
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)
                    ),
                    Text(
                      user.email, 
                      style: const TextStyle(fontSize: 16, color: Colors.grey)
                    ),
                    const SizedBox(height: 15),

                    // Bouton Modifier Profil
                    SizedBox(
                      width: double.infinity,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: const Color.fromRGBO(99, 102, 241, 1),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfilePage(user: user),
                            ),
                          );
                        },
                        child: const Text(
                          'Modifier le profil',
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // ---------------------------------------------
                    // 3. COMPTE & SÉCURITÉ
                    // ---------------------------------------------
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Compte & Sécurité',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
                        text: 'Se déconnecter',
                        onTap: () {
                           ref.read(authUserProvider.notifier).logout();
                        },
                        backgroundColor: const Color.fromRGBO(244, 63, 94, 1),
                        color: Colors.white,
                        leading: const Icon(Icons.exit_to_app_outlined, color: Colors.white)),
                        
                    const SizedBox(height: 20),

                    // ---------------------------------------------
                    // 4. MES PRÉFÉRENCES
                    // ---------------------------------------------
                    const Align(
                        alignment: AlignmentGeometry.centerLeft,
                        child: Text(
                          'Mes Préférences',
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(height: 20),
                    
                    // Switch: Notifications
                    SettingRedirectionLine(
                        text: 'Rappels & Notifications',
                        onTap: () {},
                        backgroundColor: Colors.white,
                        color: Colors.black,
                        leading: const Icon(Icons.notifications_none),
                        trailing: SwitchCustom(
                          value: notificationsEnabled,
                          onChanged: (newValue) {
                            ref.read(authUserProvider.notifier).updateUser(
                              preferences: {'notifications': newValue}
                            );
                          },
                        )),
                        
                    const SizedBox(height: 20),

                    // ---------------------------------------------
                    // 5. ACCESSIBILITÉ & CONFORT
                    // ---------------------------------------------
                    const Align(
                      alignment: AlignmentGeometry.centerLeft,
                      child: Text(
                        "Accessibilité & confort",
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Slider: Taille du texte (Visuel pour l'instant)
                    Settingsliderline(
                        text: 'Taille du texte',
                        onTap: () {},
                        backgroundColor: Colors.white,
                        color: Colors.black,
                        leading: const Icon(Icons.text_fields)),
                        
                    const SizedBox(height: 10),
                    
                    // Switch: Contraste Élevé
                    SettingRedirectionLine(
                        text: 'Mode Contraste Elevé',
                        onTap: () {},
                        backgroundColor: Colors.white,
                        color: Colors.black,
                        leading: const Icon(Icons.remove_red_eye_outlined),
                        trailing: SwitchCustom(
                          value: highContrast,
                          onChanged: (newValue) {
                             ref.read(authUserProvider.notifier).updateUser(
                              preferences: {'high_contrast': newValue}
                            );
                          },
                        )),
                        
                    const SizedBox(height: 10),
                    
                    // Switch: Animations Réduites
                    SettingRedirectionLine(
                        text: 'Animations réduites',
                        onTap: () {},
                        backgroundColor: Colors.white,
                        color: Colors.black,
                        leading: const Icon(Icons.animation_outlined),
                        trailing: SwitchCustom(
                          value: reducedAnimations,
                          onChanged: (newValue) {
                             ref.read(authUserProvider.notifier).updateUser(
                              preferences: {'reduced_animations': newValue}
                            );
                          },
                        )),
                        
                    const SizedBox(height: 20),
                    
                    // ---------------------------------------------
                    // 6. À PROPOS
                    // ---------------------------------------------
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
                    const SizedBox(height: 40),
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