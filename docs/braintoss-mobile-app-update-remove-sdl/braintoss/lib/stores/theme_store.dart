import 'package:braintoss/services/interfaces/quickstart_service.dart';
import 'package:braintoss/services/interfaces/theme_service.dart';
import 'package:braintoss/stores/base_store.dart';
import 'package:flutter/material.dart';

import 'package:mobx/mobx.dart';

part 'theme_store.g.dart';

class ThemeStore = _ThemeStore with _$ThemeStore;

abstract class _ThemeStore extends BaseStore with Store {
  _ThemeStore(this._themeService, this._quickstartService) {
    currentTheme = _themeService.loadTheme();
  }

  final ThemeService _themeService;
  final QuickstartService _quickstartService;

  @observable
  ThemeMode currentTheme = ThemeMode.system;

  @action
  void setTheme(ThemeMode theme) {
    _quickstartService.disableQuickstart();
    currentTheme = theme;
    _themeService.saveTheme(theme);
  }
}
