import 'package:flutter/material.dart';

class SwitchCustom extends StatefulWidget {
  const SwitchCustom({super.key});

  @override
  State<SwitchCustom> createState() => _SwitchCustomState();
}

class _SwitchCustomState extends State<SwitchCustom> {
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