// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_preferences_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$UserPreferencesStore on _UserPreferencesStore, Store {
  Computed<FutureStatus>? _$setMarketingConsentFeatureStatusComputed;

  @override
  FutureStatus get setMarketingConsentFeatureStatus =>
      (_$setMarketingConsentFeatureStatusComputed ??= Computed<FutureStatus>(
              () => super.setMarketingConsentFeatureStatus,
              name: '_UserPreferencesStore.setMarketingConsentFeatureStatus'))
          .value;

  late final _$setMarketingConsentFeatureAtom =
      Atom(name: '_UserPreferencesStore.setMarketingConsentFeature', context: context);

  @override
  ObservableFuture<void> get setMarketingConsentFeature {
    _$setMarketingConsentFeatureAtom.reportRead();
    return super.setMarketingConsentFeature;
  }

  @override
  set setMarketingConsentFeature(ObservableFuture<void> value) {
    _$setMarketingConsentFeatureAtom.reportWrite(value, super.setMarketingConsentFeature, () {
      super.setMarketingConsentFeature = value;
    });
  }

  late final _$getMarketingConsentFeatureAtom =
      Atom(name: '_UserPreferencesStore.getMarketingConsentFeature', context: context);

  @override
  ObservableFuture<void> get getMarketingConsentFeature {
    _$getMarketingConsentFeatureAtom.reportRead();
    return super.getMarketingConsentFeature;
  }

  @override
  set getMarketingConsentFeature(ObservableFuture<void> value) {
    _$getMarketingConsentFeatureAtom.reportWrite(value, super.getMarketingConsentFeature, () {
      super.getMarketingConsentFeature = value;
    });
  }

  late final _$setUserPrefsMarketingConsentAsyncAction =
      AsyncAction('_UserPreferencesStore.setUserPrefsMarketingConsent', context: context);

  @override
  Future<void> setUserPrefsMarketingConsent({required bool consent}) {
    return _$setUserPrefsMarketingConsentAsyncAction
        .run(() => super.setUserPrefsMarketingConsent(consent: consent));
  }

  late final _$getUserPrefsMarketingConsentAsyncAction =
      AsyncAction('_UserPreferencesStore.getUserPrefsMarketingConsent', context: context);

  @override
  Future<void> getUserPrefsMarketingConsent() {
    return _$getUserPrefsMarketingConsentAsyncAction
        .run(() => super.getUserPrefsMarketingConsent());
  }

  @override
  String toString() {
    return '''
setMarketingConsentFeature: ${setMarketingConsentFeature},
getMarketingConsentFeature: ${getMarketingConsentFeature},
setMarketingConsentFeatureStatus: ${setMarketingConsentFeatureStatus}
    ''';
  }
}
