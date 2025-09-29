import 'package:flutter/material.dart';

class ThemeCheckBox {
  final String optionName;
  final ThemeMode optionValue;
  bool? value;
  ThemeCheckBox({
    required this.optionName,
    required this.optionValue,
    this.value = false,
  });
}
