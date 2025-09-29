// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'voice_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VoiceStore on _VoiceStore, Store {
  late final _$selectedEmailAtom =
      Atom(name: '_VoiceStore.selectedEmail', context: context);

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

  late final _$emailsAtom = Atom(name: '_VoiceStore.emails', context: context);

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

  late final _$emailsPopupVisibleAtom =
      Atom(name: '_VoiceStore.emailsPopupVisible', context: context);

  @override
  bool get emailsPopupVisible {
    _$emailsPopupVisibleAtom.reportRead();
    return super.emailsPopupVisible;
  }

  @override
  set emailsPopupVisible(bool value) {
    _$emailsPopupVisibleAtom.reportWrite(value, super.emailsPopupVisible, () {
      super.emailsPopupVisible = value;
    });
  }

  late final _$emailsPopupInteractableAtom =
      Atom(name: '_VoiceStore.emailsPopupInteractable', context: context);

  @override
  bool get emailsPopupInteractable {
    _$emailsPopupInteractableAtom.reportRead();
    return super.emailsPopupInteractable;
  }

  @override
  set emailsPopupInteractable(bool value) {
    _$emailsPopupInteractableAtom
        .reportWrite(value, super.emailsPopupInteractable, () {
      super.emailsPopupInteractable = value;
    });
  }

  late final _$successOverlayVisibleAtom =
      Atom(name: '_VoiceStore.successOverlayVisible', context: context);

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
      Atom(name: '_VoiceStore.successIconVisible', context: context);

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

  late final _$longPressSendListVisibleAtom =
      Atom(name: '_VoiceStore.longPressSendListVisible', context: context);

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
      Atom(name: '_VoiceStore.longPressSendListInteractable', context: context);

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

  late final _$isProximityNearAtom =
      Atom(name: '_VoiceStore.isProximityNear', context: context);

  @override
  bool get isProximityNear {
    _$isProximityNearAtom.reportRead();
    return super.isProximityNear;
  }

  @override
  set isProximityNear(bool value) {
    _$isProximityNearAtom.reportWrite(value, super.isProximityNear, () {
      super.isProximityNear = value;
    });
  }

  late final _$isProximityOnAtom =
      Atom(name: '_VoiceStore.isProximityOn', context: context);

  @override
  bool get isProximityOn {
    _$isProximityOnAtom.reportRead();
    return super.isProximityOn;
  }

  @override
  set isProximityOn(bool value) {
    _$isProximityOnAtom.reportWrite(value, super.isProximityOn, () {
      super.isProximityOn = value;
    });
  }

  late final _$listenSensorAsyncAction =
      AsyncAction('_VoiceStore.listenSensor', context: context);

  @override
  Future<void> listenSensor() {
    return _$listenSensorAsyncAction.run(() => super.listenSensor());
  }

  late final _$_VoiceStoreActionController =
      ActionController(name: '_VoiceStore', context: context);

  @override
  void closeEmailsPopup() {
    final _$actionInfo = _$_VoiceStoreActionController.startAction(
        name: '_VoiceStore.closeEmailsPopup');
    try {
      return super.closeEmailsPopup();
    } finally {
      _$_VoiceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void openEmailsPopup() {
    final _$actionInfo = _$_VoiceStoreActionController.startAction(
        name: '_VoiceStore.openEmailsPopup');
    try {
      return super.openEmailsPopup();
    } finally {
      _$_VoiceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onActionPopupAnimationEnd() {
    final _$actionInfo = _$_VoiceStoreActionController.startAction(
        name: '_VoiceStore.onActionPopupAnimationEnd');
    try {
      return super.onActionPopupAnimationEnd();
    } finally {
      _$_VoiceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onLongPressSendAnimationEnd() {
    final _$actionInfo = _$_VoiceStoreActionController.startAction(
        name: '_VoiceStore.onLongPressSendAnimationEnd');
    try {
      return super.onLongPressSendAnimationEnd();
    } finally {
      _$_VoiceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onEmailSelectionChangeFromPopup(dynamic selection) {
    final _$actionInfo = _$_VoiceStoreActionController.startAction(
        name: '_VoiceStore.onEmailSelectionChangeFromPopup');
    try {
      return super.onEmailSelectionChangeFromPopup(selection);
    } finally {
      _$_VoiceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onEmailSelectionFromLongPressSend(dynamic selection) {
    final _$actionInfo = _$_VoiceStoreActionController.startAction(
        name: '_VoiceStore.onEmailSelectionFromLongPressSend');
    try {
      return super.onEmailSelectionFromLongPressSend(selection);
    } finally {
      _$_VoiceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void showSuccessIcon() {
    final _$actionInfo = _$_VoiceStoreActionController.startAction(
        name: '_VoiceStore.showSuccessIcon');
    try {
      return super.showSuccessIcon();
    } finally {
      _$_VoiceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onSuccessIconAnimationEnd() {
    final _$actionInfo = _$_VoiceStoreActionController.startAction(
        name: '_VoiceStore.onSuccessIconAnimationEnd');
    try {
      return super.onSuccessIconAnimationEnd();
    } finally {
      _$_VoiceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void openLongPressSendList() {
    final _$actionInfo = _$_VoiceStoreActionController.startAction(
        name: '_VoiceStore.openLongPressSendList');
    try {
      return super.openLongPressSendList();
    } finally {
      _$_VoiceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void closeLongPressSendList() {
    final _$actionInfo = _$_VoiceStoreActionController.startAction(
        name: '_VoiceStore.closeLongPressSendList');
    try {
      return super.closeLongPressSendList();
    } finally {
      _$_VoiceStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedEmail: ${selectedEmail},
emails: ${emails},
emailsPopupVisible: ${emailsPopupVisible},
emailsPopupInteractable: ${emailsPopupInteractable},
successOverlayVisible: ${successOverlayVisible},
successIconVisible: ${successIconVisible},
longPressSendListVisible: ${longPressSendListVisible},
longPressSendListInteractable: ${longPressSendListInteractable},
isProximityNear: ${isProximityNear},
isProximityOn: ${isProximityOn}
    ''';
  }
}
