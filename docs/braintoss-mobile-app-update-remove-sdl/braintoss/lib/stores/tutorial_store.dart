import 'dart:io';

import 'package:braintoss/constants/app_constants.dart';
import 'package:braintoss/models/email_model.dart';
import 'package:braintoss/services/interfaces/capture_service.dart';
import 'package:braintoss/services/interfaces/language_service.dart';
import 'package:braintoss/services/interfaces/user_information_service.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:mobx/mobx.dart';

import 'package:braintoss/stores/base_store.dart';

import 'package:braintoss/routes.dart';

import 'package:braintoss/services/interfaces/shared_preferences_service.dart';
import 'package:braintoss/services/interfaces/navigation_service.dart';
import 'package:braintoss/services/interfaces/location_service.dart';

import 'package:braintoss/widgets/molecules/carousel_image_text.dart';
import 'package:braintoss/widgets/molecules/carousel_rows_text.dart';
import 'package:braintoss/widgets/molecules/carousel_settings.dart';
import 'package:path_provider/path_provider.dart';

import '../models/capture_type.dart';
import '../models/capture_upload_model.dart';
import '../utils/functions/generators.dart';
import '../utils/functions/method_call_handlers.dart';

part 'tutorial_store.g.dart';

class TutorialStore = _TutorialStore with _$TutorialStore;

abstract class _TutorialStore extends BaseStore with Store {
  _TutorialStore(
      {required NavigationService navigationService,
      required this.sharedPreferencesService,
      required this.locationService,
      required this.languageService,
      required this.captureService,
      required this.userInformationService})
      : super(navigationService: navigationService);
  SharedPreferencesService sharedPreferencesService;
  LocationService locationService;
  LanguageService languageService;
  CaptureService captureService;
  UserInformationService userInformationService;

  late BuildContext buildContext;

  List<String> headerTitles = [];

  @observable
  String headerTitle = '';

  @observable
  int currentCarouselIndex = 0;

  @observable
  int carouselLength = 0;

  @observable
  bool isCarouselSwipeDisabled = false;

  @observable
  String email = '';

  @observable
  String reEnterEmail = '';

  @observable
  bool isEmailValid = false;

  @observable
  bool isReEnteredEmailValid = false;

  @observable
  bool areEmailsMatching = false;

  @observable
  bool isEmailIconVisible = false;

  @action
  void getEmail(String newEmail, bool isValid) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      email = newEmail;
      isEmailValid = isValid;
    });
  }

  void onGoToTutorialDone() {
    navigationService?.replaceWith(Routes.tutorialDone);
  }

  @action
  void getReEnteredEmail(String newEmail) {
    reEnterEmail = newEmail;
  }

  @action
  void setCurrentCarouselIndex(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      currentCarouselIndex = index;
      headerTitle = headerTitles[index];
    });
  }

  @action
  void setCarouselLength(int length) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      carouselLength = length;
    });
  }

  @action
  void setHeaderTitles() {
    headerTitles = [
      AppLocalizations.of(buildContext)!.tutorialHeaderWelcome,
      AppLocalizations.of(buildContext)!.tutorialHeaderWhatWeDo,
      AppLocalizations.of(buildContext)!.tutorialHeaderExtras,
      AppLocalizations.of(buildContext)!.tutorialHeaderHistory,
      AppLocalizations.of(buildContext)!.tutorialHeaderSettings,
    ];
    headerTitle = headerTitles[0];
  }

  void setContext(BuildContext buildContext) {
    this.buildContext = buildContext;
    initStore();
  }

  void initStore() {
    setDefaultSystemLanguage();
    setHeaderTitles();
  }

  bool isButtonVisible(BuildContext context) {
    return !(!isEmailValid &&
        !isReEnteredEmailValid &&
        currentCarouselIndex ==
            headerTitles
                .indexOf(AppLocalizations.of(context)!.tutorialHeaderSettings));
  }

  Future<void> handleNextButton(PageController controller) async {
    if (currentCarouselIndex ==
        headerTitles.indexOf(
            AppLocalizations.of(buildContext)!.tutorialHeaderSettings)) {
      // Handling email input validation and saving email when on the settings screen
      if (email.isEmpty && reEnterEmail.isEmpty) return;

      // Save email to user information service
      userInformationService.saveDefaultUserEmail(Email(emailAddress: email));

      // Disable carousel swipe and show email icon
      isCarouselSwipeDisabled = true;
      isEmailIconVisible = true;

      // If the entered email matches, complete the onboarding
      if (email == reEnterEmail) {
        areEmailsMatching = true;
        await _sendWelcomeNote();
        handleOnboardingDone();
      }
    } else {
      if (isFinalCarouselIndex()) {
        handleOnboardingDone();
      } else {
        // Otherwise, navigate to the next page using the PageController
        controller.nextPage(
          duration: const Duration(milliseconds: 400),
          curve: Curves.linear,
        );
      }
    }
  }


  Future<void> _sendWelcomeNote() async {
    String currentTimestamp = generateTimestamp();
    String userId = userInformationService.getUserId();
    String filename = "$currentTimestamp-$userId-text.txt";
    String fullFilePath =
        "${(await getApplicationDocumentsDirectory()).path}/$filename";
    File(fullFilePath).writeAsStringSync(welcomeMailContent);

    CaptureUploadModel capture = CaptureUploadModel(
        messageID: generateUUIDv1(),
        captureType: CaptureType.note,
        timestamp: currentTimestamp,
        filename: filename,
        fullFilePath: fullFilePath,
        email: email);

    await captureService.sendCapture(capture);
    sendUserInfoToWatch();
  }

  Future<void> handleOnboardingDone() async {
    bool isOnboardingDone = sharedPreferencesService
        .getBool(SharedPreferencesConstants.isOnboardingDone);

    isOnboardingDone == false
        ? {
            sharedPreferencesService.saveBool(
                SharedPreferencesConstants.isOnboardingDone, true),
            onGoToTutorialDone()
          }
        : onGoBack();
  }

  bool isFinalCarouselIndex() {
    return currentCarouselIndex == carouselLength - 1;
  }

  void setDefaultSystemLanguage() {
    bool isOnboardingDone = sharedPreferencesService
        .getBool(SharedPreferencesConstants.isOnboardingDone);

    if (!isOnboardingDone) languageService.setDefaultSpeechToTextLanguage();
  }

  void onGoBack() {
    navigationService?.goBack();
  }

  void onGoHome() {
    navigationService?.replaceWith(Routes.home);
  }

  List<Widget> getCarouselWidgets(BuildContext context) {
    final isOnboardingDone = sharedPreferencesService
        .getBool(SharedPreferencesConstants.isOnboardingDone);

    TextStyle colorStyle =
        TextStyle(color: Theme.of(context).colorScheme.onSurface);

    final carouselWidgets = [
      CarouselImageText(
        imagePath: Theme.of(context).colorScheme.brightness == Brightness.light
            ? 'assets/images/Tutorial_Welcome_Phone.png'
            : 'assets/images/Tutorial_Welcome_Phone_dark.png',
        text: <TextSpan>[
          TextSpan(
              text: AppLocalizations.of(context)!.tutorialWelcomeText1,
              style: colorStyle),
          TextSpan(
              text: AppLocalizations.of(context)!.tutorialWelcomeText2,
              style: const TextStyle(fontWeight: FontWeight.bold)
                  .merge(colorStyle)),
          TextSpan(
              text: AppLocalizations.of(context)!.tutorialWelcomeText3,
              style: colorStyle)
        ],
      ),
      CarouselImageText(
        imagePath: Theme.of(context).colorScheme.brightness == Brightness.light
            ? 'assets/images/walkthrough_clustered_icons.png'
            : 'assets/images/walkthrough_clustered_icons_dark.png',
        text: <TextSpan>[
          TextSpan(
              text: AppLocalizations.of(context)!.tutorialWhatWeDoText1,
              style: colorStyle),
          TextSpan(
              text: AppLocalizations.of(context)!.tutorialWhatWeDoText2,
              style: const TextStyle(fontWeight: FontWeight.bold)
                  .merge(colorStyle)),
          TextSpan(
              text: AppLocalizations.of(context)!.tutorialWhatWeDoText3,
              style: colorStyle),
          TextSpan(
              text: AppLocalizations.of(context)!.tutorialWhatWeDoText4,
              style: const TextStyle(fontWeight: FontWeight.bold)
                  .merge(colorStyle)),
          TextSpan(
              text: AppLocalizations.of(context)!.tutorialWhatWeDoText5,
              style: colorStyle)
        ],
      ),
      const CarouselRowsText(),
      CarouselImageText(
        imagePath: Theme.of(context).colorScheme.brightness == Brightness.light
            ? 'assets/images/Tutorial_History_Phone.png'
            : 'assets/images/Tutorial_History_Phone_dark.png',
        text: <TextSpan>[
          TextSpan(
              text: AppLocalizations.of(context)!.tutorialHistoryText1,
              style: colorStyle),
          TextSpan(
            text: AppLocalizations.of(context)!.tutorialHistoryText2,
            style:
                const TextStyle(fontWeight: FontWeight.bold).merge(colorStyle),
          ),
          TextSpan(
              text: AppLocalizations.of(context)!.tutorialHistoryText3,
              style: colorStyle),
          TextSpan(
            text: AppLocalizations.of(context)!.tutorialHistoryText4,
            style:
                const TextStyle(fontWeight: FontWeight.bold).merge(colorStyle),
          ),
          TextSpan(
              text: AppLocalizations.of(context)!.tutorialHistoryText5,
              style: colorStyle)
        ],
      ),
      if (!isOnboardingDone)
        CarouselSettings(
            getEmailCallback: getEmail,
            areEmailsMatching: areEmailsMatching,
            reEnterEmail: getReEnteredEmail,
            isEmailIconVisible: isEmailIconVisible),
    ];
    setCarouselLength(carouselWidgets.length);
    return carouselWidgets;
  }
}
