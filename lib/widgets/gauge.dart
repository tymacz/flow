import 'package:flutter/material.dart';
import 'package:girix_code_gauge/girix_code_gauge.dart';

class GaugeCustom extends StatefulWidget {
  const GaugeCustom({super.key, required this.score});

  final double score;
  @override
  State<GaugeCustom> createState() => _GaugeCustomState();
}

class _GaugeCustomState extends State<GaugeCustom> {
  @override
  Widget build(BuildContext context) {
    return Stack(
  alignment: Alignment.center,
  children: [
    GxRadialGauge(
      showValueAtCenter: false,
      startAngleInDegree: -90,
      value: GaugeValue(
        value: widget.score,
      ),
      showLabels: false,
      labelTickStyle: const RadialTickLabelStyle(
        padding: 30,
      ),
      interval: 10,
      style: const RadialGaugeStyle(
        thickness: 20,
        gradient: LinearGradient(
          colors: [
            Color.fromRGBO(56, 107, 246, 1),
            Color.fromRGBO(165, 243, 252, 1),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 1.0],
        ),
      ),
    ),
    Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          '${widget.score} %', // Ta valeur
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Color.fromRGBO(56, 107, 246, 1),
          ),
        )
      ],
    ),
  ],
);  }
}