// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tutorial_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TutorialStore on _TutorialStore, Store {
  late final _$headerTitleAtom =
      Atom(name: '_TutorialStore.headerTitle', context: context);

  @override
  String get headerTitle {
    _$headerTitleAtom.reportRead();
    return super.headerTitle;
  }

  @override
  set headerTitle(String value) {
    _$headerTitleAtom.reportWrite(value, super.headerTitle, () {
      super.headerTitle = value;
    });
  }

  late final _$currentCarouselIndexAtom =
      Atom(name: '_TutorialStore.currentCarouselIndex', context: context);

  @override
  int get currentCarouselIndex {
    _$currentCarouselIndexAtom.reportRead();
    return super.currentCarouselIndex;
  }

  @override
  set currentCarouselIndex(int value) {
    _$currentCarouselIndexAtom.reportWrite(value, super.currentCarouselIndex,
        () {
      super.currentCarouselIndex = value;
    });
  }

  late final _$carouselLengthAtom =
      Atom(name: '_TutorialStore.carouselLength', context: context);

  @override
  int get carouselLength {
    _$carouselLengthAtom.reportRead();
    return super.carouselLength;
  }

  @override
  set carouselLength(int value) {
    _$carouselLengthAtom.reportWrite(value, super.carouselLength, () {
      super.carouselLength = value;
    });
  }

  late final _$isCarouselSwipeDisabledAtom =
      Atom(name: '_TutorialStore.isCarouselSwipeDisabled', context: context);

  @override
  bool get isCarouselSwipeDisabled {
    _$isCarouselSwipeDisabledAtom.reportRead();
    return super.isCarouselSwipeDisabled;
  }

  @override
  set isCarouselSwipeDisabled(bool value) {
    _$isCarouselSwipeDisabledAtom
        .reportWrite(value, super.isCarouselSwipeDisabled, () {
      super.isCarouselSwipeDisabled = value;
    });
  }

  late final _$emailAtom = Atom(name: '_TutorialStore.email', context: context);

  @override
  String get email {
    _$emailAtom.reportRead();
    return super.email;
  }

  @override
  set email(String value) {
    _$emailAtom.reportWrite(value, super.email, () {
      super.email = value;
    });
  }

  late final _$reEnterEmailAtom =
      Atom(name: '_TutorialStore.reEnterEmail', context: context);

  @override
  String get reEnterEmail {
    _$reEnterEmailAtom.reportRead();
    return super.reEnterEmail;
  }

  @override
  set reEnterEmail(String value) {
    _$reEnterEmailAtom.reportWrite(value, super.reEnterEmail, () {
      super.reEnterEmail = value;
    });
  }

  late final _$isEmailValidAtom =
      Atom(name: '_TutorialStore.isEmailValid', context: context);

  @override
  bool get isEmailValid {
    _$isEmailValidAtom.reportRead();
    return super.isEmailValid;
  }

  @override
  set isEmailValid(bool value) {
    _$isEmailValidAtom.reportWrite(value, super.isEmailValid, () {
      super.isEmailValid = value;
    });
  }

  late final _$isReEnteredEmailValidAtom =
      Atom(name: '_TutorialStore.isReEnteredEmailValid', context: context);

  @override
  bool get isReEnteredEmailValid {
    _$isReEnteredEmailValidAtom.reportRead();
    return super.isReEnteredEmailValid;
  }

  @override
  set isReEnteredEmailValid(bool value) {
    _$isReEnteredEmailValidAtom.reportWrite(value, super.isReEnteredEmailValid,
        () {
      super.isReEnteredEmailValid = value;
    });
  }

  late final _$areEmailsMatchingAtom =
      Atom(name: '_TutorialStore.areEmailsMatching', context: context);

  @override
  bool get areEmailsMatching {
    _$areEmailsMatchingAtom.reportRead();
    return super.areEmailsMatching;
  }

  @override
  set areEmailsMatching(bool value) {
    _$areEmailsMatchingAtom.reportWrite(value, super.areEmailsMatching, () {
      super.areEmailsMatching = value;
    });
  }

  late final _$isEmailIconVisibleAtom =
      Atom(name: '_TutorialStore.isEmailIconVisible', context: context);

  @override
  bool get isEmailIconVisible {
    _$isEmailIconVisibleAtom.reportRead();
    return super.isEmailIconVisible;
  }

  @override
  set isEmailIconVisible(bool value) {
    _$isEmailIconVisibleAtom.reportWrite(value, super.isEmailIconVisible, () {
      super.isEmailIconVisible = value;
    });
  }

  late final _$_TutorialStoreActionController =
      ActionController(name: '_TutorialStore', context: context);

  @override
  void getEmail(String newEmail, bool isValid) {
    final _$actionInfo = _$_TutorialStoreActionController.startAction(
        name: '_TutorialStore.getEmail');
    try {
      return super.getEmail(newEmail, isValid);
    } finally {
      _$_TutorialStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void getReEnteredEmail(String newEmail) {
    final _$actionInfo = _$_TutorialStoreActionController.startAction(
        name: '_TutorialStore.getReEnteredEmail');
    try {
      return super.getReEnteredEmail(newEmail);
    } finally {
      _$_TutorialStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCurrentCarouselIndex(int index) {
    final _$actionInfo = _$_TutorialStoreActionController.startAction(
        name: '_TutorialStore.setCurrentCarouselIndex');
    try {
      return super.setCurrentCarouselIndex(index);
    } finally {
      _$_TutorialStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setCarouselLength(int length) {
    final _$actionInfo = _$_TutorialStoreActionController.startAction(
        name: '_TutorialStore.setCarouselLength');
    try {
      return super.setCarouselLength(length);
    } finally {
      _$_TutorialStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void setHeaderTitles() {
    final _$actionInfo = _$_TutorialStoreActionController.startAction(
        name: '_TutorialStore.setHeaderTitles');
    try {
      return super.setHeaderTitles();
    } finally {
      _$_TutorialStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
headerTitle: ${headerTitle},
currentCarouselIndex: ${currentCarouselIndex},
carouselLength: ${carouselLength},
isCarouselSwipeDisabled: ${isCarouselSwipeDisabled},
email: ${email},
reEnterEmail: ${reEnterEmail},
isEmailValid: ${isEmailValid},
isReEnteredEmailValid: ${isReEnteredEmailValid},
areEmailsMatching: ${areEmailsMatching},
isEmailIconVisible: ${isEmailIconVisible}
    ''';
  }
}
