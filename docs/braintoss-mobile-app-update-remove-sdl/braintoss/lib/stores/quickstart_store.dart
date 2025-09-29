import 'package:braintoss/services/interfaces/shared_preferences_service.dart';
import 'package:flutter/material.dart';

import 'package:mobx/mobx.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:braintoss/stores/base_store.dart';

import 'package:braintoss/services/interfaces/navigation_service.dart';
import 'package:braintoss/services/interfaces/quickstart_service.dart';

import 'package:braintoss/models/quickstart_checkbox_model.dart';

part 'quickstart_store.g.dart';

class QuickstartStore = _QuickstartStore with _$QuickstartStore;

abstract class _QuickstartStore extends BaseStore with Store {
  _QuickstartStore(
      {required NavigationService navigationService,
      required this.quickstartService,
      required this.sharedPreferencesService})
      : super(navigationService: navigationService) {
    getQuickstartOption();
  }

  final QuickstartService quickstartService;
  final SharedPreferencesService sharedPreferencesService;

  late BuildContext buildContext;

  @observable
  String selectedQuickstartOption = '';

  @observable
  List<QuickstartCheckBox> quickstartOptions = [];

  void setContext(BuildContext scaffoldContext) {
    buildContext = scaffoldContext;
    setQuickstartOptions();
  }

  void setQuickstartOptions() {
    final quickstartOptionsList = [
      AppLocalizations.of(buildContext)!.quickstartOptionNone,
      AppLocalizations.of(buildContext)!.quickstartOptionVoice,
      AppLocalizations.of(buildContext)!.quickstartOptionNote,
      AppLocalizations.of(buildContext)!.quickstartOptionImage,
      AppLocalizations.of(buildContext)!.quickstartOptionLastUsed
    ];

    quickstartOptions = quickstartOptionsList
        .map((option) => QuickstartCheckBox(optionName: option))
        .toList();
  }

  void setSelectedOption(String optionName) {
    selectedQuickstartOption = optionName;
    quickstartService.setQuickstartOption(optionName);
  }

  bool isSelectedOption(String optionName) {
    return optionName == selectedQuickstartOption;
  }

  void getQuickstartOption() {
    selectedQuickstartOption = quickstartService.getQuickstartOption();
  }

  void onGoBack() {
    navigationService?.goBack();
  }
}
