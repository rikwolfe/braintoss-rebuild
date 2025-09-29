import 'package:flutter/material.dart';

import 'package:braintoss/routes.dart';

import 'package:braintoss/services/impl/base_service_impl.dart';
import 'package:braintoss/services/interfaces/navigation_service.dart';
import 'package:braintoss/services/interfaces/quickstart_service.dart';
import 'package:braintoss/services/interfaces/shared_preferences_service.dart';

import 'package:braintoss/constants/app_constants.dart';

class QuickstartServiceImpl extends BaseServiceImpl
    implements QuickstartService {
  QuickstartServiceImpl(
      this._sharedPreferencesService, this._navigationService);

  final SharedPreferencesService _sharedPreferencesService;
  final NavigationService _navigationService;
  bool isQuickstartEnabled = true;

  @override
  void disableQuickstart() {
    isQuickstartEnabled = false;
  }

  @override
  String getQuickstartOption() {
    String? quickstartOption = _sharedPreferencesService
        .getString(SharedPreferencesConstants.quickstart.selectedOption);

    if (quickstartOption != null) return quickstartOption;

    String defaultQuickstartOption = SharedPreferencesConstants.quickstart.none;
    setQuickstartOption(defaultQuickstartOption);

    return defaultQuickstartOption;
  }

  @override
  void setQuickstartOption(String optionName) {
    _sharedPreferencesService.saveString(
        SharedPreferencesConstants.quickstart.selectedOption, optionName);
  }

  @override
  void triggerQuickstart() {
    String quickstartOption = getQuickstartOption();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!isQuickstartEnabled) {
        isQuickstartEnabled = true;
        return;
      }
      if (quickstartOption == SharedPreferencesConstants.quickstart.voice) {
        _navigationService.navigateWithoutAnimation(Routes.voice);
      } else if (quickstartOption ==
          SharedPreferencesConstants.quickstart.note) {
        _navigationService.navigateWithoutAnimation(Routes.note);
      } else if (quickstartOption ==
          SharedPreferencesConstants.quickstart.image) {
        _navigationService.navigateWithoutAnimation(Routes.photo);
      } else if (quickstartOption ==
          SharedPreferencesConstants.quickstart.lastUsed) {
        String? lastUsedRoute = getLastUsedRoute();
        if (lastUsedRoute != null) {
          _navigationService.navigateWithoutAnimation(lastUsedRoute);
        }
      }
    });
  }

  @override
  void setLastUsedRoute(String route) {
    _sharedPreferencesService.saveString(
        SharedPreferencesConstants.quickstart.lastUsedQuickstartRoute, route);
  }

  @override
  String? getLastUsedRoute() {
    String? lastUsedRoute = _sharedPreferencesService.getString(
        SharedPreferencesConstants.quickstart.lastUsedQuickstartRoute);

    if (lastUsedRoute != null) return lastUsedRoute;

    return lastUsedRoute;
  }

  @override
  void handleBackNavigation(String value, String route) {
    disableQuickstart();

    var quickStartValue = _sharedPreferencesService
        .getString(SharedPreferencesConstants.quickstart.selectedOption);

    if (quickStartValue == SharedPreferencesConstants.quickstart.lastUsed) {
      String? lastUsedRoute = getLastUsedRoute();
      _navigationService.navigateWithoutAnimation(lastUsedRoute!);
    } else {
      quickStartValue! == value
          ? _navigationService.navigateWithoutAnimation(route)
          : _navigationService.goHome();
    }
  }

  @override
  bool isPhotoQuickstartEnable() {
    var getQuickStartOption = getQuickstartOption();
    return getQuickStartOption == SharedPreferencesConstants.quickstart.image ||
        getQuickStartOption == SharedPreferencesConstants.quickstart.lastUsed;
  }
}
