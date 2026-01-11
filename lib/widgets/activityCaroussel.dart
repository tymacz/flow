import 'package:flutter/material.dart';

class ActivityCaroussel extends StatefulWidget {
  final List<Widget> activities;
  const ActivityCaroussel({super.key, required this.activities});

  @override
  _ActivityCarousselState createState() => _ActivityCarousselState();
}

class _ActivityCarousselState extends State<ActivityCaroussel> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentIndex = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220, 
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.activities.length,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0), // Espace entre les cartes
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color.fromRGBO(56, 107, 246, 1), Color.fromRGBO(165, 243, 252, 1)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
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
                  child: widget.activities[index],
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.activities.length, (index) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              height: 8.0,
              width: _currentIndex == index ? 24.0 : 8.0, 
              decoration: BoxDecoration(
                color: _currentIndex == index 
                    ? const Color.fromRGBO(56, 107, 246, 1) 
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4.0),
              ),
            );
          }),
        ),
      ],
    );
  }
}