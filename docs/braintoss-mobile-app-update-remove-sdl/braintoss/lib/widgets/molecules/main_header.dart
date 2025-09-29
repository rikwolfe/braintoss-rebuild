import 'package:braintoss/constants/app_constants.dart';
import 'package:braintoss/constants/colors.dart';
import 'package:flutter/material.dart';

class MainHeader extends StatelessWidget implements PreferredSizeWidget {
  const MainHeader(
      {super.key,
      required this.action,
      required this.headingText,
      this.actionIcon = ButtonImages.closeScreen});

  final String headingText;
  final VoidCallback action;
  final String actionIcon;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 5),
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            headingText,
            style: const TextStyle(
              fontSize: 37,
              color: ThemeColors.primaryYellowDarker,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      leading: GestureDetector(
        onTap: action,
        child: Image.asset(
          actionIcon,
          color: Theme.of(context).colorScheme.brightness == Brightness.light
              ? Theme.of(context).colorScheme.secondary
              : Theme.of(context).colorScheme.onSecondary,
        ),
      ),
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
