import 'dart:ui';

import 'package:flutter/material.dart';

import '../../constants/colors.dart';

class SendPopup extends StatelessWidget {
  const SendPopup(
      {super.key,
      required this.onTapOutside,
      required this.child,
      this.bottomOffset = 130});

  final VoidCallback onTapOutside;
  final Widget child;
  final double bottomOffset;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(onTap: onTapOutside),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomOffset),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Wrap(
                  children: [
                    BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                      child: Container(
                        color: Theme.of(context).brightness == Brightness.light
                            ? ThemeColors.white.withOpacity(.70)
                            : ThemeColors.grayDark.withOpacity(.85),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                          child: child,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        )
      ],
    );
  }
}
