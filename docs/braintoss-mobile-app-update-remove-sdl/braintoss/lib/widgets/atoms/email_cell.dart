import 'package:braintoss/constants/colors.dart';
import 'package:braintoss/models/email_model.dart';
import 'package:braintoss/widgets/atoms/edit_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmailCell extends StatelessWidget {
  const EmailCell(
      {super.key,
      required this.emails,
      required this.newEmailList,
      required this.duplicateEmail,
      required this.editEmail,
      required this.duplicateAlias});

  final List<Email> emails;
  final Function(List<Email>) newEmailList;
  final Function(Email newEmail, Email oldEmail) editEmail;
  final Function(String email) duplicateEmail;
  final Function(String alias) duplicateAlias;

  @override
  Widget build(BuildContext context) {
    List<Widget> list = <Widget>[];

    for (var i = 0; i < emails.length; i++) {
      list.add(Dismissible(
          key: ValueKey<String>(emails[i].emailAddress),
          onDismissed: (DismissDirection direction) {
            emails.removeAt(i);
            newEmailList(emails);
          },
          background: Container(
              color: Theme.of(context).colorScheme.error,
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.backspace,
                  color: Theme.of(context).colorScheme.onError,
                ),
              )),
          direction: DismissDirection.endToStart,
          child: Container(
              decoration: const BoxDecoration(
                  border: Border(
                      bottom: BorderSide(color: ThemeColors.gray, width: 0.5))),
              child: ListTile(
                  leading: Text(
                    AppLocalizations.of(context)!.email,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  title: Text(
                    emails[i].getAliasOrEmail(),
                    textAlign: TextAlign.end,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).colorScheme.onSurface),
                  ),
                  onTap: () => showDialog(
                      context: context,
                      builder: (context) {
                        return EditEmail(
                          defaultEmail: emails[i],
                          emailCallback: editEmail,
                          duplicateEmail: duplicateEmail,
                          duplicateAlias: duplicateAlias,
                        );
                      })))));
    }

    return Column(
      children: list,
    );
  }
}
