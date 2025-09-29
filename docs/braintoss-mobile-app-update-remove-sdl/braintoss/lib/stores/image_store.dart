import 'dart:io';
import 'package:braintoss/config/theme.dart';
import 'package:braintoss/models/email_model.dart';
import 'package:braintoss/services/interfaces/capture_service.dart';
import 'package:braintoss/services/interfaces/logger_service.dart';
import 'package:braintoss/services/interfaces/navigation_service.dart';
import 'package:braintoss/services/interfaces/quickstart_service.dart';
import 'package:braintoss/services/interfaces/user_information_service.dart';
import 'package:braintoss/stores/base_store.dart';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import '../models/capture_type.dart';
import '../models/capture_upload_model.dart';
import '../services/interfaces/request_building_service.dart';

import '../utils/functions/generators.dart';
import '../utils/functions/image_helpers.dart';

part 'image_store.g.dart';

class ImageStore = _ImageStore with _$ImageStore;

abstract class _ImageStore extends BaseStore with Store {
  final UserInformationService _userInformationService;
  final CaptureService _captureService;
  final LoggerService loggerService;
  _ImageStore(
    this._userInformationService,
    this._captureService, {
    required this.quickstartService,
    required this.loggerService,
    required NavigationService navigationService,
  }) : super(navigationService: navigationService) {
    emails = _userInformationService.getUserEmails();
  }

  final QuickstartService quickstartService;

  ImageSource source = ImageSource.album;
  @observable
  List<File> images = [];

  @observable
  RequestType imageMode = RequestType.photo;

  @observable
  bool actionPopupVisible = false;
  @observable
  bool actionPopupInteractable = false;

  @observable
  bool successOverlayVisible = false;
  @observable
  bool successIconVisible = false;

  @observable
  bool longPressSendListVisible = false;
  @observable
  bool longPressSendListInteractable = false;

  late BuildContext buildContext;

  @observable
  late Email selectedEmail = _userInformationService.getDefaultUserEmail();

  @observable
  List<Email> emails = [];

  void setContext(BuildContext scaffoldContext) {
    buildContext = scaffoldContext;
  }

  @action
  void setImages(List<String> paths, ImageSource source) {
    images = paths.map((e) {
      return File(e);
    }).toList();
    this.source = source;
  }

  @action
  void closeActionPopup() {
    actionPopupVisible = false;
  }

  @action
  void openActionPopup() {
    closeLongPressSendList();
    actionPopupVisible = true;
    actionPopupInteractable = true;
  }

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
  void showSuccessIcon() {
    successIconVisible = true;
  }

  @action
  void onSuccessIconAnimationEnd() {
    Future.delayed(slowTransition).then(
      (_) => onGoBack(),
    );
  }

  void onGoBack() {
    quickstartService.disableQuickstart();
    navigationService?.goHome();
  }

  @action
  void onEmailSelectionChangeFromPopup(dynamic selection) {
    selectedEmail = selection;
    Future.delayed(mediumQuickTransition, () => closeActionPopup());
  }

  @action
  void onEmailSelectionFromLongPressSend(dynamic selection) {
    selectedEmail = selection;
    closeLongPressSendList();
    sendImage(selectedEmail.emailAddress);
  }

  @action
  void onActionPopupAnimationEnd() {
    if (actionPopupVisible == false) {
      actionPopupInteractable = false;
    }
  }

  @action
  void onLongPressSendAnimationEnd() {
    if (longPressSendListVisible == false) {
      longPressSendListInteractable = false;
    }
  }

  void onPaste() {}

  void onLongPressSend() async {
    if (emails.length > 1) {
      openLongPressSendList();
    }
  }

  @action
  void onTapSend() {
    sendImage(selectedEmail.emailAddress);
  }

  @action
  void onScan() {
    if (imageMode == RequestType.photoOcr) {
      imageMode = RequestType.photo;
    } else {
      imageMode = RequestType.photoOcr;
    }
    Future.delayed(mediumQuickTransition, () => closeActionPopup());
  }

  @action
  void onVcard() {
    if (imageMode == RequestType.photoVcf) {
      imageMode = RequestType.photo;
    } else {
      imageMode = RequestType.photoVcf;
    }
    Future.delayed(mediumQuickTransition, () => closeActionPopup());
  }

  void sendImage(String email) async {
    if (images.isEmpty) {
      return;
    }
    _captureService.playSoundAndVibrate();
    successOverlayVisible = true;

    for (File image in images) {
      try {
        CaptureUploadModel capture =
            await _createUploadModel(email, image.path);

        await _captureService.sendCapture(capture);

        await deleteCachedImage(image.path);
      } catch (e) {
        loggerService.recordError(e.toString());
      }
    }
  }

  Future<void> deleteCachedImage(String path) async {
    File imageFile = File(path);
    await imageFile.delete();
    return;
  }

  Future<CaptureUploadModel> _createUploadModel(
      String email, String imagePath) async {
    String currentTimestamp = generateTimestamp();
    String userId = _userInformationService.getUserId();

    String filename;
    String fullFilePath;
    switch (source) {
      case ImageSource.camera:
        throw ArgumentError(
            "Cannot accept camera images in shared image page.");
      case ImageSource.album:
        filename = "$currentTimestamp-$userId-resized.jpg";
        fullFilePath = (await compressImage(imagePath, filename)).path;
        break;
      case ImageSource.share:
        filename = "$currentTimestamp-$userId-shared-resized.jpg";
        fullFilePath = (await compressImage(imagePath, filename)).path;
        break;
      case ImageSource.download:
        filename = "$currentTimestamp-$userId-downloaded.jpg";
        String downloadedImagePath = await downloadImage(imagePath);
        fullFilePath =
            (await compressImage(downloadedImagePath, filename)).path;
        break;
    }

    CaptureUploadModel capture = CaptureUploadModel(
        messageID: generateUUIDv1(),
        captureType: CaptureType.photo,
        timestamp: currentTimestamp,
        filename: filename,
        fullFilePath: fullFilePath,
        email: email,
        vcard: imageMode == RequestType.photoVcf,
        ocr: imageMode == RequestType.photoOcr,
        shared: source == ImageSource.share);
    return capture;
  }
}
