import 'package:braintoss/constants/app_constants.dart';
import 'package:braintoss/services/interfaces/shared_preferences_service.dart';
import 'package:braintoss/services/interfaces/theme_service.dart';
import 'package:flutter/material.dart';

class ThemeServiceImpl implements ThemeService {
  ThemeServiceImpl(this._sharedPreferencesService) {
    loadTheme();
  }
  final SharedPreferencesService _sharedPreferencesService;

  @override
  void saveTheme(ThemeMode theme) {
    switch (theme) {
      case ThemeMode.system:
        _sharedPreferencesService.saveString(
            SharedPreferencesConstants.theme, ThemeNames.system);
        break;
      case ThemeMode.light:
        _sharedPreferencesService.saveString(
            SharedPreferencesConstants.theme, ThemeNames.light);
        break;
      case ThemeMode.dark:
        _sharedPreferencesService.saveString(
            SharedPreferencesConstants.theme, ThemeNames.dark);
        break;
    }
  }

  @override
  ThemeMode loadTheme() {
    String? savedTheme =
        _sharedPreferencesService.getString(SharedPreferencesConstants.theme);
    if (savedTheme == null) {
      return ThemeMode.system;
    }
    switch (savedTheme) {
      case ThemeNames.system:
        return ThemeMode.system;
      case ThemeNames.light:
        return ThemeMode.light;
      case ThemeNames.dark:
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }
}
