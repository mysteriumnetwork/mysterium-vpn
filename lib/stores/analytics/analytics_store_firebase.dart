import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/analytics_user_property.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/observers/navigator_observer.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/analytics/constants.dart';
import 'package:mysterium_vpn/stores/device_id_store.dart';

part 'analytics_store_firebase.g.dart';

// ignore: library_private_types_in_public_api
class AnalyticsStoreFirebase = _AnalyticsStoreFirebase with _$AnalyticsStoreFirebase;

abstract class _AnalyticsStoreFirebase with AnalyticsStore, Store {
  _AnalyticsStoreFirebase({
    required FirebaseAnalytics analytics,
    required FirebaseCrashlytics crashlytics,
    required DeviceIDStore deviceIDStore,
  })  : _analytics = analytics,
        _crashlytics = crashlytics,
        _deviceIDStore = deviceIDStore {
    setConsents();
    logAppLaunchEvent();
    setDeviceInfo();
  }

  final FirebaseAnalytics _analytics;
  final FirebaseCrashlytics _crashlytics;
  final DeviceIDStore _deviceIDStore;

  @override
  Future<void> logError({
    required Object err,
    StackTrace? stack,
    Object? reason,
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(
      err,
      stack,
      reason: reason,
      printDetails: true,
      fatal: fatal,
    );
    super.logError(err: err, stack: stack, reason: reason, fatal: fatal).ignore();
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
    super.logMessage(message).ignore();
  }

  @override
  @action
  Future<void> logEvent(
    AnalyticsEvent event, {
    Map<String, dynamic>? parameters,
  }) async {
    final eventName = event.formattedName;
    assert(
      !reservedGa4Events.contains(event.name),
      'Event name ${event.name} is reserved by GA4',
    );
    if (reservedGa4Events.contains(eventName)) {
      return;
    }
    assert(
      eventName.length <= 40,
      'Event name should be between 1 and 40 characters long',
    );
    assert(
      eventName.isNotEmpty && RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$').hasMatch(eventName),
      'Event name should start with a letter and contain only letters, numbers, and underscores.',
    );
    await _analytics.logEvent(
      name: event.name.toSnakeCase.truncate(40),
      parameters: parameters?.map(
        (key, value) => MapEntry(key.truncate(40), value.toString().truncate(100)),
      ),
    );

    super.logEvent(event, parameters: parameters).ignore();
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
  Future<void> setUserProperty(AnalyticsUserProperty property) async {
    await _analytics.setUserProperty(
      name: property.name24chars,
      value: property.value36chars,
    );
    super
        .setUserProperty(
          property,
        )
        .ignore();
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
    super.logScreenViewed(screenName).ignore();
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
  Future<void> setDeviceInfo() async {
    try {
      final deviceId = await _deviceIDStore.deviceIdFuture;
      await setUserProperty(
        AnalyticsUserProperty.fromEnum(
          name: AnalyticsUserPropName.deviceId,
          value: deviceId,
        ),
      );
      await setUserProperty(
        AnalyticsUserProperty.fromEnum(
          name: AnalyticsUserPropName.deviceName,
          value: Env.deviceName,
        ),
      );
      await setUserProperty(
        AnalyticsUserProperty.fromEnum(
          name: AnalyticsUserPropName.deviceModel,
          value: Env.deviceModel,
        ),
      );
      await setUserProperty(
        AnalyticsUserProperty.fromEnum(
          name: AnalyticsUserPropName.devicePlatform,
          value: defaultTargetPlatform.name,
        ),
      );
    } catch (e) {
      logError(err: e);
    }
  }
}
