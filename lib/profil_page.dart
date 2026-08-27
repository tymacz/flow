import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({super.key});
  final nom = 'Maxence Rebours';
  final email = 'maxence.rebours@viacesi.fr';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mon Profil',style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),),
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
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
    BoxShadow(
      color: Color.fromRGBO(50, 50, 93, 0.25),
      blurRadius: 27,
      spreadRadius: -5,
      offset: Offset(0, 13),
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.3),
      blurRadius: 16,
      spreadRadius: -8,
      offset: Offset(0, 8),
    )
  ],
                  ),
                  child: ListTile(
                    style: ListTileStyle.list,
                    leading: const Icon(Icons.lock_outline_sharp),
                    title: const Text('Changer mot de passe',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: (){},
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
    BoxShadow(
      color: Color.fromRGBO(50, 50, 93, 0.25),
      blurRadius: 27,
      spreadRadius: -5,
      offset: Offset(0, 13),
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.3),
      blurRadius: 16,
      spreadRadius: -8,
      offset: Offset(0, 8),
    )
  ],
                  ),
                  child: ListTile(
                    style: ListTileStyle.list,
                    leading: const Icon(Icons.sd_card_outlined),
                    title: const Text('Gérer mes données',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    trailing: const Icon(Icons.arrow_forward_ios),
                    onTap: (){},
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromRGBO(244, 63, 94, 1),
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: [
    BoxShadow(
      color: Color.fromRGBO(50, 50, 93, 0.25),
      blurRadius: 27,
      spreadRadius: -5,
      offset: Offset(0, 13),
    ),
    BoxShadow(
      color: Color.fromRGBO(0, 0, 0, 0.3),
      blurRadius: 16,
      spreadRadius: -8,
      offset: Offset(0, 8),
    )
  ],
                  ),
                  child: ListTile(
                    style: ListTileStyle.list,
                    leading: const Icon(Icons.exit_to_app_outlined,color: Colors.white,),
                    title: const Text('Se déconnecter',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: Colors.white),),
                    onTap: (){},
                  ),
                ),
              ],
            )
            )
            )
    )
    );
  }
}