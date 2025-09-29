import 'dart:developer';
import 'dart:io';

import 'package:braintoss/constants/app_constants.dart';

import 'package:braintoss/models/email_model.dart';
import 'package:braintoss/models/capture_upload_model.dart';
import 'package:braintoss/pages/image_page.dart';
import 'package:braintoss/routes.dart';
import 'package:braintoss/services/interfaces/navigation_service.dart';
import 'package:braintoss/services/interfaces/request_building_service.dart';
import 'package:braintoss/stores/base_store.dart';
import 'package:braintoss/utils/functions/generators.dart';
import 'package:camera/camera.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:file_picker/file_picker.dart';
import '../config/theme.dart';
import '../models/capture_type.dart';
import '../services/interfaces/capture_service.dart';
import '../services/interfaces/user_information_service.dart';
import 'package:braintoss/services/interfaces/quickstart_service.dart';

import '../utils/functions/image_helpers.dart';

part 'photo_store.g.dart';

class PhotoStore = _PhotoStore with _$PhotoStore;

enum Camera { back, front }

abstract class _PhotoStore extends BaseStore with Store {
  final QuickstartService quickstartService;
  final UserInformationService userInformationService;
  final CaptureService captureService;

  _PhotoStore({
    required NavigationService navigationService,
    required this.userInformationService,
    required this.captureService,
    required this.quickstartService,
  }) : super(navigationService: navigationService) {
    quickstartService.setLastUsedRoute(Routes.photo);
  }

  late List<CameraDescription>? cameras;

  late BuildContext buildContext;
  @observable
  CameraController? cameraController;

  @observable
  bool cameraRunning = false;
  @observable
  String? errorMessage;

  @observable
  RequestType cameraMode = RequestType.photo;
  @observable
  FlashMode flashMode = FlashMode.off;

  @observable
  double zoomLevel = 1;
  @observable
  double maxZoomLevel = 1;

  Camera currentCamera = Camera.back;

  @observable
  bool actionPopupVisible = false;
  @observable
  bool actionPopupInteractable = false;

  @observable
  bool successOverlayVisible = false;
  @observable
  bool successIconVisible = false;
  @observable
  String? successImage;

  @observable
  bool longPressSendListVisible = false;
  @observable
  bool longPressSendListInteractable = false;

  @observable
  late Email selectedEmail = userInformationService.getDefaultUserEmail();

  @observable
  late List<Email> emails = userInformationService.getUserEmails();

  //UI and helpers
  void onGoBack() {
    quickstartService.disableQuickstart();
    navigationService!.goHome();
    disposeCamera();
  }

  @action
  Future<dynamic> lifecycle(AppLifecycleState state) async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.resumed:
        if (cameraController == null) {
          await initializeCamera(currentCamera);
        } else {
          cameraController!.resumePreview();
        }

      case AppLifecycleState.inactive:
        cameraController!.pausePreview();

      case AppLifecycleState.paused:
        cameraController!.pausePreview();

      case AppLifecycleState.detached:
        cameraController!.pausePreview();

      case AppLifecycleState.hidden:
        cameraController!.pausePreview();
    }

    return;
  }

  String flashModeName(FlashMode flashMode, BuildContext context) {
    switch (flashMode) {
      case FlashMode.auto:
        return AppLocalizations.of(context)!.photoAuto;
      case FlashMode.off:
        return AppLocalizations.of(context)!.photoOff;
      case FlashMode.always:
        return AppLocalizations.of(context)!.photoOn;
      default:
        return "Error";
    }
  }

  String flashModeIcon(FlashMode flashMode) {
    switch (flashMode) {
      case FlashMode.auto:
        return ButtonImages.flashAuto;
      case FlashMode.off:
        return ButtonImages.flashOff;
      case FlashMode.always:
        return ButtonImages.flashOn;
      default:
        return ButtonImages.closeScreen;
    }
  }

  void setContext(BuildContext scaffoldContext) {
    buildContext = scaffoldContext;
  }

  void _error(String message) {
    setErrorMessage(message);
    throw Exception(message);
  }

  //Camera API
  @action
  Future initializeCamera([Camera camera = Camera.back]) async {
    setErrorMessage(null);

    try {
      log("checking camera permission");
      log("got permission status");

      cameras = await availableCameras();

      if (cameras == null) {
        _error("No cameras accessible.");
      }
      if (cameras!.isEmpty) {
        _error("No cameras available.");
      }

      CameraController controller = CameraController(
        cameras![camera.index],
        ResolutionPreset.max,
        enableAudio: false,
      );

      await controller.initialize();
      controller.lockCaptureOrientation(DeviceOrientation.portraitUp);

      cameraController = controller;

      zoomLevel = 1;
      maxZoomLevel = await controller.getMaxZoomLevel();
      setCameraRunning(true);
    } catch (e) {
      setCameraRunning(false);
      log("CAMERA ERROR: $e");
      FirebaseCrashlytics.instance.log(e.toString());
      rethrow;
    }
  }

  @action
  Future<void> disposeCamera() async {
    if (cameraController != null) {
      setCameraRunning(false);
      setErrorMessage(null);
      await cameraController!.dispose();
    }
  }

  @action
  void setZoomLevel(double level) {
    cameraController?.setZoomLevel(level).then(
          (_) => {zoomLevel = level},
        );
  }

  @action
  void setCameraRunning(bool running) {
    cameraRunning = running;
  }

  void setErrorMessage(String? message) {
    errorMessage = message;
  }

  void setOverlayVisibility(bool isVisible) {
    successOverlayVisible = isVisible;
    successIconVisible = isVisible;
  }

  @action
  Future<void> onTapSend(BuildContext context) async {
    takeAndSendPhoto(selectedEmail.emailAddress);
    setOverlayVisibility(false);
  }

  Future<void> takeAndSendPhoto(String email) async {
    if (cameraController != null && cameraController!.value.isInitialized) {
      try {
        XFile? picture = await cameraController?.takePicture();
        if (picture == null) {
          throw Exception("Failed to take photo.");
        }

        captureService.playSoundAndVibrate();

        successImage = picture.path;
        successOverlayVisible = true;

        CaptureUploadModel capture = await _createUploadModel(picture, email);

        await captureService.sendCapture(capture);
      } catch (e) {
        FirebaseCrashlytics.instance.log(e.toString());
        rethrow;
      }
    }
  }

  Future<CaptureUploadModel> _createUploadModel(
      XFile picture, String email) async {
    String currentTimestamp = generateTimestamp();
    String userId = userInformationService.getUserId();
    String filename = "$currentTimestamp-$userId-camera-resized.jpg";
    String fullFilePath = (await compressImage(picture.path, filename)).path;

    CaptureUploadModel capture = CaptureUploadModel(
        messageID: generateUUIDv1(),
        captureType: CaptureType.photo,
        timestamp: currentTimestamp,
        filename: filename,
        fullFilePath: fullFilePath,
        email: email,
        vcard: cameraMode == RequestType.photoVcf,
        ocr: cameraMode == RequestType.photoOcr);
    return capture;
  }

  void onLongPressSend() {
    if (emails.isNotEmpty) {
      openLongPressSendList();
    }
  }

  void onLongPressSendAnimationEnd() {
    if (longPressSendListVisible == false) {
      longPressSendListInteractable = false;
    }
  }

  @action
  void onFlash() {
    if (cameraRunning) {
      switch (flashMode) {
        case FlashMode.off:
          flashMode = FlashMode.always;
          cameraController?.setFlashMode(FlashMode.always);
          break;
        case FlashMode.always:
          flashMode = FlashMode.auto;
          cameraController?.setFlashMode(FlashMode.auto);
          break;
        default:
          flashMode = FlashMode.off;
          cameraController?.setFlashMode(FlashMode.off);
          break;
      }
    }
  }

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
    Future.delayed(verySlowTransition).then(
      (_) {
        handleNavigation();
      },
    );
  }

  void handleNavigation() {
    try {
      File(successImage!).deleteSync();
    } catch (e) {
      debugPrint("Failed to delete $successImage");
    }

    if (quickstartService.isPhotoQuickstartEnable()) {
      setOverlayVisibility(false);
    } else {
      onGoBack();
    }
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
    takeAndSendPhoto(selectedEmail.emailAddress);
  }

  @action
  void openActionPopup() {
    closeLongPressSendList();
    actionPopupVisible = true;
    actionPopupInteractable = true;
  }

  @action
  void closeActionPopup() {
    actionPopupVisible = false;
  }

  void onFlip() {
    if (cameraRunning) {
      switch (currentCamera) {
        case Camera.back:
          currentCamera = Camera.front;
          break;
        case Camera.front:
          currentCamera = Camera.back;
          break;
      }
      initializeCamera(currentCamera);
      Future.delayed(mediumQuickTransition, () => closeActionPopup());
    }
  }

  void onAlbum() async {
    closeActionPopup();

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null) {
      navigationService!.replaceWith(Routes.image,
          arguments: ImagePageArgs([result.files[0].path!], ImageSource.album));
    }
  }

  void onPaste() async {
    closeActionPopup();
    ClipboardData? clipboardData = await Clipboard.getData("text/plain");
    if (clipboardData != null &&
        clipboardData.text!.isNotEmpty &&
        clipboardData.text!.startsWith("http")) {
      navigationService!.replaceWith(Routes.image,
          arguments:
              ImagePageArgs([clipboardData.text!], ImageSource.download));
    } else {
      if (buildContext.mounted) {
        ScaffoldMessenger.of(buildContext).showSnackBar(
          SnackBar(
            content:
                Text(AppLocalizations.of(buildContext)!.noImageInClipboard),
          ),
        );
      }
    }
  }

  @action
  void onVcard() {
    if (cameraRunning) {
      if (cameraMode == RequestType.photoVcf) {
        cameraMode = RequestType.photo;
      } else {
        cameraMode = RequestType.photoVcf;
      }
      Future.delayed(mediumQuickTransition, () => closeActionPopup());
    }
  }

  @action
  void onActionPopupAnimationEnd() {
    if (actionPopupVisible == false) {
      actionPopupInteractable = false;
    }
  }
}
