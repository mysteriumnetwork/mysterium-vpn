// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserPreferencesStore on _UserPreferencesStore, Store {
  Computed<bool?>? _$marketingConsentComputed;

  @override
  bool? get marketingConsent =>
      (_$marketingConsentComputed ??= Computed<bool?>(() => super.marketingConsent,
              name: '_UserPreferencesStore.marketingConsent'))
          .value;

  late final _$setMarketingConsentFutureAtom =
      Atom(name: '_UserPreferencesStore.setMarketingConsentFuture', context: context);

  @override
  ObservableFuture<void>? get setMarketingConsentFuture {
    _$setMarketingConsentFutureAtom.reportRead();
    return super.setMarketingConsentFuture;
  }

  @override
  set setMarketingConsentFuture(ObservableFuture<void>? value) {
    _$setMarketingConsentFutureAtom.reportWrite(value, super.setMarketingConsentFuture, () {
      super.setMarketingConsentFuture = value;
    });
  }

  late final _$updateMarketingConsentFutureAtom =
      Atom(name: '_UserPreferencesStore.updateMarketingConsentFuture', context: context);

  @override
  ObservableFuture<void> get updateMarketingConsentFuture {
    _$updateMarketingConsentFutureAtom.reportRead();
    return super.updateMarketingConsentFuture;
  }

  @override
  set updateMarketingConsentFuture(ObservableFuture<void> value) {
    _$updateMarketingConsentFutureAtom.reportWrite(value, super.updateMarketingConsentFuture, () {
      super.updateMarketingConsentFuture = value;
    });
  }

  late final _$getMarketingConsentFutureAtom =
      Atom(name: '_UserPreferencesStore.getMarketingConsentFuture', context: context);

  @override
  ObservableFuture<bool>? get getMarketingConsentFuture {
    _$getMarketingConsentFutureAtom.reportRead();
    return super.getMarketingConsentFuture;
  }

  @override
  set getMarketingConsentFuture(ObservableFuture<bool>? value) {
    _$getMarketingConsentFutureAtom.reportWrite(value, super.getMarketingConsentFuture, () {
      super.getMarketingConsentFuture = value;
    });
  }

  late final _$nextPromptToShowAtom =
      Atom(name: '_UserPreferencesStore.nextPromptToShow', context: context);

  @override
  UserPromptType get nextPromptToShow {
    _$nextPromptToShowAtom.reportRead();
    return super.nextPromptToShow;
  }

  @override
  set nextPromptToShow(UserPromptType value) {
    _$nextPromptToShowAtom.reportWrite(value, super.nextPromptToShow, () {
      super.nextPromptToShow = value;
    });
  }

  late final _$appOpenCountAtom =
      Atom(name: '_UserPreferencesStore.appOpenCount', context: context);

  @override
  int get appOpenCount {
    _$appOpenCountAtom.reportRead();
    return super.appOpenCount;
  }

  @override
  set appOpenCount(int value) {
    _$appOpenCountAtom.reportWrite(value, super.appOpenCount, () {
      super.appOpenCount = value;
    });
  }

  late final _$initStoreAsyncAction =
      AsyncAction('_UserPreferencesStore.initStore', context: context);

  @override
  Future<void> initStore() {
    return _$initStoreAsyncAction.run(() => super.initStore());
  }

  late final _$incrementAppOpenCountAsyncAction =
      AsyncAction('_UserPreferencesStore.incrementAppOpenCount', context: context);

  @override
  Future<void> incrementAppOpenCount() {
    return _$incrementAppOpenCountAsyncAction.run(() => super.incrementAppOpenCount());
  }

  late final _$evaluatePromptToShowAsyncAction =
      AsyncAction('_UserPreferencesStore.evaluatePromptToShow', context: context);

  @override
  @visibleForTesting
  Future<void> evaluatePromptToShow() {
    return _$evaluatePromptToShowAsyncAction.run(() => super.evaluatePromptToShow());
  }

  late final _$shouldShowMarketingConsentAsyncAction =
      AsyncAction('_UserPreferencesStore.shouldShowMarketingConsent', context: context);

  @override
  @visibleForTesting
  Future<bool> shouldShowMarketingConsent() {
    return _$shouldShowMarketingConsentAsyncAction.run(() => super.shouldShowMarketingConsent());
  }

  late final _$setMarketingConsentShownAsyncAction =
      AsyncAction('_UserPreferencesStore.setMarketingConsentShown', context: context);

  @override
  @visibleForTesting
  Future<void> setMarketingConsentShown() {
    return _$setMarketingConsentShownAsyncAction.run(() => super.setMarketingConsentShown());
  }

  late final _$createMarketingContactAsyncAction =
      AsyncAction('_UserPreferencesStore.createMarketingContact', context: context);

  @override
  Future<void> createMarketingContact() {
    return _$createMarketingContactAsyncAction.run(() => super.createMarketingContact());
  }

  late final _$updateMarketingContactAsyncAction =
      AsyncAction('_UserPreferencesStore.updateMarketingContact', context: context);

  @override
  Future<void> updateMarketingContact({required bool consent, bool fromPopup = false}) {
    return _$updateMarketingContactAsyncAction
        .run(() => super.updateMarketingContact(consent: consent, fromPopup: fromPopup));
  }

  late final _$getMarketingConsentAsyncAction =
      AsyncAction('_UserPreferencesStore.getMarketingConsent', context: context);

  @override
  Future<bool> getMarketingConsent() {
    return _$getMarketingConsentAsyncAction.run(() => super.getMarketingConsent());
  }

  @override
  String toString() {
    return '''
setMarketingConsentFuture: ${setMarketingConsentFuture},
updateMarketingConsentFuture: ${updateMarketingConsentFuture},
getMarketingConsentFuture: ${getMarketingConsentFuture},
nextPromptToShow: ${nextPromptToShow},
appOpenCount: ${appOpenCount},
marketingConsent: ${marketingConsent}
    ''';
  }
}
