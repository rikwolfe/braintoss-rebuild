import 'package:braintoss/config/theme.dart';
import 'package:braintoss/constants/app_constants.dart';
import 'package:braintoss/pages/stateful_page.dart';
import 'package:braintoss/stores/home_store.dart';
import 'package:braintoss/widgets/atoms/labeled_icon_button.dart';
import 'package:braintoss/widgets/molecules/home_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class HomePage extends StatefulPage<HomeStore> {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends StatefulPageState<HomeStore> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) => Scaffold(
        body: _buildPageContent(context),
        appBar: HomeHeader(
          onHistory: store.onGoToHistory,
          onSettings: store.onGoToSettings,
          errorCaptured: store.errorCaptured,
          getFailedCaptures: store.getFailedCaptures,
        ),
        // ignore: deprecated_member_use
        backgroundColor: Theme.of(context).colorScheme.background,
      ),
    );
  }

  Widget _buildPageContent(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        Theme.of(context).brightness == Brightness.light
            ? SystemUiOverlayStyle.dark
            : SystemUiOverlayStyle.light);
    store.getFailedCaptures();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          flex: 25,
          child: _voiceButton(context),
        ),
        Expanded(
          flex: 15,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 45.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              children: [
                _photoButton(context),
                _noteButton(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  AspectRatio _voiceButton(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: FittedBox(
        child: Padding(
          padding: const EdgeInsets.all(70.0),
          child: LabeledIconButton(
            icon: ButtonImages.microphone,
            iconSize: 130.0,
            iconColor:
                Theme.of(context).colorScheme.brightness == Brightness.light
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.onSecondary,
            label: AppLocalizations.of(context)!.voice,
            onTap: store.onGoToVoice,
            labelStyle: TextStyles.menuButtonLabel.merge(
              TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ),
      ),
    );
  }

  Expanded _noteButton(BuildContext context) {
    return Expanded(
      child: FittedBox(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: LabeledIconButton(
            icon: ButtonImages.note,
            iconSize: 60.0,
            iconColor:
                Theme.of(context).colorScheme.brightness == Brightness.light
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.onSecondary,
            label: AppLocalizations.of(context)!.note,
            onTap: store.onGoToNote,
            labelStyle: TextStyles.menuButtonLabel.merge(
              TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 25.0),
            ),
          ),
        ),
      ),
    );
  }

  Expanded _photoButton(BuildContext context) {
    return Expanded(
      child: FittedBox(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: LabeledIconButton(
            icon: ButtonImages.photo,
            iconSize: 60.0,
            iconColor:
                Theme.of(context).colorScheme.brightness == Brightness.light
                    ? Theme.of(context).colorScheme.secondary
                    : Theme.of(context).colorScheme.onSecondary,
            label: AppLocalizations.of(context)!.photo,
            onTap: store.onGoToPhoto,
            labelStyle: TextStyles.menuButtonLabel.merge(
              TextStyle(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontSize: 25.0),
            ),
          ),
        ),
      ),
    );
  }
}
