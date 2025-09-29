import 'package:flutter/material.dart';

import 'package:braintoss/constants/app_constants.dart';
import 'package:braintoss/constants/colors.dart';

class HistoryPreviewHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const HistoryPreviewHeader(
      {super.key,
      required this.action,
      required this.headingText,
      required this.deleteItem,
      this.actionIcon = ButtonImages.back,
      this.trashCan = HistoryIcons.trashCan});

  final String trashCan;
  final String headingText;
  final VoidCallback action;
  final void Function() deleteItem;
  final String actionIcon;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      title: Text(
        headingText,
        style: const TextStyle(
          fontSize: 40.0,
          color: ThemeColors.primaryYellowDarker,
          fontWeight: FontWeight.w700,
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
      actions: [
        GestureDetector(
          onTap: deleteItem,
          child: Image.asset(trashCan),
        )
      ],
      elevation: 0,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60.0);
}
