import 'package:braintoss/models/email_model.dart';
import 'package:braintoss/widgets/atoms/edit_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../constants/colors.dart';

class DefaultEmailCell extends StatefulWidget {
  const DefaultEmailCell(
      {super.key,
      required this.defaultEmail,
      required this.editEmail,
      required this.duplicateEmail,
      required this.duplicateAlias});

  final Email defaultEmail;
  final Function(Email newEmail, Email oldEmail)? editEmail;
  final Function(String email) duplicateEmail;
  final Function(String email) duplicateAlias;

  @override
  State<DefaultEmailCell> createState() => _DefaultEmailCellState();
}

class _DefaultEmailCellState extends State<DefaultEmailCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: ThemeColors.gray, width: 0.5),
        ),
      ),
      child: ListTile(
          leading: Text(
            AppLocalizations.of(context)!.emailDefault,
            textAlign: TextAlign.start,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Theme.of(context).brightness == Brightness.light
                  ? Theme.of(context).colorScheme.onTertiary
                  : ThemeColors.white,
            ),
          ),
          title: Text(
            widget.defaultEmail.getAliasOrEmail(),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          ),
          onTap: _showDialog),
    );
  }

  _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return EditEmail(
            defaultEmail: widget.defaultEmail,
            emailCallback: widget.editEmail,
            duplicateEmail: widget.duplicateEmail,
            duplicateAlias: widget.duplicateAlias,
          );
        });
  }
}
