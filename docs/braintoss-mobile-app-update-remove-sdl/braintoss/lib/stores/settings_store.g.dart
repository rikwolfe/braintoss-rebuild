// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$SettingsStore on _SettingsStore, Store {
  late final _$emailsAtom =
      Atom(name: '_SettingsStore.emails', context: context);

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

  late final _$defaultEmailAtom =
      Atom(name: '_SettingsStore.defaultEmail', context: context);

  @override
  Email get defaultEmail {
    _$defaultEmailAtom.reportRead();
    return super.defaultEmail;
  }

  bool _defaultEmailIsInitialized = false;

  @override
  set defaultEmail(Email value) {
    _$defaultEmailAtom.reportWrite(
        value, _defaultEmailIsInitialized ? super.defaultEmail : null, () {
      super.defaultEmail = value;
      _defaultEmailIsInitialized = true;
    });
  }

  late final _$isSoundSwitchedAtom =
      Atom(name: '_SettingsStore.isSoundSwitched', context: context);

  @override
  bool get isSoundSwitched {
    _$isSoundSwitchedAtom.reportRead();
    return super.isSoundSwitched;
  }

  @override
  set isSoundSwitched(bool value) {
    _$isSoundSwitchedAtom.reportWrite(value, super.isSoundSwitched, () {
      super.isSoundSwitched = value;
    });
  }

  late final _$isVibrationSwitchedAtom =
      Atom(name: '_SettingsStore.isVibrationSwitched', context: context);

  @override
  bool get isVibrationSwitched {
    _$isVibrationSwitchedAtom.reportRead();
    return super.isVibrationSwitched;
  }

  @override
  set isVibrationSwitched(bool value) {
    _$isVibrationSwitchedAtom.reportWrite(value, super.isVibrationSwitched, () {
      super.isVibrationSwitched = value;
    });
  }

  late final _$isProximitySwitchedAtom =
      Atom(name: '_SettingsStore.isProximitySwitched', context: context);

  @override
  bool get isProximitySwitched {
    _$isProximitySwitchedAtom.reportRead();
    return super.isProximitySwitched;
  }

  @override
  set isProximitySwitched(bool value) {
    _$isProximitySwitchedAtom.reportWrite(value, super.isProximitySwitched, () {
      super.isProximitySwitched = value;
    });
  }

  late final _$_SettingsStoreActionController =
      ActionController(name: '_SettingsStore', context: context);

  @override
  void handleSwitchToggle(String switchText, bool value) {
    final _$actionInfo = _$_SettingsStoreActionController.startAction(
        name: '_SettingsStore.handleSwitchToggle');
    try {
      return super.handleSwitchToggle(switchText, value);
    } finally {
      _$_SettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void addEmail(Email email) {
    final _$actionInfo = _$_SettingsStoreActionController.startAction(
        name: '_SettingsStore.addEmail');
    try {
      return super.addEmail(email);
    } finally {
      _$_SettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void editEmail(Email newMail) {
    final _$actionInfo = _$_SettingsStoreActionController.startAction(
        name: '_SettingsStore.editEmail');
    try {
      return super.editEmail(newMail);
    } finally {
      _$_SettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void editCellEmail(Email newMail, Email oldMail) {
    final _$actionInfo = _$_SettingsStoreActionController.startAction(
        name: '_SettingsStore.editCellEmail');
    try {
      return super.editCellEmail(newMail, oldMail);
    } finally {
      _$_SettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getEmailList() {
    final _$actionInfo = _$_SettingsStoreActionController.startAction(
        name: '_SettingsStore.getEmailList');
    try {
      return super.getEmailList();
    } finally {
      _$_SettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void saveEmailList(List<Email> emails) {
    final _$actionInfo = _$_SettingsStoreActionController.startAction(
        name: '_SettingsStore.saveEmailList');
    try {
      return super.saveEmailList(emails);
    } finally {
      _$_SettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool duplicateEmail(String newEmail) {
    final _$actionInfo = _$_SettingsStoreActionController.startAction(
        name: '_SettingsStore.duplicateEmail');
    try {
      return super.duplicateEmail(newEmail);
    } finally {
      _$_SettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  bool duplicateAlias(String alias) {
    final _$actionInfo = _$_SettingsStoreActionController.startAction(
        name: '_SettingsStore.duplicateAlias');
    try {
      return super.duplicateAlias(alias);
    } finally {
      _$_SettingsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
emails: ${emails},
defaultEmail: ${defaultEmail},
isSoundSwitched: ${isSoundSwitched},
isVibrationSwitched: ${isVibrationSwitched},
isProximitySwitched: ${isProximitySwitched}
    ''';
  }
}
