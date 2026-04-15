// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_store_windows.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AnalyticsStoreWindows on _AnalyticsStoreWindows, Store {
  late final _$logEventAsyncAction = AsyncAction(
    '_AnalyticsStoreWindows.logEvent',
    context: context,
  );

  @override
  Future<void> logEvent(AnalyticsEvent event, {Map<String, dynamic>? parameters}) {
    return _$logEventAsyncAction.run(() => super.logEvent(event, parameters: parameters));
  }

  late final _$setUserIdAsyncAction = AsyncAction(
    '_AnalyticsStoreWindows.setUserId',
    context: context,
  );

  @override
  Future<void> setUserId(String id) {
    return _$setUserIdAsyncAction.run(() => super.setUserId(id));
  }

  late final _$setUserPropertyAsyncAction = AsyncAction(
    '_AnalyticsStoreWindows.setUserProperty',
    context: context,
  );

  @override
  Future<void> setUserProperty(AnalyticsUserProperty property) {
    return _$setUserPropertyAsyncAction.run(() => super.setUserProperty(property));
  }

  late final _$setLoginAsyncAction = AsyncAction(
    '_AnalyticsStoreWindows.setLogin',
    context: context,
  );

  @override
  Future<void> setLogin([GrantType loginMethod = GrantType.email]) {
    return _$setLoginAsyncAction.run(() => super.setLogin(loginMethod));
  }

  late final _$logMessageAsyncAction = AsyncAction(
    '_AnalyticsStoreWindows.logMessage',
    context: context,
  );

  @override
  Future<void> logMessage(String message) {
    return _$logMessageAsyncAction.run(() => super.logMessage(message));
  }

  late final _$logScreenViewedAsyncAction = AsyncAction(
    '_AnalyticsStoreWindows.logScreenViewed',
    context: context,
  );

  @override
  Future<void> logScreenViewed(String screenName) {
    return _$logScreenViewedAsyncAction.run(() => super.logScreenViewed(screenName));
  }

  late final _$setConsentsAsyncAction = AsyncAction(
    '_AnalyticsStoreWindows.setConsents',
    context: context,
  );

  @override
  Future<void> setConsents() {
    return _$setConsentsAsyncAction.run(() => super.setConsents());
  }

  late final _$setDeviceInfoAsyncAction = AsyncAction(
    '_AnalyticsStoreWindows.setDeviceInfo',
    context: context,
  );

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
