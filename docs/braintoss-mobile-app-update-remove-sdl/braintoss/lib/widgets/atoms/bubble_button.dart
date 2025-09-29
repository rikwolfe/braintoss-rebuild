import 'package:flutter/material.dart';

class BubbleButton extends StatelessWidget {
  const BubbleButton(
      {super.key,
      this.onTap,
      this.onLongPress,
      this.imageColor,
      required this.diameter,
      required this.imagePath});
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double diameter;
  final String imagePath;
  final Color? imageColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: diameter,
      height: diameter,
      child: Stack(
        children: [
          Image.asset(imagePath,
              width: diameter, height: diameter, color: imageColor),
          ClipOval(
            child: Material(
              type: MaterialType.transparency,
              child: GestureDetector(
                onTap: onTap,
                onLongPress: onLongPress,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
