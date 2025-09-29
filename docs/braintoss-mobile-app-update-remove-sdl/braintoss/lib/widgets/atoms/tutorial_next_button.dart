import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../constants/colors.dart';

class TutorialNextButton extends StatelessWidget {
  final Function() navigationFunction;
  const TutorialNextButton({super.key, required this.navigationFunction});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () => navigationFunction(),
          child: Image.asset(
            Theme.of(context).colorScheme.brightness == Brightness.light
                ? "assets/images/Tutorial_Next_Button.png"
                : "assets/images/Tutorial_Next_Button_dark.png",
          ),
        ),
        TextButton(
          onPressed: () => navigationFunction(),
          child: Text(
            AppLocalizations.of(context)!.next,
            style: const TextStyle(
                color: ThemeColors.primaryYellowDarker, fontSize: 26.0),
          ),
        ),
      ],
    );
  }
}
