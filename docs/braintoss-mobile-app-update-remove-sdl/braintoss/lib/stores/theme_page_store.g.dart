// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_page_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ThemePageStore on _ThemePageStore, Store {
  late final _$selectedThemeAtom =
      Atom(name: '_ThemePageStore.selectedTheme', context: context);

  @override
  ThemeMode get selectedTheme {
    _$selectedThemeAtom.reportRead();
    return super.selectedTheme;
  }

  @override
  set selectedTheme(ThemeMode value) {
    _$selectedThemeAtom.reportWrite(value, super.selectedTheme, () {
      super.selectedTheme = value;
    });
  }

  late final _$themesAtom =
      Atom(name: '_ThemePageStore.themes', context: context);

  @override
  List<ThemeCheckBox> get themes {
    _$themesAtom.reportRead();
    return super.themes;
  }

  @override
  set themes(List<ThemeCheckBox> value) {
    _$themesAtom.reportWrite(value, super.themes, () {
      super.themes = value;
    });
  }

  late final _$_ThemePageStoreActionController =
      ActionController(name: '_ThemePageStore', context: context);

  @override
  void setSelectedOption(ThemeMode theme) {
    final _$actionInfo = _$_ThemePageStoreActionController.startAction(
        name: '_ThemePageStore.setSelectedOption');
    try {
      return super.setSelectedOption(theme);
    } finally {
      _$_ThemePageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getQuickstartOption() {
    final _$actionInfo = _$_ThemePageStoreActionController.startAction(
        name: '_ThemePageStore.getQuickstartOption');
    try {
      return super.getQuickstartOption();
    } finally {
      _$_ThemePageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedTheme: ${selectedTheme},
themes: ${themes}
    ''';
  }
}
