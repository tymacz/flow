import 'package:flutter/material.dart';

class HistoricLine extends StatefulWidget {
  const HistoricLine({super.key, required this.activiteType, required this.date, required this.activite});
  final String activiteType;
  final String date;
  final String activite;

  @override
  State<HistoricLine> createState() => _HistoricLineState();
}

class _HistoricLineState extends State<HistoricLine> {

  @override
  Widget build(BuildContext context) {
  Color barColor;
  if(widget.activiteType == 'Méditation'){
    barColor = Color.fromRGBO(165, 243, 252, 1);
  } else if (widget.activiteType == 'Exercice'){
    barColor = Color.fromRGBO(56, 107, 246, 1);
  } else {
    barColor = Colors.grey;
  }
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: const [
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
      child: IntrinsicHeight( 
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: 10,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            const SizedBox(width: 10),
            Flexible( 
              child: Text(
                "${widget.date} - ${widget.activite}",
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}