import 'package:flutter/material.dart';

class SliderCustom extends StatefulWidget {
  const SliderCustom({super.key});

  @override
  State<SliderCustom> createState() => _SliderCustomState();
}

class _SliderCustomState extends State<SliderCustom> {
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