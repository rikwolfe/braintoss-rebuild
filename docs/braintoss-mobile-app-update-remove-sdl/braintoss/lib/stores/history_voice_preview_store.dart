import 'dart:io';
import 'package:braintoss/models/email_model.dart';
import 'package:braintoss/services/interfaces/navigation_service.dart';
import 'package:braintoss/utils/functions/file_path_helper.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:braintoss/stores/base_store.dart';
import 'package:braintoss/models/capture_model.dart';
import 'package:braintoss/services/interfaces/user_information_service.dart';
import 'package:braintoss/services/interfaces/capture_data_manager.dart';
import 'package:braintoss/services/interfaces/capture_service.dart';
import 'package:mobx/mobx.dart';
import 'package:logger/logger.dart';
import '../config/theme.dart';
import '../models/capture_entity.dart';
import '../models/capture_upload_model.dart';
import '../services/interfaces/logger_service.dart';
import '../utils/functions/generators.dart';

part 'history_voice_preview_store.g.dart';

class HistoryVoicePreviewStore = _HistoryVoicePreviewStore
    with _$HistoryVoicePreviewStore;

abstract class _HistoryVoicePreviewStore extends BaseStore with Store {
  _HistoryVoicePreviewStore(
      {required NavigationService navigationService,
      required this.userInformationService,
      required this.captureService,
      required this.captureDataManager,
      required this.loggerService})
      : super(navigationService: navigationService) {
    emails = userInformationService.getUserEmails();
  }

  FlutterSoundPlayer? soundPlayer = FlutterSoundPlayer(logLevel: Level.off);

  final UserInformationService userInformationService;
  final CaptureService captureService;
  final CaptureDataManager captureDataManager;
  final LoggerService loggerService;

  late Capture captureModel;
  late BuildContext buildContext;

  bool isBackButtonPressed = false;

  @observable
  late Email selectedEmail = userInformationService.getDefaultUserEmail();

  @observable
  List<Email> emails = [];

  @observable
  bool isSoundPlaying = false;

  @observable
  bool successOverlayVisible = false;
  @observable
  bool successIconVisible = false;

  @observable
  bool longPressSendListVisible = false;

  @observable
  bool longPressSendListInteractable = false;

  @action
  void closeLongPressSendList() {
    longPressSendListVisible = false;
  }

  @action
  void openLongPressSendList() {
    longPressSendListVisible = true;
    longPressSendListInteractable = true;
  }

  @action
  void onEmailSelectionFromLongPressSend(dynamic selection) {
    selectedEmail = selection;
    closeLongPressSendList();
    sendVoiceMessage();
  }

  @action
  void onLongPressSendAnimationEnd() {
    if (longPressSendListVisible == false) {
      longPressSendListInteractable = false;
    }
  }

  void onLongPressSend() async {
    if (emails.length > 1) {
      openLongPressSendList();
    }
  }

  @action
  void showSuccessIcon() {
    successIconVisible = true;
  }

  @action
  void onSuccessIconAnimationEnd() {
    Future.delayed(slowTransition).then(
      (_) => {if (!isBackButtonPressed) navigationService!.goBack()},
    );
  }

  void setContext(BuildContext buildContext) {
    buildContext = buildContext;
  }

  void setCaptureModel(Capture capture) {
    captureModel = capture;
    selectedEmail = emails.firstWhere(
        (element) => element.emailAddress == capture.email,
        orElse: () => userInformationService.getDefaultUserEmail());
  }

  void playVoiceMessage() async {
    if (soundPlayer!.isPlaying) {
      soundPlayer!.pausePlayer();
      isSoundPlaying = false;
    } else if (soundPlayer!.isPaused) {
      soundPlayer!.resumePlayer();
      isSoundPlaying = true;
    } else {
      await soundPlayer!.openPlayer();

      await soundPlayer!.startPlayer(
          fromURI: getFullFilePath(captureModel.filename),
          whenFinished: () => isSoundPlaying = false);

      isSoundPlaying = true;
    }
  }

  void onSend() async {
    sendVoiceMessage();
  }

  void deleteCapture() {
    captureDataManager.deleteCaptureById(captureModel.messageID);
    onGoBack();
  }

  void dispose() {
    soundPlayer!.closePlayer();
  }

  void onGoBack() {
    isBackButtonPressed = true;
    navigationService!.goBack();
  }

  void sendVoiceMessage() async {
    CaptureEntity? captureEntity =
        await captureDataManager.getCapture(captureModel.messageID);

    if (captureEntity == null) {
      return;
    }
    CaptureUploadModel capture;
    try {
      capture =
          await _createUploadModel(captureEntity, selectedEmail.emailAddress);
    } catch (e) {
      loggerService.recordError(e.toString());
      return;
    }

    captureService.playSoundAndVibrate();
    successOverlayVisible = true;

    captureService.sendCapture(capture);

    File(getFullFilePath(captureModel.filename)).rename(capture.fullFilePath);

    captureDataManager.deleteCapture(captureEntity, deleteFile: false);
  }

  Future<CaptureUploadModel> _createUploadModel(
    CaptureEntity captureEntity,
    String email,
  ) async {
    CaptureUploadModel capture = captureEntity.toCaptureUploadModel();

    capture.messageID = generateUUIDv1();

    String currentTimestamp = generateTimestamp();
    capture.timestamp = currentTimestamp;

    String userId = userInformationService.getUserId();
    String newFilename = "$currentTimestamp-$userId-voice.m4a";

    capture.filename = newFilename;
    capture.fullFilePath = getFullFilePath(newFilename);

    capture.email = email;
    return capture;
  }
}
