import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';

part 'analytics_store_noop.g.dart';

// ignore: library_private_types_in_public_api
class AnalyticsStoreNoop = _AnalyticsStoreNoop with _$AnalyticsStoreNoop;

abstract class _AnalyticsStoreNoop extends AnalyticsStore with Store {
  @override
  Future<void> logError({
    required Object err,
    StackTrace? stack,
    Object? reason,
    bool fatal = false,
  }) async {}

  @override
  List<NavigatorObserver> navigationObservers() => [];

  @override
  @action
  Future<void> logEvent(
    AnalyticsEvent event, {
    Map<String, dynamic>? parameters,
  }) async {}

  @override
  @action
  Future<void> setUserId(String id) async {}

  @override
  @action
  Future<void> setUserProperty(String name, String value) async {}

  @override
  @action
  Future<void> setScreenName(String name) async {}

  @override
  @action
  Future<void> setSessionTimeoutDuration() async {}

  @override
  @action
  Future<void> setLogin([GrantType loginMethod = GrantType.email]) async {}

  @override
  @action
  Future<void> setSearchEvent(String searchTerm) async {}

  @override
  @action
  Future<void> logMessage(String message) async {}

  @override
  @action
  Future<void> logScreenViewed(String screenName) async {}

  @override
  @action
  Future<void> connectToVpn(String countryCode) async {}

  @override
  @action
  Future<void> disconnectFromVpn(String countryCode) async {}

  @override
  @action
  Future<void> logLocationsListScroll() async {}

  @override
  @action
  Future<void> logThemeChange(String themeMode) async {}

  @override
  @action
  Future<void> logLanguageChange(String language) async {}

  @override
  @action
  Future<void> setConsents() async {}

  @override
  @action
  Future<void> logProductSelected(String productId, List<String> productIds) async {}
}
