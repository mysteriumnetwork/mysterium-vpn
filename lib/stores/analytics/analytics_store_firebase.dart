import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/observers/navigator_observer.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';

part 'analytics_store_firebase.g.dart';

// ignore: library_private_types_in_public_api
class AnalyticsStoreFirebase = _AnalyticsStoreFirebase with _$AnalyticsStoreFirebase;

abstract class _AnalyticsStoreFirebase with AnalyticsStore, Store {
  _AnalyticsStoreFirebase({
    required FirebaseAnalytics analytics,
    required FirebaseCrashlytics crashlytics,
  })  : _analytics = analytics,
        _crashlytics = crashlytics {
    setConsents();
  }

  final FirebaseAnalytics _analytics;
  final FirebaseCrashlytics _crashlytics;

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
  Future<void> setLogin([GrantType loginMethod = GrantType.email]) async {
    await _analytics.logLogin(loginMethod: loginMethod.name);
  }

  @override
  @action
  Future<void> logScreenViewed(String screenName) async {
    await _analytics.logEvent(name: screenName);
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
}
