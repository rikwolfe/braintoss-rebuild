import 'package:flutter/material.dart';

class LabeledIconButton extends StatelessWidget {
  const LabeledIconButton({
    super.key,
    required this.label,
    required this.icon,
    required this.iconSize,
    this.iconColor,
    required this.onTap,
    this.labelStyle,
    this.separation,
  });
  final String label;
  final String icon;
  final Color? iconColor;
  final double iconSize;
  final void Function() onTap;
  final TextStyle? labelStyle;
  final double? separation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              icon,
              width: iconSize,
              height: iconSize,
              color: iconColor,
            ),
            Padding(
              padding: EdgeInsets.only(top: separation ?? 16.0),
              child: Text(
                label,
                style: labelStyle,
              ),
            )
          ],
        ),
      ),
    );
  }
}
