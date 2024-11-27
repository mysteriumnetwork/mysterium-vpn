import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/observers/navigator_observer.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';

part 'analytics_store_firebase.g.dart';

// ignore: library_private_types_in_public_api
class AnalyticsStoreFirebase = _AnalyticsStoreFirebase with _$AnalyticsStoreFirebase;

abstract class _AnalyticsStoreFirebase extends AnalyticsStore with Store {
  _AnalyticsStoreFirebase({
    required FirebaseAnalytics analytics,
    required FirebaseCrashlytics crashlytics,
    required LocalDBService localDb,
  })  : _analytics = analytics,
        _crashlytics = crashlytics,
        _localDb = localDb {
    setConsents();
  }

  final FirebaseAnalytics _analytics;
  final FirebaseCrashlytics _crashlytics;
  final LocalDBService _localDb;
  Timer? _timer;

  @override
  Future<void> logError({
    required Object err,
    StackTrace? stack,
    Object? reason,
    bool fatal = false,
  }) async {
    _crashlytics.recordError(
      err,
      stack,
      reason: reason,
      printDetails: true,
      fatal: fatal,
    );
  }

  @override
  List<NavigatorObserver> navigationObservers() => [
        FirebaseAnalyticsObserver(
          analytics: _analytics,
          nameExtractor: (settings) => settings.name,
        ),
        MystNavigationObserver(analyticsStore: this),
      ];

  @override
  @action
  Future<void> logMessage(String message) async {
    _crashlytics.log(message);
  }

  @override
  @action
  Future<void> logEvent(
    AnalyticsEvent event, {
    Map<String, dynamic>? parameters,
  }) async {
    await _analytics.logEvent(name: event.name.toSnakeCase);
  }

  @override
  @action
  Future<void> setUserId(String id) async {
    await Future.wait([
      _analytics.setUserId(id: id),
      _crashlytics.setUserIdentifier(id),
      if (Platform.isIOS) _analytics.initiateOnDeviceConversionMeasurementWithEmailAddress(id),
    ]);
  }

  @override
  @action
  Future<void> setUserProperty(String name, String value) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  @override
  @action
  Future<void> setScreenName(String name) async {
    await _analytics.logScreenView(screenName: name);
  }

  @override
  @action
  Future<void> setSessionTimeoutDuration() async {
    await _analytics.logAppOpen();
  }

  @override
  @action
  Future<void> setLogin([GrantType loginMethod = GrantType.email]) async {
    await _analytics.logLogin(loginMethod: loginMethod.name);
  }

  @override
  @action
  Future<void> setSignUp(
    String userId, [
    GrantType signUpMethod = GrantType.email,
  ]) async {
    if (!_localDb.checkUserExistance(userId)) {
      await _analytics.logSignUp(signUpMethod: signUpMethod.name);
    }
  }

  @override
  @action
  Future<void> setSearchEvent(String searchTerm) async {
    await _analytics.logSearch(searchTerm: searchTerm);
  }

  @override
  @action
  Future<void> logScreenViewed(String screenName) async {
    await _analytics.logEvent(name: screenName);
  }

  @override
  @action
  Future<void> connectToVpn(String countryCode) async {
    await _analytics.logEvent(name: 'connect_$countryCode');
  }

  @override
  @action
  Future<void> disconnectFromVpn(String countryCode) async {
    await _analytics.logEvent(name: 'disconnect_$countryCode');
  }

  @override
  @action
  Future<void> logLocationsListScroll() async {
    if (_timer?.isActive ?? false) {
      _timer?.cancel();
    }
    _timer = Timer(const Duration(milliseconds: 800), () {
      logEvent(AnalyticsEvent.scrollLocations);
    });
  }

  @override
  @action
  Future<void> logThemeChange(String themeMode) async {
    await _analytics.logEvent(name: 'set_theme_$themeMode');
  }

  @override
  @action
  Future<void> logLanguageChange(String language) async {
    await _analytics.logEvent(name: 'set_language_$language');
  }

  Future<void> dispose() async {
    _timer?.cancel();
  }

  @override
  @action
  Future<void> setConsents() async {
    try {
      await _analytics.setConsent(
        adPersonalizationSignalsConsentGranted: true,
        adUserDataConsentGranted: true,
      );
      await _analytics.setAnalyticsCollectionEnabled(true);
    } catch (e) {
      logError(err: e);
    }
  }

  @override
  @action
  Future<void> logProductSelected(String productId, List<String> productIds) async {
    AnalyticsEvent? event;
    if (productId == kAnnualPlan) {
      event = AnalyticsEvent.click1YearPlan;
    } else if (productId == kMonthlyPlan) {
      event = AnalyticsEvent.click1MonthPlan;
    } else if (productId == ksemiAnnualPlan) {
      event = AnalyticsEvent.click6MonthsPlan;
    }
    if (event != null) {
      logEvent(
        event,
        parameters: {
          'item_ids': productIds,
        },
      );
    }
  }
}
