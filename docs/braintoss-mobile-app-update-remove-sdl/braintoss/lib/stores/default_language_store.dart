import 'package:braintoss/models/language_checkbox_model.dart';
import 'package:braintoss/models/language_model.dart';

import 'package:braintoss/services/interfaces/language_service.dart';
import 'package:braintoss/services/interfaces/navigation_service.dart';
import 'package:braintoss/services/interfaces/shared_preferences_service.dart';

import 'package:braintoss/stores/base_store.dart';

import 'package:mobx/mobx.dart';

part 'default_language_store.g.dart';

class DefaultLanguageStore = _DefaultLanguageStore with _$DefaultLanguageStore;

abstract class _DefaultLanguageStore extends BaseStore with Store {
  _DefaultLanguageStore(
      {required NavigationService navigationService,
      required this.sharedPreferencesService,
      required this.languageService})
      : super(
          navigationService: navigationService,
        ) {
    fetchSpeechToTextLanguages();
    getSpeechToTextLanguage();
  }

  final LanguageService languageService;
  final SharedPreferencesService sharedPreferencesService;

  @observable
  List<LanguageCheckBox> languages = [];

  @observable
  Language selectedLanguage = Language(
      languageName: 'English', localCode: 'en-US', characterset: 'utf-8');

  void onGoBack() {
    languageService.setSpeechToTextLanguage(selectedLanguage);
    navigationService?.goBack();
  }

  void setSelectedLanguage(Language language) {
    selectedLanguage = language;
  }

  bool isSelectedLanguage(Language language) {
    return language.languageName == selectedLanguage.languageName &&
        language.localCode == selectedLanguage.localCode;
  }

  Future<void> fetchSpeechToTextLanguages() async {
    List<Language> retreivedLanguages =
        await languageService.fetchSpeechToTextLanguages();

    languages = retreivedLanguages
        .map((lang) => LanguageCheckBox(language: lang, value: false))
        .toList();
  }

  void getSpeechToTextLanguage() {
    selectedLanguage = languageService.getSpeechToTextLanguage();
  }
}
