import 'package:braintoss/models/capture_entity.dart';
import 'package:braintoss/models/request_response_type.dart';
import 'package:braintoss/models/status_request_response.dart';
import 'package:braintoss/services/interfaces/capture_service.dart';
import 'package:braintoss/services/interfaces/quickstart_service.dart';
import 'package:braintoss/services/interfaces/status_updater_service.dart';
import 'package:braintoss/pages/history_note_page.dart';
import 'package:braintoss/routes.dart';
import 'package:braintoss/widgets/atoms/confirmation_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:braintoss/stores/base_store.dart';
import 'package:braintoss/pages/history_voice_preview.dart';
import 'package:braintoss/services/interfaces/capture_data_manager.dart';
import 'package:braintoss/services/interfaces/navigation_service.dart';
import 'package:braintoss/models/capture_model.dart';
import 'package:mobx/mobx.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/capture_type.dart';
import '../models/request_response.dart';
import '../pages/history_photo_page.dart';
import '../utils/functions/method_call_handlers.dart';

part 'history_store.g.dart';

class HistoryStore = _HistoryStore with _$HistoryStore;

abstract class _HistoryStore extends BaseStore with Store {
  _HistoryStore(
    NavigationService navigationService,
    this.captureDataManager,
    this._statusUpdaterService,
    this._captureService,
    this._quickstartService,
  ) : super(navigationService: navigationService) {
    sendUserInfoToWatch();
    getAndUpdateCaptures();
  }

  late BuildContext buildContext;

  final CaptureDataManager captureDataManager;
  final StatusUpdaterService _statusUpdaterService;
  final CaptureService _captureService;
  final QuickstartService _quickstartService;

  @observable
  ObservableList<Capture> captureList = ObservableList.of([]);

  @observable
  bool updating = false;

  @observable
  bool isDeleteDone = false;

  void setContext(BuildContext context) {
    buildContext = context;
  }

  @action
  Future<void> getAndUpdateCaptures() async {
    if (updating) return;
    updating = true;
    await captureDataManager.deleteOldCaptures();

    List<CaptureEntity> captures = await captureDataManager.getAllCaptures();
    captures.sort((captureOne, captureTwo) =>
        captureTwo.dateAndTime.compareTo(captureOne.dateAndTime));

    renderCaptureEntities(captures);

    for (CaptureEntity capture in captures) {
      if (!updating) break;
      if (capture.isAlive()) {
        RequestResponse? responseStatus =
            await _statusUpdaterService.updateStatus(capture);
        if (responseStatus?.type == ResponseStatusType.messageNotFound) {
          StatusRequestResponse? statusResponse =
              await _captureService.resendCapture(capture);
          if (statusResponse != null && statusResponse.response.error == 0) {
            capture.status = statusResponse.response.history![0].status ?? "";
            capture.statusCode = statusResponse.response.history![0].code;
            capture.description =
                statusResponse.response.history![0].description;
          }
        }
      }
      renderSingleCapture(capture);
    }
    if (isDeleteDone) captureDataManager.deleteAllCaptures();

    updating = false;
  }

  @action
  void renderCaptureEntities(List<CaptureEntity> captureEntities) {
    if (isDeleteDone) return;

    captureList =
        ObservableList.of(captureEntities.map((e) => e.toCapture()).toList());
  }

  @action
  void renderSingleCapture(CaptureEntity captureEntitie) {
    if (isDeleteDone) return;

    for (int i = 0; i < captureList.length; i++) {
      if (captureList[i].messageID == captureEntitie.messageID) {
        captureList[i] = captureEntitie.toCapture();
      }
    }
  }

  @action
  Future<void> updateHistoryOnRefresh() async {
    await getAndUpdateCaptures();
  }

  Future<void> navigateTo(Capture captureModel) async {
    updating = false;
    switch (captureModel.captureType) {
      case CaptureType.note:
        await navigationService!.navigateTo(Routes.historyNote,
            arguments: HistoryNotePreviewArgs(captureModel));
        break;
      case CaptureType.photo:
        await navigationService!.navigateTo(Routes.historyPhotoPreview,
            arguments: HistoryPhotoPreviewArgs(captureModel));
        break;
      case CaptureType.voiceWatch:
      case CaptureType.voice:
        await navigationService!.navigateTo(Routes.historyVoicePreview,
            arguments: HistoryVoicePreviewArgs(captureModel));
        break;
    }
    updating = false;
    Future.delayed(const Duration(seconds: 1)).then(
      (_) => getAndUpdateCaptures(),
    );
  }

  void showDeleteHistoryPopup() {
    if (buildContext.mounted) {
      showDialog(
        context: buildContext,
        builder: (_) => ConfirmationDialog(
          title: AppLocalizations.of(buildContext)!.deleteHistoryTitle,
          text: AppLocalizations.of(buildContext)!.deleteHistoryText,
          confirmationLabel:
              AppLocalizations.of(buildContext)!.deleteHistoryDelete,
          confirmationCallback: deleteHistory,
          dismissLabel: AppLocalizations.of(buildContext)!.cancelGeneric,
        ),
      );
    } else {
      if (kDebugMode) {
        print("Context has not been set. Unable to show the delete popup.");
      }
    }
  }

  @action
  Future<void> deleteHistory() async {
    updating = false;
    isDeleteDone = true;
    captureDataManager.deleteAllCaptures();
    captureList.clear();
  }

  void onGoBack() {
    _quickstartService.disableQuickstart();
    navigationService!.goBack();
  }
}
