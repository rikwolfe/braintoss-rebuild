// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quickstart_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$QuickstartStore on _QuickstartStore, Store {
  late final _$selectedQuickstartOptionAtom =
      Atom(name: '_QuickstartStore.selectedQuickstartOption', context: context);

  @override
  String get selectedQuickstartOption {
    _$selectedQuickstartOptionAtom.reportRead();
    return super.selectedQuickstartOption;
  }

  @override
  set selectedQuickstartOption(String value) {
    _$selectedQuickstartOptionAtom
        .reportWrite(value, super.selectedQuickstartOption, () {
      super.selectedQuickstartOption = value;
    });
  }

  late final _$quickstartOptionsAtom =
      Atom(name: '_QuickstartStore.quickstartOptions', context: context);

  @override
  List<QuickstartCheckBox> get quickstartOptions {
    _$quickstartOptionsAtom.reportRead();
    return super.quickstartOptions;
  }

  @override
  set quickstartOptions(List<QuickstartCheckBox> value) {
    _$quickstartOptionsAtom.reportWrite(value, super.quickstartOptions, () {
      super.quickstartOptions = value;
    });
  }

  @override
  String toString() {
    return '''
selectedQuickstartOption: ${selectedQuickstartOption},
quickstartOptions: ${quickstartOptions}
    ''';
  }
}
