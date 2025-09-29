// ignore_for_file: deprecated_member_use

import 'package:braintoss/constants/colors.dart';
import 'package:braintoss/routes.dart';
import 'package:braintoss/widgets/atoms/tutorial_next_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TutorialDonePage extends StatelessWidget {
  const TutorialDonePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Theme.of(context).colorScheme.background,
              elevation: 0,
              centerTitle: true,
              title: Text(
                AppLocalizations.of(context)!.tutorialHeaderDone,
                style: const TextStyle(
                  fontSize: 40,
                  color: ThemeColors.primaryYellowDarker,
                  fontWeight: FontWeight.w700,
                ),
              )),
          backgroundColor: Theme.of(context).colorScheme.background,
          body: _pageContent(context),
        ));
  }

  Widget _pageContent(BuildContext context) {
    TextStyle colorStyle =
        TextStyle(color: Theme.of(context).colorScheme.onSurface);
    return Center(
        child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image.asset(
              Theme.of(context).colorScheme.brightness == Brightness.light
                  ? 'assets/images/Tutorial_Done_Phone.png'
                  : 'assets/images/Tutorial_Done_Phone_dark.png'),
          RichText(
            text: TextSpan(
                style: const TextStyle(fontSize: 20.0).merge(colorStyle),
                children: <TextSpan>[
                  TextSpan(
                      text: AppLocalizations.of(context)!.tutorialDoneText1,
                      style: colorStyle),
                  TextSpan(
                      text: AppLocalizations.of(context)!.tutorialDoneText2,
                      style: const TextStyle(fontWeight: FontWeight.bold)
                          .merge(colorStyle)),
                  TextSpan(
                      text: AppLocalizations.of(context)!.tutorialDoneText3,
                      style: colorStyle),
                ]),
            textAlign: TextAlign.center,
          ),
          TutorialNextButton(
              navigationFunction: () => Navigator.of(context)
                  .pushNamedAndRemoveUntil(Routes.navigator, (route) => false))
        ],
      ),
    ));
  }
}
