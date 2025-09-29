// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$HomeStore on _HomeStore, Store {
  late final _$errorCapturedAtom =
      Atom(name: '_HomeStore.errorCaptured', context: context);

  @override
  bool get errorCaptured {
    _$errorCapturedAtom.reportRead();
    return super.errorCaptured;
  }

  @override
  set errorCaptured(bool value) {
    _$errorCapturedAtom.reportWrite(value, super.errorCaptured, () {
      super.errorCaptured = value;
    });
  }

  @override
  String toString() {
    return '''
errorCaptured: ${errorCaptured}
    ''';
  }
}
