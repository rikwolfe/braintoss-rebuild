import 'package:braintoss/models/email_model.dart';
import 'package:braintoss/widgets/atoms/edit_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants/colors.dart';

class AddEmailCell extends StatefulWidget {
  const AddEmailCell({
    super.key,
    required this.emailCallback,
    required this.duplicateEmail,
    required this.duplicateAlias,
  });

  final Function(Email newEmail, Email oldEmail)? emailCallback;
  final Function(String email) duplicateEmail;
  final Function(String alias) duplicateAlias;

  @override
  State<AddEmailCell> createState() => _AddEmailWidgetState();
}

class _AddEmailWidgetState extends State<AddEmailCell> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: ThemeColors.gray, width: 0.5),
          ),
        ),
        child: ListTile(
            title: Text(
              AppLocalizations.of(context)!.addEmailAdress,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
            ),
            leading: Icon(
              Icons.add_circle,
              color:
                  Theme.of(context).colorScheme.brightness == Brightness.light
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.onSecondary,
            ),
            onTap: _showDialog));
  }

  _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return EditEmail(
            defaultEmail: Email(emailAddress: ""),
            emailCallback: widget.emailCallback,
            duplicateEmail: widget.duplicateEmail,
            duplicateAlias: widget.duplicateAlias,
          );
        });
  }
}
