import 'package:braintoss/models/email_model.dart';
import 'package:braintoss/services/interfaces/navigation_service.dart';
import 'package:braintoss/services/interfaces/quickstart_service.dart';
import 'package:braintoss/services/interfaces/share_service.dart';
import 'package:braintoss/services/interfaces/shared_preferences_service.dart';
import 'package:braintoss/services/interfaces/user_information_service.dart';

import 'package:braintoss/stores/base_store.dart';

import 'package:braintoss/constants/app_constants.dart';

import 'package:mobx/mobx.dart';

import 'package:url_launcher/url_launcher.dart';

import '../routes.dart';
import '../utils/functions/method_call_handlers.dart';

part 'settings_store.g.dart';

class SettingsStore = _SettingsStore with _$SettingsStore;

abstract class _SettingsStore extends BaseStore with Store {
  _SettingsStore({
    required NavigationService navigationService,
    required this.sharedPreferencesService,
    required this.shareService,
    required this.userInformationService,
    required this.quickstartService,
  }) : super(navigationService: navigationService) {
    isSoundSwitched = getSwitchValue(SharedPreferencesConstants.sound);
    isVibrationSwitched = getSwitchValue(SharedPreferencesConstants.vibration);
    isProximitySwitched = getSwitchValue(SharedPreferencesConstants.proximity);
    sendUserInfoToWatch();
  }

  ShareService shareService;
  SharedPreferencesService sharedPreferencesService;
  UserInformationService userInformationService;
  QuickstartService quickstartService;

  @observable
  List<Email> emails = ObservableList.of([]);

  @observable
  late Email defaultEmail = userInformationService.getDefaultUserEmail();

  @observable
  bool isSoundSwitched = false;
  @observable
  bool isVibrationSwitched = false;
  @observable
  bool isProximitySwitched = false;

  @action
  void handleSwitchToggle(String switchText, bool value) {
    switch (switchText) {
      case SharedPreferencesConstants.sound:
        {
          isSoundSwitched = !isSoundSwitched;
          sharedPreferencesService.saveBool(
              SharedPreferencesConstants.sound, isSoundSwitched);
          break;
        }
      case SharedPreferencesConstants.vibration:
        {
          isVibrationSwitched = !isVibrationSwitched;
          sharedPreferencesService.saveBool(
              SharedPreferencesConstants.vibration, isVibrationSwitched);
          break;
        }
      case SharedPreferencesConstants.proximity:
        {
          isProximitySwitched = !isProximitySwitched;
          sharedPreferencesService.saveBool(
              SharedPreferencesConstants.proximity, isProximitySwitched);
          break;
        }
    }
  }

  bool getSwitchValue(String switchText) {
    return sharedPreferencesService.getBool(switchText);
  }

  @action
  void addEmail(Email email) {
    emails.add(email);
    userInformationService.saveUserEmails(emails);

    sendUserInfoToWatch();
    getEmailList();
  }

  @action
  void editEmail(Email newMail) {
    defaultEmail = newMail;
    userInformationService.saveDefaultUserEmail(newMail);
  }

  @action
  void editCellEmail(Email newMail, Email oldMail) {
    duplicateEmail(oldMail.emailAddress)
        ? emails[emails.indexWhere(
            (v) => v.emailAddress == oldMail.emailAddress)] = newMail
        : emails;

    saveEmailList(emails);
    getEmailList();
  }

  void getEmail() {
    defaultEmail = userInformationService.getDefaultUserEmail();
  }

  @action
  void getEmailList() {
    emails = userInformationService.getUserEmails();
    emails.removeWhere(
        (element) => element.emailAddress == defaultEmail.emailAddress);
  }

  @action
  void saveEmailList(List<Email> emails) {
    userInformationService.saveUserEmails(emails);
    sendUserInfoToWatch();
    getEmailList();
  }

  @action
  bool duplicateEmail(String newEmail) {
    if (defaultEmail.emailAddress == newEmail) return true;

    for (int i = 0; i < emails.length; i++) {
      if (emails[i].emailAddress == newEmail) return true;
    }

    return false;
  }

  @action
  bool duplicateAlias(String alias) {
    if (alias == "") return false;

    if (defaultEmail.alias == alias) return true;

    for (int i = 0; i < emails.length; i++) {
      if (emails[i].alias == alias) return true;
    }

    return false;
  }

  void openURL(url) async {
    if (!await launchUrl(Uri.parse(url))) throw 'Could not launch $url';
  }

  void onGoBack() {
    quickstartService.disableQuickstart();
    navigationService?.goBack();
  }

  void onGoToAbout() {
    navigationService?.navigateTo(Routes.about);
  }

  void onGoToQuickstart() {
    navigationService?.navigateTo(Routes.quickstart);
  }

  void onGoToHistory() {
    navigationService?.navigateTo(Routes.history);
  }

  void onGoToTutorial() {
    navigationService?.navigateTo(Routes.tutorial);
  }

  void onGoToTheme() {
    navigationService?.navigateTo(Routes.theme);
  }

  void handleShareAction(String text) {
    shareService.shareText(text);
  }
}
