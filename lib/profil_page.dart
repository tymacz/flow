import 'package:flutter/material.dart';

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
                SizedBox(height: 20,),
                Align(
                  alignment: AlignmentGeometry.centerLeft ,
                  child: 
                  Text('Mes Préférences',style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),textAlign: TextAlign.left,)
                  ),
                SizedBox(height: 20,),
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
                    leading: const Icon(Icons.access_time),
                    title: const Text('Objectif quotidien',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    
                    onTap: (){},
                  ),
                ),
                SizedBox(height: 10,),
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
                    leading: const Icon(Icons.notifications_none),
                    title: const Text('Rappels & Notifications',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    trailing: SwitchExample(),
                    onTap: (){},
                  ),
                ),
                SizedBox(height: 20,),
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child:
                  Text("Accessibilité & comfort",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 20,),
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
                  child: Column(
                    children:[ListTile(
                    style: ListTileStyle.list,
                    leading: const Icon(Icons.text_fields),
                    title: const Text('Taille du texte',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    onTap: (){},
                  ),
                  TailleSlider()
                  ]),
                ),
                SizedBox(height: 10,),
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
                    leading: const Icon(Icons.remove_red_eye_outlined),
                    title: const Text('Mode Contraste Elevé',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    trailing: SwitchExample(),
                    onTap: (){},
                  ),
                ),
                SizedBox(height: 10,),
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
                    leading: const Icon(Icons.animation_outlined),
                    title: const Text('Animation réduites',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    trailing: SwitchExample(),
                    onTap: (){},
                  ),
                ),
                SizedBox(height: 20,),
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child:
                  Text("À propos",style: TextStyle(fontSize: 24,fontWeight: FontWeight.bold),),
                ),
                SizedBox(height: 20,),
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
                    title: const Text('Aide & Support',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    onTap: (){},
                  ),
                ),
                SizedBox(height: 10,),
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
                    title: const Text('Mentions Légales',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                    onTap: (){},
                  ),
                )

              ],
            )
            )
            )
    )
    );
  }
}



class SwitchExample extends StatefulWidget {
  const SwitchExample({super.key});

  @override
  State<SwitchExample> createState() => _SwitchExampleState();
}

class _SwitchExampleState extends State<SwitchExample> {
  bool light1 = true;

  static const WidgetStateProperty<Icon> thumbIcon = WidgetStateProperty<Icon>.fromMap(
    <WidgetStatesConstraint, Icon>{
      WidgetState.selected: Icon(Icons.check),
      WidgetState.any: Icon(Icons.close),
    },
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Switch(
          activeTrackColor: Color.fromRGBO(56, 107, 246, 1),
          thumbIcon: thumbIcon,
          value: light1,
          onChanged: (bool value) {
            setState(() {
              light1 = value;
            });
          },
        ),
      ],
    );
  }
}


class TailleSlider extends StatefulWidget {
  const TailleSlider({super.key});

  @override
  State<TailleSlider> createState() => _TailleSliderState();
}

class _TailleSliderState extends State<TailleSlider> {
  double _currentValue = 1;

  String _getLabel(double value) {
    if (value == 0) return "  Petit   ";
    if (value == 1) return "  Moyen   ";
    return "  Grand   ";
  }

  double _getLabelFontSize(double value) {
    if (value == 0) return 14.0;
    if (value == 1) return 20.0; 
    return 30.0;
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            valueIndicatorTextStyle: TextStyle(
              fontSize: _getLabelFontSize(_currentValue),
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            valueIndicatorColor: Color.fromRGBO(56, 107, 246, 1),
          ),
          child: Slider(
            value: _currentValue,
            min: 0,
            max: 2,
            divisions: 2,
            activeColor: Color.fromRGBO(56, 107, 246, 1),
            label: _getLabel(_currentValue), 
            onChanged: (double value) {
              setState(() {
                _currentValue = value;
              });
            },
          ),
        ),
      ],
    );
  }
}