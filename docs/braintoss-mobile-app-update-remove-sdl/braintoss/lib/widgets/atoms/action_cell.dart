import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/colors.dart';

class ActionCell extends StatelessWidget {
  const ActionCell({super.key, required this.action, this.textStyle});

  final VoidCallback action;
  final TextStyle? textStyle;
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(color: ThemeColors.gray, width: 0.5))),
        child: ListTile(
            title: Text(
              AppLocalizations.of(context)!.notReceivingEmails,
              style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700)
                  .merge(textStyle),
            ),
            onTap: action));
  }
}
