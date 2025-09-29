import 'dart:io';
import 'package:braintoss/models/capture_entity.dart';
import 'package:braintoss/models/capture_model.dart';
import 'package:braintoss/models/email_model.dart';
import 'package:braintoss/services/interfaces/capture_data_manager.dart';
import 'package:braintoss/services/interfaces/capture_service.dart';
import 'package:braintoss/services/interfaces/navigation_service.dart';
import 'package:braintoss/services/interfaces/user_information_service.dart';
import 'package:braintoss/stores/base_store.dart';
import 'package:braintoss/utils/functions/file_path_helper.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import '../config/theme.dart';
import '../models/capture_upload_model.dart';
import '../routes.dart';
import '../services/interfaces/logger_service.dart';
import '../utils/functions/generators.dart';

part 'history_note_store.g.dart';

class HistoryNoteStore = _HistoryNoteStore with _$HistoryNoteStore;

abstract class _HistoryNoteStore extends BaseStore with Store {
  _HistoryNoteStore({
    required NavigationService navigationService,
    required this.captureDataManager,
    required this.captureService,
    required this.userInformationService,
    required this.loggerService,
  }) : super(navigationService: navigationService);

  final CaptureDataManager captureDataManager;
  final UserInformationService userInformationService;
  final CaptureService captureService;
  final LoggerService loggerService;

  late Capture captureModel;
  late BuildContext buildContext;

  bool isBackButtonPressed = false;

  @observable
  late Email selectedEmail = userInformationService.getDefaultUserEmail();

  @observable
  late List<Email> emails = userInformationService.getUserEmails();

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
    closeLongPressSendList();
    sendNote(selection.emailAddress);
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

  String loadFileToString(String filepath) {
    File file = File(filepath);
    if (!file.existsSync()) {
      return "";
    }

    return file.readAsStringSync();
  }

  void deleteCapture() {
    captureDataManager.deleteCaptureById(captureModel.messageID);
    onGoBack();
  }

  void setContext(BuildContext buildContext) {
    this.buildContext = buildContext;
  }

  void setCaptureModel(Capture capture) {
    captureModel = capture;
    selectedEmail = emails.firstWhere(
        (element) => element.emailAddress == capture.email,
        orElse: () => userInformationService.getDefaultUserEmail());
  }

  void onGoBack() {
    isBackButtonPressed = true;
    navigationService?.goBack();
  }

  void onGoToHistory() {
    navigationService?.navigateTo(Routes.history);
  }

  @observable
  bool successOverlayVisible = false;
  @observable
  bool successIconVisible = false;

  void sendNote(String email) async {
    CaptureEntity? captureEntity =
        await captureDataManager.getCapture(captureModel.messageID);

    if (captureEntity == null) {
      return;
    }

    captureService.playSoundAndVibrate();
    successOverlayVisible = true;

    CaptureUploadModel capture;
    try {
      capture = await _createUploadModel(captureEntity, email);
    } catch (e) {
      loggerService.recordError(e.toString());
      return;
    }

    captureService.sendCapture(capture);

    File(getFullFilePath(captureModel.filename)).rename(capture.fullFilePath);

    captureDataManager.deleteCapture(captureEntity, deleteFile: false);
  }

  Future<CaptureUploadModel> _createUploadModel(
      CaptureEntity captureEntity, String email) async {
    CaptureUploadModel capture = captureEntity.toCaptureUploadModel();

    capture.messageID = generateUUIDv1();

    String currentTimestamp = generateTimestamp();
    capture.timestamp = currentTimestamp;

    String userId = userInformationService.getUserId();
    String newFilename = "$currentTimestamp-$userId-text.txt";

    capture.filename = newFilename;
    capture.fullFilePath = getFullFilePath(newFilename);

    capture.email = email;
    return capture;
  }

  void onSend() async {
    sendNote(selectedEmail.emailAddress);
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
}
