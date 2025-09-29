// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_voice_preview_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HistoryVoicePreviewStore on _HistoryVoicePreviewStore, Store {
  late final _$selectedEmailAtom =
      Atom(name: '_HistoryVoicePreviewStore.selectedEmail', context: context);

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

  late final _$emailsAtom =
      Atom(name: '_HistoryVoicePreviewStore.emails', context: context);

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

  late final _$isSoundPlayingAtom =
      Atom(name: '_HistoryVoicePreviewStore.isSoundPlaying', context: context);

  @override
  bool get isSoundPlaying {
    _$isSoundPlayingAtom.reportRead();
    return super.isSoundPlaying;
  }

  @override
  set isSoundPlaying(bool value) {
    _$isSoundPlayingAtom.reportWrite(value, super.isSoundPlaying, () {
      super.isSoundPlaying = value;
    });
  }

  late final _$successOverlayVisibleAtom = Atom(
      name: '_HistoryVoicePreviewStore.successOverlayVisible',
      context: context);

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

  late final _$successIconVisibleAtom = Atom(
      name: '_HistoryVoicePreviewStore.successIconVisible', context: context);

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

  late final _$longPressSendListVisibleAtom = Atom(
      name: '_HistoryVoicePreviewStore.longPressSendListVisible',
      context: context);

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

  late final _$longPressSendListInteractableAtom = Atom(
      name: '_HistoryVoicePreviewStore.longPressSendListInteractable',
      context: context);

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

  late final _$_HistoryVoicePreviewStoreActionController =
      ActionController(name: '_HistoryVoicePreviewStore', context: context);

  @override
  void closeLongPressSendList() {
    final _$actionInfo = _$_HistoryVoicePreviewStoreActionController
        .startAction(name: '_HistoryVoicePreviewStore.closeLongPressSendList');
    try {
      return super.closeLongPressSendList();
    } finally {
      _$_HistoryVoicePreviewStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void openLongPressSendList() {
    final _$actionInfo = _$_HistoryVoicePreviewStoreActionController
        .startAction(name: '_HistoryVoicePreviewStore.openLongPressSendList');
    try {
      return super.openLongPressSendList();
    } finally {
      _$_HistoryVoicePreviewStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onEmailSelectionFromLongPressSend(dynamic selection) {
    final _$actionInfo =
        _$_HistoryVoicePreviewStoreActionController.startAction(
            name:
                '_HistoryVoicePreviewStore.onEmailSelectionFromLongPressSend');
    try {
      return super.onEmailSelectionFromLongPressSend(selection);
    } finally {
      _$_HistoryVoicePreviewStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onLongPressSendAnimationEnd() {
    final _$actionInfo =
        _$_HistoryVoicePreviewStoreActionController.startAction(
            name: '_HistoryVoicePreviewStore.onLongPressSendAnimationEnd');
    try {
      return super.onLongPressSendAnimationEnd();
    } finally {
      _$_HistoryVoicePreviewStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void showSuccessIcon() {
    final _$actionInfo = _$_HistoryVoicePreviewStoreActionController
        .startAction(name: '_HistoryVoicePreviewStore.showSuccessIcon');
    try {
      return super.showSuccessIcon();
    } finally {
      _$_HistoryVoicePreviewStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onSuccessIconAnimationEnd() {
    final _$actionInfo =
        _$_HistoryVoicePreviewStoreActionController.startAction(
            name: '_HistoryVoicePreviewStore.onSuccessIconAnimationEnd');
    try {
      return super.onSuccessIconAnimationEnd();
    } finally {
      _$_HistoryVoicePreviewStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedEmail: ${selectedEmail},
emails: ${emails},
isSoundPlaying: ${isSoundPlaying},
successOverlayVisible: ${successOverlayVisible},
successIconVisible: ${successIconVisible},
longPressSendListVisible: ${longPressSendListVisible},
longPressSendListInteractable: ${longPressSendListInteractable}
    ''';
  }
}
