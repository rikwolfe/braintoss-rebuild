import 'package:braintoss/services/interfaces/base_service.dart';

import '../../models/language_model.dart';

abstract class LanguageService extends BaseService {
  Future<List<Language>> fetchSpeechToTextLanguages();
  void setSpeechToTextLanguage(Language language);
  Language getSpeechToTextLanguage();
  Future<void> setDefaultSpeechToTextLanguage();
}
