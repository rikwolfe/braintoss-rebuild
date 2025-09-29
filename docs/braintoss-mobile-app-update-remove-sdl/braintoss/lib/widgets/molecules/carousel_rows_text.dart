import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CarouselRowsText extends StatelessWidget {
  const CarouselRowsText({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle colorStyle =
        TextStyle(color: Theme.of(context).colorScheme.onSurface);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.plus,
                    style: const TextStyle(color: Colors.white, fontSize: 36.0),
                  ),
                  Image.asset("assets/images/General_Plus_Icon.png"),
                  Theme.of(context).colorScheme.brightness == Brightness.light
                      ? Image.asset(
                          "assets/images/Voice_Send_Button.png",
                        )
                      : Image.asset(
                          "assets/images/Photo_Note_Send_Button.png",
                        ),
                  Text(
                    AppLocalizations.of(context)!.send,
                    style: const TextStyle(color: Colors.white, fontSize: 36.0),
                  )
                ],
              ),
            ),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    AppLocalizations.of(context)!.photo,
                    style: const TextStyle(color: Colors.white, fontSize: 36.0),
                  ),
                  Image.asset(
                    "assets/images/Tutorial_Swipe_Icon.png",
                    color: Theme.of(context).colorScheme.brightness ==
                            Brightness.light
                        ? Theme.of(context).colorScheme.secondary
                        : Theme.of(context).colorScheme.onSecondary,
                  ),
                  Text(
                    AppLocalizations.of(context)!.note,
                    style: const TextStyle(color: Colors.white, fontSize: 36.0),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 24.0, right: 24.0),
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 20.0, color: Colors.black),
                  children: <TextSpan>[
                    TextSpan(
                        text: AppLocalizations.of(context)!.tutorialExtrasText1,
                        style: colorStyle),
                    TextSpan(
                      text: AppLocalizations.of(context)!.tutorialExtrasText2,
                      style: const TextStyle(fontWeight: FontWeight.bold)
                          .merge(colorStyle),
                    ),
                    TextSpan(
                        text: AppLocalizations.of(context)!.tutorialExtrasText3,
                        style: colorStyle),
                    TextSpan(
                      text: AppLocalizations.of(context)!.tutorialExtrasText4,
                      style: const TextStyle(fontWeight: FontWeight.bold)
                          .merge(colorStyle),
                    ),
                    TextSpan(
                        text: AppLocalizations.of(context)!.tutorialExtrasText5,
                        style: colorStyle),
                    TextSpan(
                      text: AppLocalizations.of(context)!.tutorialExtrasText6,
                      style: const TextStyle(fontWeight: FontWeight.bold)
                          .merge(colorStyle),
                    ),
                    TextSpan(
                        text: AppLocalizations.of(context)!.tutorialExtrasText7,
                        style: colorStyle)
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
