import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class NavigationActionCell extends StatelessWidget {
  const NavigationActionCell(
      {super.key, required this.displayName, required this.action});

  final String displayName;
  final VoidCallback action;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(color: ThemeColors.gray, width: 0.5))),
        child: ListTile(
            title: Text(displayName,
                style:
                    TextStyle(color: Theme.of(context).colorScheme.onSurface)),
            trailing: Icon(
              Icons.arrow_right,
              color: Theme.of(context).colorScheme.onSurface,
            ),
            enabled: true,
            onTap: action));
  }
}
