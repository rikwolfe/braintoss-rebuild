import 'package:flutter/material.dart';

class CarouselImageText extends StatelessWidget {
  final String imagePath;
  final List<TextSpan> text;
  const CarouselImageText(
      {super.key, required this.imagePath, required this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(imagePath),
          RichText(
            text: TextSpan(
              style: const TextStyle(fontSize: 20.0, color: Colors.black),
              children: text,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ));
  }
}
