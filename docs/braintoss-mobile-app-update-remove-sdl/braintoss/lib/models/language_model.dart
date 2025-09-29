class Language {
  final String languageName;
  final String localCode;
  final String characterset;

  Language(
      {required this.languageName,
      required this.localCode,
      required this.characterset});

  factory Language.fromJson(Map<String, dynamic>? parsedJson) {
    return Language(
        languageName: parsedJson?['name'],
        localCode: parsedJson?['lid'],
        characterset: parsedJson?['characterset']);
  }
}

class LanguageResponse {
  final String? status;
  final String? error;
  final List<Language> languages;

  LanguageResponse(
      {required this.status, required this.error, required this.languages});

  factory LanguageResponse.fromJson(Map? json) {
    var list = json?['response']['languages'] as List;
    List<Language> languageList =
        list.map((i) => Language.fromJson(i)).toList();

    return LanguageResponse(
        status: json?['status'],
        error: json?['error'],
        languages: languageList);
  }
}
