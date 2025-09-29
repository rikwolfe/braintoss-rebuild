import 'package:braintoss/utils/functions/form_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmailDialog extends StatefulWidget {
  const EmailDialog({
    super.key,
    required this.hintText,
    required this.emailCallback,
    required this.duplicateEmail,
  });

  final Function(String email) emailCallback;
  final Function(String email) duplicateEmail;
  final String hintText;

  @override
  State<EmailDialog> createState() => _EmailDialogState();
}

class _EmailDialogState extends State<EmailDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: Row(
        children: <Widget>[
          Expanded(
              child: Form(
                  key: _formKey,
                  child: TextFormField(
                    autocorrect: false,
                    controller: myController,
                    autofocus: true,
                    decoration: InputDecoration(
                      labelText: widget.hintText,
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.enterAnEmail;
                      } else if (!FormValidation.validate(value)) {
                        return AppLocalizations.of(context)!.enterValidEmail;
                      } else if (widget.duplicateEmail(value)) {
                        return AppLocalizations.of(context)!.duplicateEmail;
                      }
                      return null;
                    },
                  )))
        ],
      ),
      actions: <Widget>[
        TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(color: Theme.of(context).colorScheme.secondary),
            )),
        TextButton(
          child: Text(
            AppLocalizations.of(context)!.save,
            style: TextStyle(color: Theme.of(context).colorScheme.secondary),
          ),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              submitEmail(myController.text);
            }
          },
        ),
      ],
    );
  }

  void submitEmail(String email) {
    final form = _formKey.currentState;
    if (form!.validate()) {
      widget.emailCallback(email);
      form.save();
      Navigator.pop(context);
    }
  }
}
