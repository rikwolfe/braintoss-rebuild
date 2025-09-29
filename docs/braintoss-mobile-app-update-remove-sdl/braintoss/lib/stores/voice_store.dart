import 'package:braintoss/models/email_model.dart';
import 'package:braintoss/utils/functions/file_path_helper.dart';
import 'package:flutter/material.dart';
import 'package:record/record.dart' as rec;
import 'dart:async';
import 'dart:io';
import 'package:mobx/mobx.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:proximity_sensor/proximity_sensor.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:braintoss/stores/base_store.dart';
import 'package:braintoss/services/interfaces/capture_service.dart';
import 'package:braintoss/services/interfaces/permission_handler_service.dart';
import 'package:braintoss/services/interfaces/shared_preferences_service.dart';
import 'package:braintoss/services/interfaces/navigation_service.dart';
import 'package:braintoss/services/interfaces/user_information_service.dart';
import 'package:braintoss/services/interfaces/quickstart_service.dart';
import 'package:braintoss/config/theme.dart';
import 'package:braintoss/constants/app_constants.dart';
import 'package:braintoss/routes.dart';
import 'package:vibration/vibration.dart';

import '../models/capture_type.dart';
import '../models/capture_upload_model.dart';
import '../utils/functions/generators.dart';

part 'voice_store.g.dart';

class VoiceStore = _VoiceStore with _$VoiceStore;

abstract class _VoiceStore extends BaseStore with Store {
  _VoiceStore({
    required NavigationService navigationService,
    required this.userInformationService,
    required this.quickstartService,
    required this.captureService,
    required this.permissionHandlerService,
    required this.sharedPreferencesService,
  }) : super(navigationService: navigationService) {
    quickstartService.setLastUsedRoute(Routes.voice);
  }

  final CaptureService captureService;
  final UserInformationService userInformationService;
  final QuickstartService quickstartService;
  final PermissionHandlerService permissionHandlerService;
  final SharedPreferencesService sharedPreferencesService;
  final rec.AudioRecorder _voiceRecord = rec.AudioRecorder();

  late BuildContext buildContext;
  late AnimationController progressBarController;

  late String filename;
  late String filePath;

  late StreamSubscription<dynamic> _streamSubscription;

  bool isVibrationOn = false;
  bool disableButtons = false;

  bool isCaptureSent = false;

  @observable
  late Email selectedEmail = userInformationService.getDefaultUserEmail();

  @observable
  late List<Email> emails = userInformationService.getUserEmails();

  @observable
  bool emailsPopupVisible = false;
  @observable
  bool emailsPopupInteractable = false;

  @observable
  bool successOverlayVisible = false;
  @observable
  bool successIconVisible = false;

  @observable
  bool longPressSendListVisible = false;
  @observable
  bool longPressSendListInteractable = false;

  @observable
  bool isProximityNear = false;
  @observable
  bool isProximityOn = false;

  @action
  void closeEmailsPopup() {
    emailsPopupVisible = false;
  }

  @action
  void openEmailsPopup() {
    emailsPopupVisible = true;
    emailsPopupInteractable = true;
  }

  @action
  void onActionPopupAnimationEnd() {
    if (emailsPopupVisible == false) {
      emailsPopupInteractable = false;
    }
  }

  @action
  void onLongPressSendAnimationEnd() {
    if (longPressSendListVisible == false) {
      longPressSendListInteractable = false;
    }
  }

  @action
  void onEmailSelectionChangeFromPopup(dynamic selection) {
    selectedEmail = selection;
    Future.delayed(mediumQuickTransition, () => closeEmailsPopup());
  }

  @action
  void onEmailSelectionFromLongPressSend(dynamic selection) {
    selectedEmail = selection;
    closeLongPressSendList();
    sendVoiceMessage();
  }

  @action
  void showSuccessIcon() {
    successIconVisible = true;
  }

  @action
  void onSuccessIconAnimationEnd() {
    Future.delayed(slowTransition).then(
          (_) => captureDidSend(),
    );
  }

  void captureDidSend() {
    quickstartService.handleBackNavigation(
        SharedPreferencesConstants.quickstart.voice, Routes.voice);
  }

  @action
  void openLongPressSendList() {
    longPressSendListVisible = true;
    longPressSendListInteractable = true;
  }

  @action
  void closeLongPressSendList() {
    longPressSendListVisible = false;
  }

  @action
  Future<void> listenSensor() async {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (foundation.kDebugMode) {
        FlutterError.dumpErrorToConsole(details);
      }
    };
    _streamSubscription = ProximitySensor.events.listen((int event) {
      isProximityNear = (event > 0) ? true : false;
    });
  }

  Future<void> startVoiceRecording() async {
    final isMicrophonePermissionAllowed =
    await permissionHandlerService.requestMicrophonePermission();
    if (isMicrophonePermissionAllowed) {
      if (isVibrationOn) Vibration.vibrate(duration: 100);
      await _voiceRecord.start(const rec.RecordConfig(), path: filePath);
      startProgressBarAnimation();
    } else if (!isMicrophonePermissionAllowed) {
      disableButtons = true;
      if (buildContext.mounted) {
        scaffoldMessage(
          AppLocalizations.of(buildContext)!.microphonePermissionRequired,
        );
      }
    }
  }

  Future<void> stopVoiceRecording() async {
    await _voiceRecord.stop();
    stopProgressBarAnimation();
  }

  void setContext(BuildContext scaffoldContext) {
    buildContext = scaffoldContext;
  }

  Future<void> sendVoiceMessage() async {
    isCaptureSent = true;
    if (disableButtons) return;
    await stopVoiceRecording();

    captureService.playSoundAndVibrate();
    successOverlayVisible = true;

    CaptureUploadModel capture = CaptureUploadModel(
        messageID: generateUUIDv1(),
        captureType: CaptureType.voice,
        timestamp: generateTimestamp(),
        filename: filename,
        fullFilePath: filePath,
        email: selectedEmail.emailAddress);

    await captureService.sendCapture(capture);
  }

  void onLongPressSend() async {
    if (emails.length > 1) {
      openLongPressSendList();
    }
  }

  void startProgressBarAnimation() {
    progressBarController.animateTo(1.0);
  }

  void stopProgressBarAnimation() {
    progressBarController.stop();
  }

  void onGoBack() {
    quickstartService.disableQuickstart();
    navigationService!.goHome();
  }

  void scaffoldMessage(String text) {
    ScaffoldMessenger.of(buildContext).showSnackBar(SnackBar(
        duration: const Duration(minutes: 1),
        content: Text(text),
        action: SnackBarAction(
            label: AppLocalizations.of(buildContext)!.openSettings,
            onPressed: openPermissionSettings)));
  }

  void openPermissionSettings() {
    onGoBack();
    ScaffoldMessenger.of(buildContext).hideCurrentSnackBar();
    openAppSettings();
  }

  void disposeStreamSubscription() {
    _streamSubscription.cancel();
  }

  void activateProximitySensorIfNeeded() {
    if (isProximityOn) listenSensor();
  }

  void disposeProximitySensorIfNeeded() {
    if (isProximityOn) disposeStreamSubscription();
  }

  Future<void> initState(AnimationController controller) async {
    progressBarController = controller;
    await setFilePath();

    isVibrationOn =
        sharedPreferencesService.getBool(SharedPreferencesConstants.vibration);
    isProximityOn =
        sharedPreferencesService.getBool(SharedPreferencesConstants.proximity);

    activateProximitySensorIfNeeded();
    startVoiceRecording();
  }

  Future<void> setFilePath() async {
    final String currentTimestamp = generateTimestamp();
    final String userId = userInformationService.getUserId();

    filename = "$currentTimestamp-$userId-voice.m4a";

    Directory recordingDirectory = await getApplicationDocumentsDirectory();

    filePath = '${recordingDirectory.path}/$filename';
  }

  Future<void> dispose() async {
    await _voiceRecord.stop();
    _voiceRecord.dispose();
    if (!isCaptureSent) {
      File(getFullFilePath(filename)).delete();
    }
    disposeProximitySensorIfNeeded();
  }
}

