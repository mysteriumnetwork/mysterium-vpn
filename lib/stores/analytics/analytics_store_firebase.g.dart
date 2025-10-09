// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_store_firebase.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AnalyticsStoreFirebase on _AnalyticsStoreFirebase, Store {
  late final _$logMessageAsyncAction =
      AsyncAction('_AnalyticsStoreFirebase.logMessage', context: context);

  @override
  Future<void> logMessage(String message) {
    return _$logMessageAsyncAction.run(() => super.logMessage(message));
  }

  late final _$logEventAsyncAction =
      AsyncAction('_AnalyticsStoreFirebase.logEvent', context: context);

  @override
  Future<void> logEvent(AnalyticsEvent event, {Map<String, dynamic>? parameters}) {
    return _$logEventAsyncAction.run(() => super.logEvent(event, parameters: parameters));
  }

  late final _$setUserIdAsyncAction =
      AsyncAction('_AnalyticsStoreFirebase.setUserId', context: context);

  @override
  Future<void> setUserId(String id) {
    return _$setUserIdAsyncAction.run(() => super.setUserId(id));
  }

  late final _$setUserPropertyAsyncAction =
      AsyncAction('_AnalyticsStoreFirebase.setUserProperty', context: context);

  @override
  Future<void> setUserProperty({required String propertyName, required String propertyValue}) {
    return _$setUserPropertyAsyncAction
        .run(() => super.setUserProperty(propertyName: propertyName, propertyValue: propertyValue));
  }

  late final _$setLoginAsyncAction =
      AsyncAction('_AnalyticsStoreFirebase.setLogin', context: context);

  @override
  Future<void> setLogin([GrantType loginMethod = GrantType.email]) {
    return _$setLoginAsyncAction.run(() => super.setLogin(loginMethod));
  }

  late final _$logScreenViewedAsyncAction =
      AsyncAction('_AnalyticsStoreFirebase.logScreenViewed', context: context);

  @override
  Future<void> logScreenViewed(String screenName) {
    return _$logScreenViewedAsyncAction.run(() => super.logScreenViewed(screenName));
  }

  late final _$setConsentsAsyncAction =
      AsyncAction('_AnalyticsStoreFirebase.setConsents', context: context);

  @override
  Future<void> setConsents() {
    return _$setConsentsAsyncAction.run(() => super.setConsents());
  }

  late final _$setDeviceInfoAsyncAction =
      AsyncAction('_AnalyticsStoreFirebase.setDeviceInfo', context: context);

  @override
  Future<void> setDeviceInfo() {
    return _$setDeviceInfoAsyncAction.run(() => super.setDeviceInfo());
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
