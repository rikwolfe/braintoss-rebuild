import 'package:braintoss/stores/base_store.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';

import '../services/interfaces/navigation_service.dart';

part 'capture_store.g.dart';

class CaptureStore = _CaptureStore with _$CaptureStore;

abstract class _CaptureStore extends BaseStore with Store {
  _CaptureStore({required NavigationService navigationService})
      : super(navigationService: navigationService);

  void onGoBack() {
    navigationService?.goBack();
  }

  void dismissKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
