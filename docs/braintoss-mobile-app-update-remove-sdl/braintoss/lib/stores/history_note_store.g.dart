// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_note_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HistoryNoteStore on _HistoryNoteStore, Store {
  late final _$selectedEmailAtom =
      Atom(name: '_HistoryNoteStore.selectedEmail', context: context);

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
      Atom(name: '_HistoryNoteStore.emails', context: context);

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

  late final _$longPressSendListVisibleAtom = Atom(
      name: '_HistoryNoteStore.longPressSendListVisible', context: context);

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
      name: '_HistoryNoteStore.longPressSendListInteractable',
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

  late final _$successOverlayVisibleAtom =
      Atom(name: '_HistoryNoteStore.successOverlayVisible', context: context);

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
      Atom(name: '_HistoryNoteStore.successIconVisible', context: context);

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

  late final _$_HistoryNoteStoreActionController =
      ActionController(name: '_HistoryNoteStore', context: context);

  @override
  void closeLongPressSendList() {
    final _$actionInfo = _$_HistoryNoteStoreActionController.startAction(
        name: '_HistoryNoteStore.closeLongPressSendList');
    try {
      return super.closeLongPressSendList();
    } finally {
      _$_HistoryNoteStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void openLongPressSendList() {
    final _$actionInfo = _$_HistoryNoteStoreActionController.startAction(
        name: '_HistoryNoteStore.openLongPressSendList');
    try {
      return super.openLongPressSendList();
    } finally {
      _$_HistoryNoteStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onEmailSelectionFromLongPressSend(dynamic selection) {
    final _$actionInfo = _$_HistoryNoteStoreActionController.startAction(
        name: '_HistoryNoteStore.onEmailSelectionFromLongPressSend');
    try {
      return super.onEmailSelectionFromLongPressSend(selection);
    } finally {
      _$_HistoryNoteStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onLongPressSendAnimationEnd() {
    final _$actionInfo = _$_HistoryNoteStoreActionController.startAction(
        name: '_HistoryNoteStore.onLongPressSendAnimationEnd');
    try {
      return super.onLongPressSendAnimationEnd();
    } finally {
      _$_HistoryNoteStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void showSuccessIcon() {
    final _$actionInfo = _$_HistoryNoteStoreActionController.startAction(
        name: '_HistoryNoteStore.showSuccessIcon');
    try {
      return super.showSuccessIcon();
    } finally {
      _$_HistoryNoteStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void onSuccessIconAnimationEnd() {
    final _$actionInfo = _$_HistoryNoteStoreActionController.startAction(
        name: '_HistoryNoteStore.onSuccessIconAnimationEnd');
    try {
      return super.onSuccessIconAnimationEnd();
    } finally {
      _$_HistoryNoteStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
selectedEmail: ${selectedEmail},
emails: ${emails},
longPressSendListVisible: ${longPressSendListVisible},
longPressSendListInteractable: ${longPressSendListInteractable},
successOverlayVisible: ${successOverlayVisible},
successIconVisible: ${successIconVisible}
    ''';
  }
}
