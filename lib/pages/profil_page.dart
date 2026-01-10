import 'package:flow/widgets/settingSliderLine.dart';
import 'package:flow/widgets/slider.dart';
import 'package:flutter/material.dart';
import 'package:flow/widgets/switch.dart';
import 'package:flow/widgets/settingRedirectionLine.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});
  final nom = 'Maxence Rebours';
  final email = 'maxence.rebours@viacesi.fr';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(249,250, 248, 1),
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(249,250, 248, 1),
        surfaceTintColor: Color.fromRGBO(249,250, 248, 1),
        title: const Text('Mon Profil',style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
      ),
      body:SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: [
                const SizedBox(height: 20,),
                const Center(
                  child:
                    const CircleAvatar(
                      radius: 80,
                      backgroundImage: NetworkImage('https://i.pinimg.com/1200x/f8/44/0f/f8440f7c70b4a2eb8a9cbce753efffba.jpg'),
                ),
                ),
                const SizedBox(height: 20,),
                Text(
                  '$nom',
                  style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                Text(
                  '$email',
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 5,),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color.fromRGBO(99, 102, 241, 1),
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    onPressed: (){}, child: Text(
                    'Modifier le profil',
                    style: const TextStyle(color: Colors.white, fontSize: 20),
                  )),
                ),
                const SizedBox(height: 20,),
                const Align(
                  alignment: Alignment.centerLeft,
                  child:
                const Text('Compte & Sécurité',style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),textAlign: TextAlign.left,),
                ),
                const SizedBox(height: 10,),
                SettingRedirectionLine(text: 'Changer mot de passe', onTap: (){}, leading: const Icon(Icons.lock_outline_sharp), trailing: const Icon(Icons.arrow_forward_ios), backgroundColor: Colors.white, color: Colors.black),
                const SizedBox(height: 10,),
                SettingRedirectionLine(text: 'Gérer mes données', onTap: (){}, leading: const Icon(Icons.sd_card_outlined), trailing: const Icon(Icons.arrow_forward_ios), backgroundColor: Colors.white, color: Colors.black),
                const SizedBox(height: 10,),
                SettingRedirectionLine(text: 'Se déconnecter', onTap: ( ) {} , backgroundColor: Color.fromRGBO(244, 63, 94, 1), color: Colors.white, leading: const Icon(Icons.exit_to_app_outlined,color: Colors.white,)),
                SizedBox(height: 20,),
                Align(
                  alignment: AlignmentGeometry.centerLeft ,
                  child: 
                  Text('Mes Préférences',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),textAlign: TextAlign.left,)
                  ),
                SizedBox(height: 20,),
                SettingRedirectionLine(text: 'Objectif quotidien', onTap: ( ) {} , leading: Icon(Icons.access_time), backgroundColor: Colors.white, color: Colors.black),
                SizedBox(height: 10,),
                SettingRedirectionLine(text: 'Rappels & Notifications', onTap: (){}, backgroundColor: Colors.white, color: Colors.black, leading: const Icon(Icons.notifications_none), trailing: SwitchCustom()),
                SizedBox(height: 20,),
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child:
                  Text("Accessibilité & confort",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 20,),
                Settingsliderline(text: 'Taille du texte', onTap: (){}, backgroundColor: Colors.white, color: Colors.black, leading: const Icon(Icons.text_fields)),
                SizedBox(height: 10,),
                SettingRedirectionLine(text: 'Mode Contraste Elevé', onTap: (){}, backgroundColor: Colors.white, color: Colors.black, leading: const Icon(Icons.remove_red_eye_outlined), trailing: SwitchCustom()),
                SizedBox(height: 10,),
                SettingRedirectionLine(text: 'Animation réduites', onTap: (){}, backgroundColor: Colors.white, color: Colors.black, leading: const Icon(Icons.animation_outlined), trailing: SwitchCustom()),
                SizedBox(height: 20,),
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child:
                  Text("À propos",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 20,),
                SettingRedirectionLine(text: 'Aide & Support', onTap: ( ) {} , backgroundColor: Colors.white, color: Colors.black),
                SizedBox(height: 10,),
                SettingRedirectionLine(text: 'Mentions Légales', onTap: ( ) {}, backgroundColor: Colors.white, color: Colors.black),
              ],
            )
            )
            )
    )
    );
  }
}