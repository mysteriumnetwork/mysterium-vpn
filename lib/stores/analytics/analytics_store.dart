import 'package:flutter/widgets.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';

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
  Future<void> setSignUp(
    String userId, [
    GrantType signUpMethod = GrantType.email,
  ]);
  Future<void> setSearchEvent(String searchTerm);

  Future<void> logMessage(
    String message,
  );
  Future<void> logScreenViewed(String screenName);
  Future<void> connectToVpn(String countryCode);
  Future<void> disconnectFromVpn(String countryCode);
  Future<void> logLocationsListScroll();
  Future<void> logThemeChange(String themeMode);
  Future<void> logLanguageChange(String language);
}
