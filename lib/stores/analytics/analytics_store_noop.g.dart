// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_store_noop.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$AnalyticsStoreNoop on _AnalyticsStoreNoop, Store {
  late final _$logEventAsyncAction = AsyncAction('_AnalyticsStoreNoop.logEvent', context: context);

  @override
  Future<void> logEvent(AnalyticsEvent event, {Map<String, dynamic>? parameters}) {
    return _$logEventAsyncAction.run(() => super.logEvent(event, parameters: parameters));
  }

  late final _$setUserIdAsyncAction =
      AsyncAction('_AnalyticsStoreNoop.setUserId', context: context);

  @override
  Future<void> setUserId(String id) {
    return _$setUserIdAsyncAction.run(() => super.setUserId(id));
  }

  late final _$setUserPropertyAsyncAction =
      AsyncAction('_AnalyticsStoreNoop.setUserProperty', context: context);

  @override
  Future<void> setUserProperty(String name, String value) {
    return _$setUserPropertyAsyncAction.run(() => super.setUserProperty(name, value));
  }

  late final _$setScreenNameAsyncAction =
      AsyncAction('_AnalyticsStoreNoop.setScreenName', context: context);

  @override
  Future<void> setScreenName(String name) {
    return _$setScreenNameAsyncAction.run(() => super.setScreenName(name));
  }

  late final _$setSessionTimeoutDurationAsyncAction =
      AsyncAction('_AnalyticsStoreNoop.setSessionTimeoutDuration', context: context);

  @override
  Future<void> setSessionTimeoutDuration() {
    return _$setSessionTimeoutDurationAsyncAction.run(() => super.setSessionTimeoutDuration());
  }

  late final _$setLoginAsyncAction = AsyncAction('_AnalyticsStoreNoop.setLogin', context: context);

  @override
  Future<void> setLogin([GrantType loginMethod = GrantType.email]) {
    return _$setLoginAsyncAction.run(() => super.setLogin(loginMethod));
  }

  late final _$setSearchEventAsyncAction =
      AsyncAction('_AnalyticsStoreNoop.setSearchEvent', context: context);

  @override
  Future<void> setSearchEvent(String searchTerm) {
    return _$setSearchEventAsyncAction.run(() => super.setSearchEvent(searchTerm));
  }

  late final _$logMessageAsyncAction =
      AsyncAction('_AnalyticsStoreNoop.logMessage', context: context);

  @override
  Future<void> logMessage(String message) {
    return _$logMessageAsyncAction.run(() => super.logMessage(message));
  }

  late final _$logScreenViewedAsyncAction =
      AsyncAction('_AnalyticsStoreNoop.logScreenViewed', context: context);

  @override
  Future<void> logScreenViewed(String screenName) {
    return _$logScreenViewedAsyncAction.run(() => super.logScreenViewed(screenName));
  }

  late final _$logLocationsListScrollAsyncAction =
      AsyncAction('_AnalyticsStoreNoop.logLocationsListScroll', context: context);

  @override
  Future<void> logLocationsListScroll() {
    return _$logLocationsListScrollAsyncAction.run(() => super.logLocationsListScroll());
  }

  late final _$logThemeChangeAsyncAction =
      AsyncAction('_AnalyticsStoreNoop.logThemeChange', context: context);

  @override
  Future<void> logThemeChange(String themeMode) {
    return _$logThemeChangeAsyncAction.run(() => super.logThemeChange(themeMode));
  }

  late final _$logLanguageChangeAsyncAction =
      AsyncAction('_AnalyticsStoreNoop.logLanguageChange', context: context);

  @override
  Future<void> logLanguageChange(String language) {
    return _$logLanguageChangeAsyncAction.run(() => super.logLanguageChange(language));
  }

  late final _$setConsentsAsyncAction =
      AsyncAction('_AnalyticsStoreNoop.setConsents', context: context);

  @override
  Future<void> setConsents() {
    return _$setConsentsAsyncAction.run(() => super.setConsents());
  }

  late final _$logProductSelectedAsyncAction =
      AsyncAction('_AnalyticsStoreNoop.logProductSelected', context: context);

  @override
  Future<void> logProductSelected(String productId, List<String> productIds) {
    return _$logProductSelectedAsyncAction
        .run(() => super.logProductSelected(productId, productIds));
  }

  late final _$logBannerClickAsyncAction =
      AsyncAction('_AnalyticsStoreNoop.logBannerClick', context: context);

  @override
  Future<void> logBannerClick(BannerType banner) {
    return _$logBannerClickAsyncAction.run(() => super.logBannerClick(banner));
  }

  late final _$logBannerCloseAsyncAction =
      AsyncAction('_AnalyticsStoreNoop.logBannerClose', context: context);

  @override
  Future<void> logBannerClose(BannerType banner) {
    return _$logBannerCloseAsyncAction.run(() => super.logBannerClose(banner));
  }

  late final _$logLocationTabOpenAsyncAction =
      AsyncAction('_AnalyticsStoreNoop.logLocationTabOpen', context: context);

  @override
  Future<void> logLocationTabOpen(IPType locationType) {
    return _$logLocationTabOpenAsyncAction.run(() => super.logLocationTabOpen(locationType));
  }

  late final _$logConnectAsyncAction =
      AsyncAction('_AnalyticsStoreNoop.logConnect', context: context);

  @override
  Future<void> logConnect(VPNLocation? location, [AnalyticsEvent? event]) {
    return _$logConnectAsyncAction.run(() => super.logConnect(location, event));
  }

  late final _$logDisconnectAsyncAction =
      AsyncAction('_AnalyticsStoreNoop.logDisconnect', context: context);

  @override
  Future<void> logDisconnect(VPNLocation? location, [AnalyticsEvent? event]) {
    return _$logDisconnectAsyncAction.run(() => super.logDisconnect(location, event));
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
