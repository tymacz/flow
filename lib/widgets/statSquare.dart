import 'package:flutter/material.dart';

class StatSquare extends StatefulWidget {
  const StatSquare({super.key, required this.logo, required this.label, required this.value});
  final String logo;
  final String label;
  final String value;
  @override
  State<StatSquare> createState() => _StatSquareState();
}
class _StatSquareState extends State<StatSquare> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: 200,
      decoration: BoxDecoration(
        color: Color.fromRGBO(165, 243, 252, 1),
        borderRadius: BorderRadius.circular(20.0),
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
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Text(widget.logo, style: const TextStyle(fontSize: 40),),
    SizedBox(height: 10),
    Text(
      widget.value,
      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
    ),
    SizedBox(height: 5),
    Text(
      widget.label,
      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
    ),
  ]
)
    );
  }}
