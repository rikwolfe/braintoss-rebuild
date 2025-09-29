// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PhotoStore on _PhotoStore, Store {
  late final _$cameraControllerAtom =
      Atom(name: '_PhotoStore.cameraController', context: context);

  @override
  CameraController? get cameraController {
    _$cameraControllerAtom.reportRead();
    return super.cameraController;
  }

  @override
  set cameraController(CameraController? value) {
    _$cameraControllerAtom.reportWrite(value, super.cameraController, () {
      super.cameraController = value;
    });
  }

  late final _$cameraRunningAtom =
      Atom(name: '_PhotoStore.cameraRunning', context: context);

  @override
  bool get cameraRunning {
    _$cameraRunningAtom.reportRead();
    return super.cameraRunning;
  }

  @override
  set cameraRunning(bool value) {
    _$cameraRunningAtom.reportWrite(value, super.cameraRunning, () {
      super.cameraRunning = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_PhotoStore.errorMessage', context: context);

  @override
  String? get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String? value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$cameraModeAtom =
      Atom(name: '_PhotoStore.cameraMode', context: context);

  @override
  RequestType get cameraMode {
    _$cameraModeAtom.reportRead();
    return super.cameraMode;
  }

  @override
  set cameraMode(RequestType value) {
    _$cameraModeAtom.reportWrite(value, super.cameraMode, () {
      super.cameraMode = value;
    });
  }

  late final _$flashModeAtom =
      Atom(name: '_PhotoStore.flashMode', context: context);

  @override
  FlashMode get flashMode {
    _$flashModeAtom.reportRead();
    return super.flashMode;
  }

  @override
  set flashMode(FlashMode value) {
    _$flashModeAtom.reportWrite(value, super.flashMode, () {
      super.flashMode = value;
    });
  }

  late final _$zoomLevelAtom =
      Atom(name: '_PhotoStore.zoomLevel', context: context);

  @override
  double get zoomLevel {
    _$zoomLevelAtom.reportRead();
    return super.zoomLevel;
  }

  @override
  set zoomLevel(double value) {
    _$zoomLevelAtom.reportWrite(value, super.zoomLevel, () {
      super.zoomLevel = value;
    });
  }

  late final _$maxZoomLevelAtom =
      Atom(name: '_PhotoStore.maxZoomLevel', context: context);

  @override
  double get maxZoomLevel {
    _$maxZoomLevelAtom.reportRead();
    return super.maxZoomLevel;
  }

  @override
  set maxZoomLevel(double value) {
    _$maxZoomLevelAtom.reportWrite(value, super.maxZoomLevel, () {
      super.maxZoomLevel = value;
    });
  }

  late final _$actionPopupVisibleAtom =
      Atom(name: '_PhotoStore.actionPopupVisible', context: context);

  @override
  bool get actionPopupVisible {
    _$actionPopupVisibleAtom.reportRead();
    return super.actionPopupVisible;
  }

  @override
  set actionPopupVisible(bool value) {
    _$actionPopupVisibleAtom.reportWrite(value, super.actionPopupVisible, () {
      super.actionPopupVisible = value;
    });
  }

  late final _$actionPopupInteractableAtom =
      Atom(name: '_PhotoStore.actionPopupInteractable', context: context);

  @override
  bool get actionPopupInteractable {
    _$actionPopupInteractableAtom.reportRead();
    return super.actionPopupInteractable;
  }

  @override
  set actionPopupInteractable(bool value) {
    _$actionPopupInteractableAtom
        .reportWrite(value, super.actionPopupInteractable, () {
      super.actionPopupInteractable = value;
    });
  }

  late final _$successOverlayVisibleAtom =
      Atom(name: '_PhotoStore.successOverlayVisible', context: context);

  @override
  bool get successOverlayVisible {
    _$successOverlayVisibleAtom.reportRead();
    return super.successOverlayVisible;
  }

  @override
  set successOverlayVisible(bool value) {
    _$successOverlayVisibleAtom.reportWrite(value, super.successOverlayVisible,
        () {
      super.successOverlayVisible = value;
    });
  }

  late final _$successIconVisibleAtom =
      Atom(name: '_PhotoStore.successIconVisible', context: context);

  @override
  bool get successIconVisible {
    _$successIconVisibleAtom.reportRead();
    return super.successIconVisible;
  }

  @override
  set successIconVisible(bool value) {
    _$successIconVisibleAtom.reportWrite(value, super.successIconVisible, () {
      super.successIconVisible = value;
    });
  }

  late final _$successImageAtom =
      Atom(name: '_PhotoStore.successImage', context: context);

  @override
  String? get successImage {
    _$successImageAtom.reportRead();
    return super.successImage;
  }

  @override
  set successImage(String? value) {
    _$successImageAtom.reportWrite(value, super.successImage, () {
      super.successImage = value;
    });
  }

  late final _$longPressSendListVisibleAtom =
      Atom(name: '_PhotoStore.longPressSendListVisible', context: context);

  @override
  bool get longPressSendListVisible {
    _$longPressSendListVisibleAtom.reportRead();
    return super.longPressSendListVisible;
  }

  @override
  set longPressSendListVisible(bool value) {
    _$longPressSendListVisibleAtom
        .reportWrite(value, super.longPressSendListVisible, () {
      super.longPressSendListVisible = value;
    });
  }

  late final _$longPressSendListInteractableAtom =
      Atom(name: '_PhotoStore.longPressSendListInteractable', context: context);

  @override
  bool get longPressSendListInteractable {
    _$longPressSendListInteractableAtom.reportRead();
    return super.longPressSendListInteractable;
  }

  @override
  set longPressSendListInteractable(bool value) {
    _$longPressSendListInteractableAtom
        .reportWrite(value, super.longPressSendListInteractable, () {
      super.longPressSendListInteractable = value;
    });
  }

  late final _$selectedEmailAtom =
      Atom(name: '_PhotoStore.selectedEmail', context: context);

  @override
  Email get selectedEmail {
    _$selectedEmailAtom.reportRead();
    return super.selectedEmail;
  }

  bool _selectedEmailIsInitialized = false;

  @override
  set selectedEmail(Email value) {
    _$selectedEmailAtom.reportWrite(
        value, _selectedEmailIsInitialized ? super.selectedEmail : null, () {
      super.selectedEmail = value;
      _selectedEmailIsInitialized = true;
    });
  }

  late final _$emailsAtom = Atom(name: '_PhotoStore.emails', context: context);

  @override
  List<Email> get emails {
    _$emailsAtom.reportRead();
    return super.emails;
  }

  bool _emailsIsInitialized = false;

  @override
  set emails(List<Email> value) {
    _$emailsAtom.reportWrite(value, _emailsIsInitialized ? super.emails : null,
        () {
      super.emails = value;
      _emailsIsInitialized = true;
    });
  }

  late final _$lifecycleAsyncAction =
      AsyncAction('_PhotoStore.lifecycle', context: context);

  @override
  Future<dynamic> lifecycle(AppLifecycleState state) {
    return _$lifecycleAsyncAction.run(() => super.lifecycle(state));
  }

  late final _$initializeCameraAsyncAction =
      AsyncAction('_PhotoStore.initializeCamera', context: context);

  @override
  Future<dynamic> initializeCamera([Camera camera = Camera.back]) {
    return _$initializeCameraAsyncAction
        .run(() => super.initializeCamera(camera));
  }

  late final _$disposeCameraAsyncAction =
      AsyncAction('_PhotoStore.disposeCamera', context: context);

  @override
  Future<void> disposeCamera() {
    return _$disposeCameraAsyncAction.run(() => super.disposeCamera());
  }

  late final _$onTapSendAsyncAction =
      AsyncAction('_PhotoStore.onTapSend', context: context);

  @override
  Future<void> onTapSend(BuildContext context) {
    return _$onTapSendAsyncAction.run(() => super.onTapSend(context));
  }

  late final _$_PhotoStoreActionController =
      ActionController(name: '_PhotoStore', context: context);

  @override
  void setZoomLevel(double level) {
    final _$actionInfo = _$_PhotoStoreActionController.startAction(
        name: '_PhotoStore.setZoomLevel');
    try {
      return super.setZoomLevel(level);
    } finally {
      _$_PhotoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCameraRunning(bool running) {
    final _$actionInfo = _$_PhotoStoreActionController.startAction(
        name: '_PhotoStore.setCameraRunning');
    try {
      return super.setCameraRunning(running);
    } finally {
      _$_PhotoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onFlash() {
    final _$actionInfo =
        _$_PhotoStoreActionController.startAction(name: '_PhotoStore.onFlash');
    try {
      return super.onFlash();
    } finally {
      _$_PhotoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void openLongPressSendList() {
    final _$actionInfo = _$_PhotoStoreActionController.startAction(
        name: '_PhotoStore.openLongPressSendList');
    try {
      return super.openLongPressSendList();
    } finally {
      _$_PhotoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void showSuccessIcon() {
    final _$actionInfo = _$_PhotoStoreActionController.startAction(
        name: '_PhotoStore.showSuccessIcon');
    try {
      return super.showSuccessIcon();
    } finally {
      _$_PhotoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onSuccessIconAnimationEnd() {
    final _$actionInfo = _$_PhotoStoreActionController.startAction(
        name: '_PhotoStore.onSuccessIconAnimationEnd');
    try {
      return super.onSuccessIconAnimationEnd();
    } finally {
      _$_PhotoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onEmailSelectionChangeFromPopup(dynamic selection) {
    final _$actionInfo = _$_PhotoStoreActionController.startAction(
        name: '_PhotoStore.onEmailSelectionChangeFromPopup');
    try {
      return super.onEmailSelectionChangeFromPopup(selection);
    } finally {
      _$_PhotoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onEmailSelectionFromLongPressSend(dynamic selection) {
    final _$actionInfo = _$_PhotoStoreActionController.startAction(
        name: '_PhotoStore.onEmailSelectionFromLongPressSend');
    try {
      return super.onEmailSelectionFromLongPressSend(selection);
    } finally {
      _$_PhotoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void openActionPopup() {
    final _$actionInfo = _$_PhotoStoreActionController.startAction(
        name: '_PhotoStore.openActionPopup');
    try {
      return super.openActionPopup();
    } finally {
      _$_PhotoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void closeActionPopup() {
    final _$actionInfo = _$_PhotoStoreActionController.startAction(
        name: '_PhotoStore.closeActionPopup');
    try {
      return super.closeActionPopup();
    } finally {
      _$_PhotoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onVcard() {
    final _$actionInfo =
        _$_PhotoStoreActionController.startAction(name: '_PhotoStore.onVcard');
    try {
      return super.onVcard();
    } finally {
      _$_PhotoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onActionPopupAnimationEnd() {
    final _$actionInfo = _$_PhotoStoreActionController.startAction(
        name: '_PhotoStore.onActionPopupAnimationEnd');
    try {
      return super.onActionPopupAnimationEnd();
    } finally {
      _$_PhotoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
cameraController: ${cameraController},
cameraRunning: ${cameraRunning},
errorMessage: ${errorMessage},
cameraMode: ${cameraMode},
flashMode: ${flashMode},
zoomLevel: ${zoomLevel},
maxZoomLevel: ${maxZoomLevel},
actionPopupVisible: ${actionPopupVisible},
actionPopupInteractable: ${actionPopupInteractable},
successOverlayVisible: ${successOverlayVisible},
successIconVisible: ${successIconVisible},
successImage: ${successImage},
longPressSendListVisible: ${longPressSendListVisible},
longPressSendListInteractable: ${longPressSendListInteractable},
selectedEmail: ${selectedEmail},
emails: ${emails}
    ''';
  }
}
