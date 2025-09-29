import 'dart:ui';
import 'package:braintoss/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ActionsPopup extends StatelessWidget {
  const ActionsPopup(
      {super.key,
      required this.child,
      required this.onOutsideTap,
      this.backgroundColor = ThemeColors.white,
      this.bottomOffset = 90});
  final Widget child;
  final VoidCallback onOutsideTap;
  final Color backgroundColor;
  final double bottomOffset;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(onTap: onOutsideTap),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomOffset),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: SizedBox(
                width: MediaQuery.of(context).size.width - 2 * 10,
                child: Wrap(
                  children: [
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: Container(
                        color: backgroundColor,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: child,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
