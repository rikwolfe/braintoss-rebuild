import 'package:braintoss/constants/app_constants.dart';
import 'package:braintoss/constants/colors.dart';
import 'package:braintoss/models/email_model.dart';
import 'package:braintoss/utils/functions/form_validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EditEmail extends StatefulWidget {
  const EditEmail(
      {super.key,
      required this.defaultEmail,
      required this.emailCallback,
      required this.duplicateEmail,
      required this.duplicateAlias});

  final Function(Email newEmail, Email oldEmail)? emailCallback;
  final Function(String email) duplicateEmail;
  final Function(String alias) duplicateAlias;

  final Email defaultEmail;

  @override
  State<EditEmail> createState() => _EditEmailState();
}

class _EditEmailState extends State<EditEmail> {
  final GlobalKey<FormState> _emailFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _aliasFormKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final emailController =
        TextEditingController(text: widget.defaultEmail.emailAddress);
    final aliasController =
        TextEditingController(text: widget.defaultEmail.alias);
    return AlertDialog(
      contentPadding: const EdgeInsets.all(16.0),
      content: SizedBox(
        height: 170,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [closeButton()],
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Form(
                      key: _emailFormKey,
                      child: TextFormField(
                        autocorrect: false,
                        controller: emailController,
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.addOrEditEmail,
                          labelStyle: TextStyle(
                            color: Theme.of(context).colorScheme.brightness ==
                                    Brightness.light
                                ? ThemeColors.secondaryBlueLighter
                                : ThemeColors.primaryYellow,
                          ),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.brightness ==
                                            Brightness.light
                                        ? ThemeColors.secondaryBlueLighter
                                        : ThemeColors.primaryYellow),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.brightness ==
                                            Brightness.light
                                        ? ThemeColors.secondaryBlueLighter
                                        : ThemeColors.primaryYellow),
                          ),
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)!.enterAnEmail;
                          } else if (!FormValidation.validate(value)) {
                            return AppLocalizations.of(context)!
                                .enterValidEmail;
                          } else if (widget.duplicateEmail(value) &&
                              value != widget.defaultEmail.emailAddress) {
                            return AppLocalizations.of(context)!.duplicateEmail;
                          }
                          return null;
                        },
                      )))
            ],
          ),
          Row(
            children: <Widget>[
              Expanded(
                  child: Form(
                      key: _aliasFormKey,
                      child: TextFormField(
                        autocorrect: false,
                        controller: aliasController,
                        decoration: InputDecoration(
                          labelText:
                              AppLocalizations.of(context)!.addOrEditAlias,
                          labelStyle: TextStyle(
                              color: Theme.of(context).colorScheme.brightness ==
                                      Brightness.light
                                  ? ThemeColors.secondaryBlueLighter
                                  : ThemeColors.primaryYellow),
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.brightness ==
                                            Brightness.light
                                        ? ThemeColors.secondaryBlueLighter
                                        : ThemeColors.primaryYellow),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(
                                color:
                                    Theme.of(context).colorScheme.brightness ==
                                            Brightness.light
                                        ? ThemeColors.secondaryBlueLighter
                                        : ThemeColors.primaryYellow),
                          ),
                        ),
                        validator: (String? value) {
                          if (widget.duplicateAlias(value!) &&
                              value != widget.defaultEmail.alias) {
                            return AppLocalizations.of(context)!.duplicateAlias;
                          }
                          return null;
                        },
                      )))
            ],
          ),
        ]),
      ),
      actions: <Widget>[
        Center(
            child: RotatedBox(
          quarterTurns: 2,
          child: GestureDetector(
              onTap: () =>
                  submitForm(emailController.text, aliasController.text),
              child: Image.asset(
                ButtonImages.back,
                width: 35,
                height: 35,
                color:
                    Theme.of(context).colorScheme.brightness == Brightness.light
                        ? ThemeColors.secondaryBlueLighter
                        : ThemeColors.primaryYellow,
              )),
        )),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget closeButton() {
    return GestureDetector(
        onTap: closePopup,
        child: Image.asset(ButtonImages.closePopup,
            width: 25,
            height: 25,
            color: Theme.of(context).colorScheme.brightness == Brightness.light
                ? ThemeColors.secondaryBlueLighter
                : ThemeColors.primaryYellow));
  }

  void closePopup() {
    Navigator.pop(context);
  }

  void submitForm(String email, String alias) {
    final emailForm = _emailFormKey.currentState;
    final aliasForm = _aliasFormKey.currentState;
    if (!emailForm!.validate() || !aliasForm!.validate()) {
      emailForm.save();
      aliasForm!.save();
      return;
    }

    Email newEmail = Email(emailAddress: email, alias: alias);

    widget.emailCallback!(newEmail, widget.defaultEmail);
    Navigator.pop(context);
  }
}
