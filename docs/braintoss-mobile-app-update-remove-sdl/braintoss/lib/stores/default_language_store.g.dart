// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'default_language_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DefaultLanguageStore on _DefaultLanguageStore, Store {
  late final _$languagesAtom =
      Atom(name: '_DefaultLanguageStore.languages', context: context);

  @override
  List<LanguageCheckBox> get languages {
    _$languagesAtom.reportRead();
    return super.languages;
  }

  @override
  set languages(List<LanguageCheckBox> value) {
    _$languagesAtom.reportWrite(value, super.languages, () {
      super.languages = value;
    });
  }

  late final _$selectedLanguageAtom =
      Atom(name: '_DefaultLanguageStore.selectedLanguage', context: context);

  @override
  Language get selectedLanguage {
    _$selectedLanguageAtom.reportRead();
    return super.selectedLanguage;
  }

  @override
  set selectedLanguage(Language value) {
    _$selectedLanguageAtom.reportWrite(value, super.selectedLanguage, () {
      super.selectedLanguage = value;
    });
  }

  @override
  String toString() {
    return '''
languages: ${languages},
selectedLanguage: ${selectedLanguage}
    ''';
  }
}
