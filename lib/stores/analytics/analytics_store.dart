import 'package:flutter/widgets.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/location.dart';

abstract class AnalyticsStore {
  Future<void> logError({
    required Object err,
    StackTrace? stack,
    Object? reason,
    bool fatal = false,
  });
  List<NavigatorObserver> navigationObservers();
  Future<void> logEvent(
    AnalyticsEvent event, {
    Map<String, dynamic>? parameters,
  });
  Future<void> setUserId(String id);
  Future<void> setUserProperty(String name, String value);
  Future<void> setScreenName(String name);
  Future<void> setSessionTimeoutDuration();
  Future<void> setLogin([GrantType loginMethod = GrantType.email]);
  Future<void> setSearchEvent(String searchTerm);
  Future<void> logMessage(String message);
  Future<void> logScreenViewed(String screenName);
  Future<void> logLocationsListScroll();
  Future<void> logThemeChange(String themeMode);
  Future<void> logLanguageChange(String language);
  Future<void> setConsents();
  Future<void> logProductSelected(String productId, List<String> productIds);
  Future<void> logBannerClose(BannerType banner);
  Future<void> logBannerClick(BannerType banner);
  Future<void> logLocationTabOpen(IPType locationType);
  Future<void> logConnect(VPNLocation? location, [AnalyticsEvent? event]);
  Future<void> logDisconnect(VPNLocation? location, [AnalyticsEvent? event]);
  Future<void> logConnectSuccess({
    required VPNLocation location,
    required Duration time,
    required bool? isRefresh,
  });
  Future<void> logConnectFailure({
    required Duration time,
    required String error,
    required String errorType,
    int? errorCode,
    String? errorMessage,
  });
}
