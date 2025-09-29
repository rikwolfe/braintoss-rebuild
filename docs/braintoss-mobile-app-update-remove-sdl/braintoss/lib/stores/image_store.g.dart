// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ImageStore on _ImageStore, Store {
  late final _$imagesAtom = Atom(name: '_ImageStore.images', context: context);

  @override
  List<File> get images {
    _$imagesAtom.reportRead();
    return super.images;
  }

  @override
  set images(List<File> value) {
    _$imagesAtom.reportWrite(value, super.images, () {
      super.images = value;
    });
  }

  late final _$imageModeAtom =
      Atom(name: '_ImageStore.imageMode', context: context);

  @override
  RequestType get imageMode {
    _$imageModeAtom.reportRead();
    return super.imageMode;
  }

  @override
  set imageMode(RequestType value) {
    _$imageModeAtom.reportWrite(value, super.imageMode, () {
      super.imageMode = value;
    });
  }

  late final _$actionPopupVisibleAtom =
      Atom(name: '_ImageStore.actionPopupVisible', context: context);

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
      Atom(name: '_ImageStore.actionPopupInteractable', context: context);

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
      Atom(name: '_ImageStore.successOverlayVisible', context: context);

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
      Atom(name: '_ImageStore.successIconVisible', context: context);

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
      Atom(name: '_ImageStore.longPressSendListVisible', context: context);

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
      Atom(name: '_ImageStore.longPressSendListInteractable', context: context);

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
      Atom(name: '_ImageStore.selectedEmail', context: context);

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

  late final _$emailsAtom = Atom(name: '_ImageStore.emails', context: context);

  @override
  List<Email> get emails {
    _$emailsAtom.reportRead();
    return super.emails;
  }

  @override
  set emails(List<Email> value) {
    _$emailsAtom.reportWrite(value, super.emails, () {
      super.emails = value;
    });
  }

  late final _$_ImageStoreActionController =
      ActionController(name: '_ImageStore', context: context);

  @override
  void setImages(List<String> paths, ImageSource source) {
    final _$actionInfo = _$_ImageStoreActionController.startAction(
        name: '_ImageStore.setImages');
    try {
      return super.setImages(paths, source);
    } finally {
      _$_ImageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void closeActionPopup() {
    final _$actionInfo = _$_ImageStoreActionController.startAction(
        name: '_ImageStore.closeActionPopup');
    try {
      return super.closeActionPopup();
    } finally {
      _$_ImageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void openActionPopup() {
    final _$actionInfo = _$_ImageStoreActionController.startAction(
        name: '_ImageStore.openActionPopup');
    try {
      return super.openActionPopup();
    } finally {
      _$_ImageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void closeLongPressSendList() {
    final _$actionInfo = _$_ImageStoreActionController.startAction(
        name: '_ImageStore.closeLongPressSendList');
    try {
      return super.closeLongPressSendList();
    } finally {
      _$_ImageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void openLongPressSendList() {
    final _$actionInfo = _$_ImageStoreActionController.startAction(
        name: '_ImageStore.openLongPressSendList');
    try {
      return super.openLongPressSendList();
    } finally {
      _$_ImageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void showSuccessIcon() {
    final _$actionInfo = _$_ImageStoreActionController.startAction(
        name: '_ImageStore.showSuccessIcon');
    try {
      return super.showSuccessIcon();
    } finally {
      _$_ImageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onSuccessIconAnimationEnd() {
    final _$actionInfo = _$_ImageStoreActionController.startAction(
        name: '_ImageStore.onSuccessIconAnimationEnd');
    try {
      return super.onSuccessIconAnimationEnd();
    } finally {
      _$_ImageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onEmailSelectionChangeFromPopup(dynamic selection) {
    final _$actionInfo = _$_ImageStoreActionController.startAction(
        name: '_ImageStore.onEmailSelectionChangeFromPopup');
    try {
      return super.onEmailSelectionChangeFromPopup(selection);
    } finally {
      _$_ImageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onEmailSelectionFromLongPressSend(dynamic selection) {
    final _$actionInfo = _$_ImageStoreActionController.startAction(
        name: '_ImageStore.onEmailSelectionFromLongPressSend');
    try {
      return super.onEmailSelectionFromLongPressSend(selection);
    } finally {
      _$_ImageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onActionPopupAnimationEnd() {
    final _$actionInfo = _$_ImageStoreActionController.startAction(
        name: '_ImageStore.onActionPopupAnimationEnd');
    try {
      return super.onActionPopupAnimationEnd();
    } finally {
      _$_ImageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onLongPressSendAnimationEnd() {
    final _$actionInfo = _$_ImageStoreActionController.startAction(
        name: '_ImageStore.onLongPressSendAnimationEnd');
    try {
      return super.onLongPressSendAnimationEnd();
    } finally {
      _$_ImageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onTapSend() {
    final _$actionInfo = _$_ImageStoreActionController.startAction(
        name: '_ImageStore.onTapSend');
    try {
      return super.onTapSend();
    } finally {
      _$_ImageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onScan() {
    final _$actionInfo =
        _$_ImageStoreActionController.startAction(name: '_ImageStore.onScan');
    try {
      return super.onScan();
    } finally {
      _$_ImageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onVcard() {
    final _$actionInfo =
        _$_ImageStoreActionController.startAction(name: '_ImageStore.onVcard');
    try {
      return super.onVcard();
    } finally {
      _$_ImageStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
images: ${images},
imageMode: ${imageMode},
actionPopupVisible: ${actionPopupVisible},
actionPopupInteractable: ${actionPopupInteractable},
successOverlayVisible: ${successOverlayVisible},
successIconVisible: ${successIconVisible},
longPressSendListVisible: ${longPressSendListVisible},
longPressSendListInteractable: ${longPressSendListInteractable},
selectedEmail: ${selectedEmail},
emails: ${emails}
    ''';
  }
}
