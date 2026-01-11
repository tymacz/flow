import 'package:flutter/material.dart';

class ContentPreview extends StatefulWidget {
  const ContentPreview({super.key,required this.type, required this.title, required this.description});
  final String type;
  final String title;
  final String description;
  @override
  State<ContentPreview> createState() => _ContentPreviewState();
}

class _ContentPreviewState extends State<ContentPreview> {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Container(
                width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
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
        ] ,),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${widget.type}',
                       style: TextStyle(fontSize: 18,color: Colors.blue),
                       textAlign: TextAlign.left,
                    ),
                    SizedBox(height: 10),
                    Text('${widget.title}', style: TextStyle(fontSize: 18,color: Colors.black, fontWeight: FontWeight.bold),),
                    SizedBox(height: 10),
                    Text('${widget.description}', style: TextStyle(fontSize: 16,color: Colors.grey[700]),),
                  ],
                ),
              ),),
    );
  }
}