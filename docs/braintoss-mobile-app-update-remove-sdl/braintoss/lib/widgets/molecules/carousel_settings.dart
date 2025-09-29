import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:braintoss/widgets/atoms/email_form.dart';
import 'package:braintoss/widgets/atoms/language_selector.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class CarouselSettings extends StatefulWidget {
  final void Function(String, bool) getEmailCallback;
  final void Function(String) reEnterEmail;
  final bool areEmailsMatching;
  final bool isEmailIconVisible;

  const CarouselSettings(
      {super.key,
      required this.getEmailCallback,
      required this.reEnterEmail,
      required this.areEmailsMatching,
      required this.isEmailIconVisible});

  @override
  CarouselSettingsState createState() {
    return CarouselSettingsState();
  }
}

class CarouselSettingsState extends State<CarouselSettings> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Observer(
            builder: (_) => EmailForm(
                areEmailsMatching: widget.areEmailsMatching,
                getEmailCallback: widget.getEmailCallback,
                reEnterEmail: widget.reEnterEmail,
                isEmailIconVisible: widget.isEmailIconVisible),
          ),
          RichText(
            text: TextSpan(
                style: TextStyle(
                    fontSize: 18.0,
                    color: Theme.of(context).colorScheme.onSurface),
                children: <TextSpan>[
                  TextSpan(
                      text:
                          AppLocalizations.of(context)!.tutorialSettingsText1),
                  TextSpan(
                      text: AppLocalizations.of(context)!.tutorialSettingsText2,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(
                      text:
                          AppLocalizations.of(context)!.tutorialSettingsText3),
                ]),
            textAlign: TextAlign.center,
          ),
          const LanguageSelector(
            type: LanguageSelectorType.tutorial,
          ),
          Padding(
            padding: const EdgeInsets.all(5),
            child: RichText(
              text: TextSpan(
                  style: TextStyle(
                      fontSize: 18.0,
                      color: Theme.of(context).colorScheme.onSurface),
                  children: <TextSpan>[
                    TextSpan(
                        text: AppLocalizations.of(context)!
                            .tutorialSettingsText4),
                    TextSpan(
                        text:
                            AppLocalizations.of(context)!.tutorialSettingsText5,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: AppLocalizations.of(context)!
                            .tutorialSettingsText6),
                    TextSpan(
                        text:
                            AppLocalizations.of(context)!.tutorialSettingsText7,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    TextSpan(
                        text: AppLocalizations.of(context)!
                            .tutorialSettingsText8),
                  ]),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    ));
  }
}
