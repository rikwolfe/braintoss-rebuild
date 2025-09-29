import 'package:braintoss/inject/injectservices_extension.dart';
import 'package:braintoss/services/interfaces/navigation_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:braintoss/services/impl/shared_preferences_service_impl.dart';
import 'package:braintoss/constants/app_constants.dart';
import '../../constants/colors.dart';
import 'package:braintoss/routes.dart';

enum LanguageSelectorType { tutorial, settings }

class LanguageSelector extends StatefulWidget {
  final LanguageSelectorType type;

  const LanguageSelector({
    super.key,
    required this.type,
  });

  @override
  State<LanguageSelector> createState() => _LanguagesWidgetState();
}

class _LanguagesWidgetState extends State<LanguageSelector> {
  SharedPreferencesServiceImpl sharedPreferences =
      SharedPreferencesServiceImpl();

  String selectedLanguage = '';
  NavigationService navigationService =
      ModuleContainer.shared.getService<NavigationService>();

  navigateToLanguagesPage(BuildContext context) async {
    await navigationService.navigateWithCallback(
        Routes.defaultLanguage, updateSelectedLanguage);
  }

  void updateSelectedLanguage() {
    setState(() {
      selectedLanguage = getSpeechToTextLanguage();
    });
  }

  String getSpeechToTextLanguage() {
    List<String>? languageStrings = sharedPreferences
        .getStringList(SharedPreferencesConstants.speechToTextLanguage);

    if (languageStrings != null) {
      return languageStrings[0];
    }
    return 'English';
  }

  @override
  Widget build(BuildContext context) {
    selectedLanguage = getSpeechToTextLanguage();
    return GestureDetector(
      onTap: () => navigateToLanguagesPage(context),
      child: widget.type == LanguageSelectorType.tutorial
          ? _tutorialLanguageSelector(context)
          : _settingsLanguageSelector(context),
    );
  }

  Widget _settingsLanguageSelector(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(color: ThemeColors.gray, width: 0.5))),
        child: Row(
          children: [
            Expanded(
                flex: 6,
                child: ListTile(
                    title: Text(
                        AppLocalizations.of(context)!.languageSelectorSettings,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface)),
                    onTap: null)),
            Text(
              selectedLanguage,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.arrow_right),
            )
          ],
        ));
  }

  Widget _tutorialLanguageSelector(BuildContext context) {
    return Container(
        height: 60,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15), color: ThemeColors.white),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Row(
              children: [
                Expanded(
                    flex: 6,
                    child: ListTile(
                        title: Text(
                            AppLocalizations.of(context)!
                                .languageSelectorTutorial,
                            style: const TextStyle(color: ThemeColors.black)),
                        onTap: null)),
                Text(
                  selectedLanguage,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 20),
                  child: Icon(Icons.arrow_right, color: ThemeColors.gray),
                )
              ],
            )));
  }
}
