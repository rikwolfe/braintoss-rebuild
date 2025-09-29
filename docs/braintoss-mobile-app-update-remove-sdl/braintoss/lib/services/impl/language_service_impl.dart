import 'package:braintoss/services/interfaces/logger_service.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

import 'package:braintoss/connectors/http_connector.dart';
import 'package:braintoss/constants/api_path.dart';
import 'package:braintoss/constants/app_constants.dart';

import 'package:braintoss/services/impl/base_service_impl.dart';
import 'package:braintoss/services/interfaces/language_service.dart';
import 'package:braintoss/services/interfaces/shared_preferences_service.dart';

import '../../models/language_model.dart';
import '../interfaces/user_information_service.dart';

class LanguageServiceImpl extends BaseServiceImpl implements LanguageService {
  LanguageServiceImpl(this._httpConnector, this._userInformationService,
      this._sharedPreferencesService, this._loggerService);
  final HttpConnector _httpConnector;
  final UserInformationService _userInformationService;
  final SharedPreferencesService _sharedPreferencesService;
  final LoggerService _loggerService;

  Future<String> _constructRequest() async {
    String userIdentifier = _userInformationService.getUserId();
    return "$baseURL?q=lang&key=$apiKey&uid=$userIdentifier";
  }

  @override
  Future<List<Language>> fetchSpeechToTextLanguages() async {
    try {
      String request = await _constructRequest();
      Response<dynamic>? response = await _httpConnector.get(request);

      List<Language> languages =
          LanguageResponse.fromJson(response?.data).languages;

      return languages;
    } catch (e) {
      _loggerService.recordError(e.toString());
    }
    return [];
  }

  @override
  Language getSpeechToTextLanguage() {
    List<String>? languageStrings = _sharedPreferencesService
        .getStringList(SharedPreferencesConstants.speechToTextLanguage);

    if (languageStrings != null) {
      return Language(
          languageName: languageStrings[0],
          localCode: languageStrings[1],
          characterset: languageStrings[2]);
    }

    Language defaultLanguage = Language(
        languageName: "English", localCode: "en-US", characterset: "utf-8");

    return defaultLanguage;
  }

  @override
  void setSpeechToTextLanguage(Language language) {
    List<String> languageStrings = [
      language.languageName,
      language.localCode,
      language.characterset
    ];
    _sharedPreferencesService.saveStringList(
        SharedPreferencesConstants.speechToTextLanguage, languageStrings);

    _sharedPreferencesService.saveString(
        SharedPreferencesConstants.languageCode, language.localCode);
  }

  @override
  Future<void> setDefaultSpeechToTextLanguage() async {
    Language defaultLanguage = Language(
        languageName: "English", localCode: "en-US", characterset: "utf-8");

    final List<Locale> systemLanguages =
        WidgetsBinding.instance.platformDispatcher.locales;

    List<Language> languages = await fetchSpeechToTextLanguages();

    for (Language language in languages) {
      if (language.localCode.startsWith(systemLanguages[0].languageCode)) {
        defaultLanguage = language;
        break;
      }
    }

    setSpeechToTextLanguage(defaultLanguage);
  }
}
