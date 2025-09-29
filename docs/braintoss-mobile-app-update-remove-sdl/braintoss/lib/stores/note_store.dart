import 'package:braintoss/constants/app_constants.dart';
import 'package:braintoss/models/email_model.dart';
import 'package:braintoss/services/interfaces/logger_service.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:braintoss/stores/base_store.dart';
import 'package:braintoss/routes.dart';
import 'package:braintoss/services/interfaces/capture_service.dart';
import 'package:braintoss/services/interfaces/navigation_service.dart';
import 'package:braintoss/services/interfaces/quickstart_service.dart';
import 'package:braintoss/services/interfaces/user_information_service.dart';
import 'package:braintoss/config/theme.dart';
import 'package:path_provider/path_provider.dart';
import '../models/capture_type.dart';
import '../models/capture_upload_model.dart';
import '../utils/functions/generators.dart';

part 'note_store.g.dart';

class NoteStore = _NoteStore with _$NoteStore;

enum NoteSource { input, shared }

abstract class _NoteStore extends BaseStore with Store {
  final UserInformationService userInformationService;
  final CaptureService captureService;
  final LoggerService loggerService;
  _NoteStore({
    required this.loggerService,
    required NavigationService navigationService,
    required this.userInformationService,
    required this.captureService,
    required this.quickstartService,
  }) : super(navigationService: navigationService) {
    emails = userInformationService.getUserEmails();
    quickstartService.setLastUsedRoute(Routes.note);
  }

  final QuickstartService quickstartService;

  NoteSource noteSource = NoteSource.input;

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

  final textFieldController = TextEditingController();
  late BuildContext buildContext;

  @observable
  late Email selectedEmail = userInformationService.getDefaultUserEmail();

  @observable
  List<Email> emails = [];

  void setContext(BuildContext scaffoldContext) {
    buildContext = scaffoldContext;
    textFieldController.selection =
        TextSelection.collapsed(offset: textFieldController.text.length);
  }

  void sendNote(String content, String email) async {
    if (content.trim().isEmpty) {
      ScaffoldMessenger.of(buildContext).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(buildContext)!.noteTypeNote),
        ),
      );
      return null;
    }

    captureService.playSoundAndVibrate();

    successOverlayVisible = true;
    try {
      CaptureUploadModel capture = await _createUploadModel(content, email);
      await captureService.sendCapture(capture);
    } catch (e) {
      loggerService.recordError(e.toString());
    }
  }

  Future<CaptureUploadModel> _createUploadModel(
      String content, String email) async {
    String currentTimestamp = generateTimestamp();
    String userId = userInformationService.getUserId();
    String filename = "$currentTimestamp-$userId-text.txt";
    String fullFilePath =
        "${(await getApplicationDocumentsDirectory()).path}/$filename";
    File(fullFilePath).writeAsStringSync(content);

    CaptureUploadModel capture = CaptureUploadModel(
        messageID: generateUUIDv1(),
        captureType: CaptureType.note,
        timestamp: currentTimestamp,
        filename: filename,
        fullFilePath: fullFilePath,
        email: email,
        shared: noteSource == NoteSource.shared);
    return capture;
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
      (_) => captureDidSend(),
    );
  }

  void captureDidSend() {
    noteSource == NoteSource.shared
        ? onGoBack()
        : quickstartService.handleBackNavigation(
            SharedPreferencesConstants.quickstart.note, Routes.note);
  }

  void onGoBack() {
    quickstartService.disableQuickstart();
    navigationService!.goHome();
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
    sendNote(textFieldController.text, selectedEmail.emailAddress);
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

  void setSharedNote(String sharedText) {
    if (sharedText.isEmpty) return;

    textFieldController.text = sharedText;
    noteSource = NoteSource.shared;
  }

  void onClearNote() {
    textFieldController.clear();
    closeActionPopup();
  }

  void onPaste() {
    Clipboard.getData("text/plain").then(
      (clipboardData) {
        if (clipboardData != null && clipboardData.text != null) {
          textFieldController.text =
              textFieldController.text + clipboardData.text!;
        }
      },
    ).then(
      (_) => closeActionPopup(),
    );
  }

  void onLongPressSend() async {
    if (emails.length > 1) {
      openLongPressSendList();
    }
  }

  @action
  void onTapSend() {
    sendNote(textFieldController.text, selectedEmail.emailAddress);
  }
}
