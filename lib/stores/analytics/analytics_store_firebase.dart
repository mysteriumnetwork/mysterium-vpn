import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/enums/indicator_type.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/observers/navigator_observer.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';

part 'analytics_store_firebase.g.dart';

// ignore: library_private_types_in_public_api
class AnalyticsStoreFirebase = _AnalyticsStoreFirebase with _$AnalyticsStoreFirebase;

abstract class _AnalyticsStoreFirebase extends AnalyticsStore with Store {
  _AnalyticsStoreFirebase({
    required FirebaseAnalytics analytics,
    required FirebaseCrashlytics crashlytics,
  })  : _analytics = analytics,
        _crashlytics = crashlytics {
    setConsents();
  }

  final FirebaseAnalytics _analytics;
  final FirebaseCrashlytics _crashlytics;
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
    await _analytics.logEvent(
      name: event.name.toSnakeCase.truncate(40),
      parameters: parameters
          ?.map((key, value) => MapEntry(key.truncate(40), value.toString().truncate(100))),
    );
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
    await _analytics.setUserProperty(
      name: name.truncate(24),
      value: value,
    );
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

  @override
  @action
  Future<void> logBannerClick(BannerType banner) async {
    await logEvent(AnalyticsEvent.bannerClick, parameters: {'banner': banner.name});
  }

  @override
  @action
  Future<void> logBannerClose(BannerType banner) async {
    await logEvent(AnalyticsEvent.bannerClose, parameters: {'banner': banner.name});
  }

  @override
  @action
  Future<void> logLocationTabOpen(IPType locationType) async {
    await logEvent(AnalyticsEvent.locationsTabOpen, parameters: {'ip_type': locationType.name});
  }

  @override
  @action
  Future<void> logConnect(VPNLocation? location, [AnalyticsEvent? event]) async {
    final eventName = event?.name ?? ['connect', location?.code].join('_');
    await _analytics.logEvent(
      name: eventName,
      parameters: location != null
          ? {'location': location.code, 'ip_type': location.ipType.name.toSnakeCase}
          : null,
    );
  }

  @override
  @action
  Future<void> logDisconnect(VPNLocation? location, [AnalyticsEvent? event]) async {
    final eventName = event?.name ?? ['disconnect', location?.code].join('_');
    await _analytics.logEvent(
      name: eventName,
      parameters: location != null
          ? {'location': location.code, 'ip_type': location.ipType.name.toSnakeCase}
          : null,
    );
  }

  @override
  Future<void> logConnectSuccess({
    required VPNLocation location,
    required Duration time,
    required bool? isRefresh,
  }) async {
    await logEvent(
      AnalyticsEvent.connectSuccess,
      parameters: {
        'location': location.code,
        'ipType': location.ipType.name.toSnakeCase,
        'time': time.inSeconds,
        'refresh_ip': isRefresh,
      },
    );
  }

  @override
  Future<void> logConnectFailure({
    required Duration time,
    required String error,
    required String errorType,
    int? errorCode,
    String? errorMessage,
  }) async {
    await logEvent(
      AnalyticsEvent.connectError,
      parameters: {
        'time': time.inSeconds,
        'error': error,
        'error_type': errorType,
        if (errorCode != null) 'error_code': errorCode,
        if (errorMessage != null) 'error_message': errorMessage,
      },
    );
  }

  @override
  Future<void> logTooltipClick(TooltipType tooltip) async {
    final type = tooltip.name.toSnakeCase;
    await logEvent(AnalyticsEvent.tooltipClick, parameters: {'type': type});
  }
}
