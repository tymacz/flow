import 'package:flutter/material.dart';


class SettingRedirectionLine extends StatefulWidget {
  const SettingRedirectionLine({super.key, required this.text,this.leading, this.trailing, required this.onTap, required this.backgroundColor, required this.color});

  final String text;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color color;

  @override
  State<SettingRedirectionLine> createState() => _SettingRedirectionLineState();
}

class _SettingRedirectionLineState extends State<SettingRedirectionLine> {
  @override
  Widget build(BuildContext context) {
    return Container(
                  decoration: BoxDecoration(
                    color: widget.backgroundColor,
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
                      ),
                    ],
                  ),
                  child: ListTile(
                    style: ListTileStyle.list,
                    leading: widget.leading,
                    title: Text('${widget.text}',style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: widget.color),),
                    trailing: widget.trailing,
                    onTap: widget.onTap,
                  ),
                );
  }
}