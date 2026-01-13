import 'package:flutter/material.dart';

class Activitycarousselelement extends StatefulWidget {
  final String name;
  final Icon icon;
  final String durating;
  const Activitycarousselelement({super.key, required this.name, required this.icon, required this.durating});

  @override
  _ActivitycarousselelementState createState() => _ActivitycarousselelementState();
}

class _ActivitycarousselelementState extends State<Activitycarousselelement> {
  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          widget.icon,
                          SizedBox(width: 10),
                          Flexible(child: Text(widget.name,overflow: TextOverflow.clip, style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold, color: Colors.white))),
                        ],
                      ),
                    ),
                    TextButton(style: ButtonStyle(backgroundColor: WidgetStateProperty.all<Color>(Colors.white)), onPressed: () {  }, child: Text('Démarrer ( ${widget.durating} )', style: TextStyle(fontSize: 18, color: Colors.black))),
              ],
            ),
          );
  }
} 