import 'package:braintoss/services/interfaces/theme_service.dart';
import 'package:braintoss/stores/theme_store.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:braintoss/stores/base_store.dart';
import 'package:provider/provider.dart';
import '../models/theme_checkbox_model.dart';

part 'theme_page_store.g.dart';

class ThemePageStore = _ThemePageStore with _$ThemePageStore;

abstract class _ThemePageStore extends BaseStore with Store {
  _ThemePageStore(
      {required this.themeService, required super.navigationService}) {
    getQuickstartOption();
  }
  late BuildContext buildContext;
  final ThemeService themeService;

  @observable
  ThemeMode selectedTheme = ThemeMode.system;

  @observable
  List<ThemeCheckBox> themes = [];

  void setContext(BuildContext scaffoldContext) {
    buildContext = scaffoldContext;
    setThemeList();
    getQuickstartOption();
  }

  void setThemeList() {
    themes = [
      ThemeCheckBox(
          optionName: AppLocalizations.of(buildContext)!.themeAuto,
          optionValue: ThemeMode.system),
      ThemeCheckBox(
          optionName: AppLocalizations.of(buildContext)!.themeLight,
          optionValue: ThemeMode.light),
      ThemeCheckBox(
          optionName: AppLocalizations.of(buildContext)!.themeDark,
          optionValue: ThemeMode.dark),
    ];
  }

  @action
  void setSelectedOption(ThemeMode theme) {
    final themeStore = Provider.of<ThemeStore>(buildContext, listen: false);
    selectedTheme = theme;
    themeStore.setTheme(theme);
  }

  bool isSelectedOption(ThemeMode theme) {
    return theme == selectedTheme;
  }

  @action
  void getQuickstartOption() {
    selectedTheme = themeService.loadTheme();
  }

  void onGoBack() {
    navigationService?.goBack();
  }
}
