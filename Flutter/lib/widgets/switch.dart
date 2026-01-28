import 'package:flutter/material.dart';

class SwitchCustom extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const SwitchCustom({
    super.key, 
    required this.value, 
    required this.onChanged
  });

  // On garde ton design d'icônes
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
          activeTrackColor: const Color.fromRGBO(56, 107, 246, 1),
          thumbIcon: thumbIcon,
          value: value, // Utilise la valeur reçue (User Prefs)
          onChanged: onChanged, // Renvoie la nouvelle valeur au parent
        ),
      ],
    );
  }
}