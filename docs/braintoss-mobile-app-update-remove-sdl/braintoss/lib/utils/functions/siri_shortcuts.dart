import 'package:braintoss/constants/app_constants.dart';

import 'package:braintoss/routes.dart';
import 'package:braintoss/services/impl/logger_service_impl.dart';
import 'package:braintoss/services/impl/navigation_service_impl.dart';
import 'package:braintoss/services/interfaces/logger_service.dart';

import 'package:braintoss/services/interfaces/navigation_service.dart';

import 'package:flutter/services.dart';

class MethodCalls {
  static const String navigateWithSiri = "NavigateWithSiri";
}

class SiriShortcuts {
  SiriShortcuts();

  NavigationService navigationService = NavigationServiceImpl();
  LoggerService loggerService = LoggerServiceImpl();

  MethodChannel siriShortcuts = const MethodChannel(methodChannelName);

  void setupSiriShortcuts() {
    siriShortcuts.setMethodCallHandler((MethodCall call) async {
      switch (call.method) {
        case MethodCalls.navigateWithSiri:
          try {
            final String route = call.arguments as String;
            switch (route) {
              case "Note":
                navigationService.navigateTo(Routes.note);
                break;
              case "Voice":
                navigationService.navigateTo(Routes.voice);
                break;
              case "Photo":
                navigationService.navigateTo(Routes.photo);
                break;
            }
          } catch (error) {
            loggerService.recordError(error.toString());
          }
      }
    });
  }
}
