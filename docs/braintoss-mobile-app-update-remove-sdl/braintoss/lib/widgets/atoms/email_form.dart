import 'package:braintoss/constants/app_constants.dart';
import 'package:braintoss/constants/colors.dart';
import 'package:braintoss/widgets/atoms/re_enter_email.dart';
import 'package:flutter/material.dart';

import 'package:braintoss/utils/functions/form_validation.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class EmailForm extends StatefulWidget {
  final void Function(String, bool) getEmailCallback;
  final void Function(String) reEnterEmail;
  final bool areEmailsMatching;
  final bool isEmailIconVisible;
  const EmailForm(
      {super.key,
      required this.getEmailCallback,
      required this.reEnterEmail,
      required this.areEmailsMatching,
      required this.isEmailIconVisible});

  @override
  EmailFormState createState() {
    return EmailFormState();
  }
}

class EmailFormState extends State<EmailForm> {
  final _formKey = GlobalKey<FormState>();

  bool isEmailValid = false;
  emailFormValidation(String email) {
    if (email.isEmpty) {
      if (isEmailValid) {
        isEmailValid = false;
        widget.getEmailCallback(email, isEmailValid);
      }
      return AppLocalizations.of(context)!.missingEmail;
    }

    if (!FormValidation.validate(email)) {
      if (isEmailValid) {
        isEmailValid = false;
        widget.getEmailCallback(email, isEmailValid);
      }
      return AppLocalizations.of(context)!.invalidEmail;
    }

    isEmailValid = true;
    widget.getEmailCallback(email, isEmailValid);

    return null;
  }

  final OutlineInputBorder formBorderPreset = const OutlineInputBorder(
      borderSide: BorderSide(color: ThemeColors.primaryYellow),
      borderRadius: BorderRadius.all(Radius.circular(15)));

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFormField(
            style: const TextStyle(color: ThemeColors.black),
            autocorrect: false,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            decoration: InputDecoration(
                suffixIcon: Visibility(
                    visible: widget.isEmailIconVisible,
                    child: widget.areEmailsMatching
                        ? Image.asset(ButtonImages.checkIcon)
                        : Image.asset(ButtonImages.checkIcon)),
                fillColor: ThemeColors.white,
                filled: true,
                enabledBorder: formBorderPreset,
                focusedBorder: formBorderPreset,
                border: formBorderPreset,
                hintStyle: const TextStyle(color: ThemeColors.black),
                hintText: AppLocalizations.of(context)!.emailPlaceholder),
            validator: (String? email) {
              return email != null ? emailFormValidation(email) : null;
            },
          ),
          ReEnterEmail(
              reEnterEmail: widget.reEnterEmail,
              areEmailsMatching: widget.areEmailsMatching,
              isEmailIconVisible: widget.isEmailIconVisible)
        ],
      ),
    );
  }
}
