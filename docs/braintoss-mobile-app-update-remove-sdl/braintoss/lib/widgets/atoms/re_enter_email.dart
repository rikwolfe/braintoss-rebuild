import 'package:braintoss/constants/app_constants.dart';
import 'package:braintoss/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ReEnterEmail extends StatefulWidget {
  final void Function(String) reEnterEmail;
  final bool areEmailsMatching;
  final bool isEmailIconVisible;
  const ReEnterEmail(
      {super.key,
      required this.reEnterEmail,
      required this.areEmailsMatching,
      required this.isEmailIconVisible});

  @override
  State<ReEnterEmail> createState() => _ReEnterEmailState();
}

class _ReEnterEmailState extends State<ReEnterEmail> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
          Container(
            margin: const EdgeInsets.only(top: 15),
            child: TextFormField(
              style: const TextStyle(color: ThemeColors.black),
              autocorrect: false,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              decoration: InputDecoration(
                  suffixIcon: Visibility(
                      visible: widget.isEmailIconVisible,
                      child: widget.areEmailsMatching
                          ? Image.asset(HistoryIcons.check)
                          : Image.asset(HistoryIcons.failed)),
                  fillColor: ThemeColors.white,
                  filled: true,
                  enabledBorder: formBorderPreset,
                  focusedBorder: formBorderPreset,
                  border: formBorderPreset,
                  hintStyle: const TextStyle(color: ThemeColors.black),
                  hintText: AppLocalizations.of(context)!.reEnterEmail),
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return AppLocalizations.of(context)!.enterAnEmail;
                } else {
                  widget.reEnterEmail(value);
                }
                return null;
              },
            ),
          )
        ],
      ),
    );
  }
}
