import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/observers/navigator_observer.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/stores/analytics/constants.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'analytics_store_firebase.g.dart';

// ignore: library_private_types_in_public_api
class AnalyticsStoreFirebase = _AnalyticsStoreFirebase with _$AnalyticsStoreFirebase;

abstract class _AnalyticsStoreFirebase with AnalyticsStore, Store {
  _AnalyticsStoreFirebase({required DeviceIDStore deviceIDStore}) : _deviceIDStore = deviceIDStore;

  // Lazy: dereferencing FirebaseAnalytics.instance before Firebase init
  // throws, so methods below gate on _firebaseReady.
  late final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  late final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  final DeviceIDStore _deviceIDStore;
  final _DeferredFirebaseAnalyticsObserver _deferredObserver = _DeferredFirebaseAnalyticsObserver();
  late final MystNavigationObserver _mystObserver = MystNavigationObserver(analyticsStore: this);

  bool _firebaseReady = false;

  // User-identity calls fired while Firebase was still initializing are
  // buffered here and replayed in [init] so Crashlytics/Analytics can
  // attribute crashes and properties to the correct user.
  String? _pendingUserId;
  final Map<String, AnalyticsUserProperty> _pendingProperties = {};
  GrantType? _pendingLogin;

  /// Called by AppInitializer once Firebase has been initialized. Idempotent
  /// — repeated calls (e.g. during dev hot-restart) are safe no-ops.
  Future<void> init() async {
    if (_firebaseReady || Firebase.apps.isEmpty) {
      return;
    }
    _firebaseReady = true;
    _deferredObserver.attach(
      FirebaseAnalyticsObserver(analytics: _analytics, nameExtractor: (settings) => settings.name),
    );

    final pendingUserId = _pendingUserId;
    _pendingUserId = null;
    if (pendingUserId != null) {
      unawaited(setUserId(pendingUserId));
    }

    final pendingProperties = _pendingProperties.values.toList();
    _pendingProperties.clear();
    for (final property in pendingProperties) {
      unawaited(
        _analytics.setUserProperty(name: property.name24chars, value: property.value36chars),
      );
    }

    final pendingLogin = _pendingLogin;
    _pendingLogin = null;
    if (pendingLogin != null) {
      unawaited(setLogin(pendingLogin));
    }

    // Fire-and-forget: matches the original constructor's behaviour and keeps
    // the splash from waiting on platform-channel round trips.
    unawaited(Future.wait([setConsents(), logAppLaunchEvent(), setDeviceInfo()]));
  }

  @override
  Future<void> logError({
    required Object err,
    StackTrace? stack,
    Object? reason,
    bool fatal = false,
  }) async {
    if (_firebaseReady) {
      await _crashlytics.recordError(err, stack, reason: reason, printDetails: true, fatal: fatal);
    }
    super.logError(err: err, stack: stack, reason: reason, fatal: fatal).ignore();
  }

  @override
  List<NavigatorObserver> navigationObservers() => [_deferredObserver, _mystObserver];

  @override
  @action
  Future<void> logMessage(String message) async {
    if (_firebaseReady) {
      _crashlytics.log(message);
    }
    super.logMessage(message).ignore();
  }

  @override
  @action
  Future<void> logEvent(AnalyticsEvent event, {Map<String, dynamic>? parameters}) async {
    final eventName = event.formattedName;
    assert(!reservedGa4Events.contains(event.name), 'Event name ${event.name} is reserved by GA4');
    if (reservedGa4Events.contains(eventName)) {
      return;
    }
    assert(eventName.length <= 40, 'Event name should be between 1 and 40 characters long');
    assert(
      eventName.isNotEmpty && RegExp(r'^[a-zA-Z][a-zA-Z0-9_]*$').hasMatch(eventName),
      'Event name should start with a letter and contain only letters, numbers, and underscores.',
    );
    if (_firebaseReady) {
      await _analytics.logEvent(
        name: event.name.toSnakeCase.truncate(40),
        parameters: parameters?.map(
          (key, value) => MapEntry(key.truncate(40), value.toString().truncate(100)),
        ),
      );
    }

    super.logEvent(event, parameters: parameters).ignore();
  }

  @override
  @action
  Future<void> setUserId(String id) async {
    if (!_firebaseReady) {
      _pendingUserId = id;
      return;
    }
    await Future.wait([
      _analytics.setUserId(id: id),
      _crashlytics.setUserIdentifier(id),
      if (Platform.isIOS) _analytics.initiateOnDeviceConversionMeasurementWithEmailAddress(id),
    ]);
  }

  @override
  @action
  Future<void> setUserProperty(AnalyticsUserProperty property) async {
    if (_firebaseReady) {
      await _analytics.setUserProperty(name: property.name24chars, value: property.value36chars);
    } else {
      _pendingProperties[property.name24chars] = property;
    }
    super.setUserProperty(property).ignore();
  }

  @override
  @action
  Future<void> setLogin([GrantType loginMethod = GrantType.email]) async {
    if (!_firebaseReady) {
      _pendingLogin = loginMethod;
      return;
    }
    await _analytics.logLogin(loginMethod: loginMethod.name);
  }

  @override
  @action
  Future<void> logScreenViewed(String screenName) async {
    if (_firebaseReady) {
      await _analytics.logEvent(name: screenName);
    }
    super.logScreenViewed(screenName).ignore();
  }

  @override
  @action
  Future<void> setConsents() async {
    if (!_firebaseReady) {
      return;
    }
    try {
      await Future.wait([
        _analytics.setConsent(
          adPersonalizationSignalsConsentGranted: true,
          adUserDataConsentGranted: true,
        ),
        _analytics.setAnalyticsCollectionEnabled(true),
      ]);
    } catch (e) {
      logError(err: e);
    }
  }

  @override
  @action
  Future<void> setDeviceInfo() async {
    try {
      final deviceId = await _deviceIDStore.deviceIdFuture;
      await Future.wait([
        setUserProperty(
          AnalyticsUserProperty.fromEnum(name: AnalyticsUserPropName.deviceId, value: deviceId),
        ),
        setUserProperty(
          AnalyticsUserProperty.fromEnum(
            name: AnalyticsUserPropName.deviceName,
            value: Env.deviceName,
          ),
        ),
        setUserProperty(
          AnalyticsUserProperty.fromEnum(
            name: AnalyticsUserPropName.deviceModel,
            value: Env.deviceModel,
          ),
        ),
        setUserProperty(
          AnalyticsUserProperty.fromEnum(
            name: AnalyticsUserPropName.devicePlatform,
            value: defaultTargetPlatform.name,
          ),
        ),
      ]);
    } catch (e) {
      logError(err: e);
    }
  }
}

/// No-ops until [attach] is called; then forwards to the inner observer.
class _DeferredFirebaseAnalyticsObserver extends NavigatorObserver {
  FirebaseAnalyticsObserver? _inner;

  void attach(FirebaseAnalyticsObserver inner) {
    assert(_inner == null, 'attach called more than once');
    _inner = inner;
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _inner?.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _inner?.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _inner?.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _inner?.didRemove(route, previousRoute);
  }

  @override
  void didChangeTop(Route<dynamic> topRoute, Route<dynamic>? previousTopRoute) {
    _inner?.didChangeTop(topRoute, previousTopRoute);
  }

  @override
  void didStartUserGesture(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _inner?.didStartUserGesture(route, previousRoute);
  }

  @override
  void didStopUserGesture() {
    _inner?.didStopUserGesture();
  }
}
