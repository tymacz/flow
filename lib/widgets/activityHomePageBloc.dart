import 'package:flutter/material.dart';

class Activityhomepagebloc extends StatefulWidget {
  const Activityhomepagebloc({super.key, required this.title,required this.icon, this.onPressed});
  final String title;
  final Icon icon;
  final VoidCallback? onPressed;

  @override
  _ActivityhomepageblocState createState() => _ActivityhomepageblocState();
}

class _ActivityhomepageblocState extends State<Activityhomepagebloc> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: widget.onPressed,
        child: Container(
                        decoration: BoxDecoration(
                          color: const Color.fromRGBO(165, 243, 252, 1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              
                              Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  child: widget.icon,
                                ),
                              ),
                              const SizedBox(height: 10),
                              
                              Text(
                                widget.title,
                                textAlign: TextAlign.left,
                                style: const TextStyle( fontSize: 18),
                              )
                            ],
                          ),
                        ),
                      )
      ),
    );
  }
}