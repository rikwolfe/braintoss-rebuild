// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HistoryStore on _HistoryStore, Store {
  late final _$captureListAtom =
      Atom(name: '_HistoryStore.captureList', context: context);

  @override
  ObservableList<Capture> get captureList {
    _$captureListAtom.reportRead();
    return super.captureList;
  }

  @override
  set captureList(ObservableList<Capture> value) {
    _$captureListAtom.reportWrite(value, super.captureList, () {
      super.captureList = value;
    });
  }

  late final _$updatingAtom =
      Atom(name: '_HistoryStore.updating', context: context);

  @override
  bool get updating {
    _$updatingAtom.reportRead();
    return super.updating;
  }

  @override
  set updating(bool value) {
    _$updatingAtom.reportWrite(value, super.updating, () {
      super.updating = value;
    });
  }

  late final _$isDeleteDoneAtom =
      Atom(name: '_HistoryStore.isDeleteDone', context: context);

  @override
  bool get isDeleteDone {
    _$isDeleteDoneAtom.reportRead();
    return super.isDeleteDone;
  }

  @override
  set isDeleteDone(bool value) {
    _$isDeleteDoneAtom.reportWrite(value, super.isDeleteDone, () {
      super.isDeleteDone = value;
    });
  }

  late final _$getAndUpdateCapturesAsyncAction =
      AsyncAction('_HistoryStore.getAndUpdateCaptures', context: context);

  @override
  Future<void> getAndUpdateCaptures() {
    return _$getAndUpdateCapturesAsyncAction
        .run(() => super.getAndUpdateCaptures());
  }

  late final _$updateHistoryOnRefreshAsyncAction =
      AsyncAction('_HistoryStore.updateHistoryOnRefresh', context: context);

  @override
  Future<void> updateHistoryOnRefresh() {
    return _$updateHistoryOnRefreshAsyncAction
        .run(() => super.updateHistoryOnRefresh());
  }

  late final _$deleteHistoryAsyncAction =
      AsyncAction('_HistoryStore.deleteHistory', context: context);

  @override
  Future<void> deleteHistory() {
    return _$deleteHistoryAsyncAction.run(() => super.deleteHistory());
  }

  late final _$_HistoryStoreActionController =
      ActionController(name: '_HistoryStore', context: context);

  @override
  void renderCaptureEntities(List<CaptureEntity> captureEntities) {
    final _$actionInfo = _$_HistoryStoreActionController.startAction(
        name: '_HistoryStore.renderCaptureEntities');
    try {
      return super.renderCaptureEntities(captureEntities);
    } finally {
      _$_HistoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void renderSingleCapture(CaptureEntity captureEntitie) {
    final _$actionInfo = _$_HistoryStoreActionController.startAction(
        name: '_HistoryStore.renderSingleCapture');
    try {
      return super.renderSingleCapture(captureEntitie);
    } finally {
      _$_HistoryStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
captureList: ${captureList},
updating: ${updating},
isDeleteDone: ${isDeleteDone}
    ''';
  }
}
