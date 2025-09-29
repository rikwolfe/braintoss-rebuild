import 'package:braintoss/models/capture_entity.dart';
import 'package:braintoss/models/capture_model.dart';
import 'package:braintoss/models/request_response_type.dart';
import 'package:braintoss/services/interfaces/capture_data_manager.dart';
import 'package:mobx/mobx.dart';
import 'package:braintoss/stores/base_store.dart';
import 'package:braintoss/routes.dart';
import 'package:braintoss/services/interfaces/navigation_service.dart';
import 'package:braintoss/services/interfaces/quickstart_service.dart';

import '../utils/functions/method_call_handlers.dart';

part 'home_store.g.dart';

class HomeStore = _HomeStore with _$HomeStore;

abstract class _HomeStore extends BaseStore with Store {
  _HomeStore(
      {required NavigationService navigationService,
      required this.quickstartService,
      required this.captureDataManager})
      : super(navigationService: navigationService) {
    quickstartService.triggerQuickstart();
    sendUserInfoToWatch();
  }

  final QuickstartService quickstartService;
  final CaptureDataManager captureDataManager;

  @observable
  bool errorCaptured = false;

  Future<List<Capture>> getFailedCaptures() async {
    int noInternetStatus = ResponseStatusType.noConnection.statusCode;
    List<CaptureEntity> captures = await captureDataManager.getAllCaptures();
    List<Capture> failedCaptures = [];
    for (CaptureEntity captureEntity in captures) {
      Capture capture = captureEntity.toCapture();

      if (captureEntity.statusCode == noInternetStatus ||
          capture.captureStatus == CaptureStatus.fail) {
        errorCaptured = true;
        failedCaptures.add(capture);
      }

      failedCaptures.isEmpty ? errorCaptured = false : errorCaptured = true;
    }

    return failedCaptures;
  }

  void onGoToHistory() {
    navigationService?.navigateTo(Routes.history);
  }

  void onGoToSettings() {
    navigationService?.navigateTo(Routes.settings);
  }

  void onGoToVoice() {
    navigationService?.navigateTo(Routes.voice);
  }

  void onGoToPhoto() {
    navigationService?.navigateTo(Routes.photo);
  }

  void onGoToNote() {
    navigationService?.navigateTo(Routes.note);
  }
}
