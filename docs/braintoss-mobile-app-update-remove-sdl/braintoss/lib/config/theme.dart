// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';

import '../constants/colors.dart';

ThemeData light = ThemeData(
  textSelectionTheme: const TextSelectionThemeData(
      cursorColor: ThemeColors.primaryYellow,
      selectionColor: Colors.transparent,
      selectionHandleColor: Colors.transparent),
  primaryColor: ThemeColors.primaryYellow,
  appBarTheme: const AppBarTheme(
    backgroundColor: ThemeColors.primaryYellow,
    titleTextStyle: TextStyle(
        fontSize: 34.0,
        color: ThemeColors.primaryYellowDarker,
        fontWeight: FontWeight.w700),
  ),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: ThemeColors.primaryYellow,
    onPrimary: ThemeColors.primaryYellowDarker,
    secondary: ThemeColors.secondaryBlue,
    onSecondary: ThemeColors.secondaryBlueLighter,
    onSecondaryContainer: ThemeColors.secondaryBlue,
    tertiary: ThemeColors.gray,
    onTertiary: ThemeColors.grayDarker,
    error: ThemeColors.error,
    onError: ThemeColors.white,
    background: ThemeColors.white,
    onBackground: ThemeColors.black,
    surface: ThemeColors.white,
    onSurface: ThemeColors.black,
  ).copyWith(background: ThemeColors.primaryYellow),
);

ThemeData dark = ThemeData(
  textSelectionTheme: const TextSelectionThemeData(
      cursorColor: ThemeColors.primaryYellow,
      selectionColor: Colors.transparent,
      selectionHandleColor: Colors.transparent),
  primaryColor: ThemeColors.black,
  appBarTheme: const AppBarTheme(
    backgroundColor: ThemeColors.black,
    titleTextStyle: TextStyle(
        fontSize: 34.0,
        color: ThemeColors.primaryYellowDarker,
        fontWeight: FontWeight.w700),
  ),
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: ThemeColors.primaryYellow,
    onPrimary: ThemeColors.primaryYellowDarker,
    secondary: ThemeColors.primaryYellowDarker,
    onSecondary: ThemeColors.primaryYellow,
    onSecondaryContainer: ThemeColors.primaryYellowEvenDarker,
    tertiary: ThemeColors.grayDarker,
    onTertiary: ThemeColors.gray,
    error: ThemeColors.error,
    onError: ThemeColors.white,
    background: ThemeColors.black,
    onBackground: ThemeColors.white,
    surface: ThemeColors.black,
    onSurface: ThemeColors.white,
  ).copyWith(background: ThemeColors.black),
);

const quickTransition = Duration(milliseconds: 150);
const mediumQuickTransition = Duration(milliseconds: 500);
const slowTransition = Duration(seconds: 1);
const verySlowTransition = Duration(seconds: 2);

class TextStyles {
  static TextStyle actionPopupButtonLabel = const TextStyle(
    fontFamily: "Inter",
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );
  static TextStyle menuButtonLabel = const TextStyle(
    fontSize: 30.0,
    fontFamily: "Inter",
    fontWeight: FontWeight.w200,
  );
  static TextStyle emailsLabel = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );
  static TextStyle noteTextField = const TextStyle(
    fontSize: 18.0,
  );
}

class Dimensions {
  static const voiceMicrophoneAndCircleSize = 300.0;
  static const voiceRecordTimeLimitInSeconds = 30;
}
