import 'package:braintoss/services/interfaces/base_service.dart';
import 'package:flutter/material.dart';

abstract class ThemeService extends BaseService {
  void saveTheme(ThemeMode theme);
  ThemeMode loadTheme();
}
