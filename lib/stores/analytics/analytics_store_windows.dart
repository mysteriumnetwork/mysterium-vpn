import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/observers/navigator_observer.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/stores/analytics/constants.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'analytics_store_windows.g.dart';

// ignore: library_private_types_in_public_api
class AnalyticsStoreWindows = _AnalyticsStoreWindows with _$AnalyticsStoreWindows;

abstract class _AnalyticsStoreWindows with AnalyticsStore, Store {
  _AnalyticsStoreWindows({
    required String measurementId,
    required String apiSecret,
    required DeviceIDStore deviceIDStore,
  })  : _deviceIDStore = deviceIDStore,
        _session = AnalyticsSession(measurementId, apiSecret) {
    logAppLaunchEvent();
    setDeviceInfo();
  }

  final AnalyticsSession _session;
  final DeviceIDStore _deviceIDStore;

  @override
  Future<void> logError({
    required Object err,
    StackTrace? stack,
    Object? reason,
    bool fatal = false,
  }) async {}

  @override
  List<NavigatorObserver> navigationObservers() => [
        WindowsAnalyticsObserver(ambilytics: _session),
        MystNavigationObserver(analyticsStore: this),
      ];

  @override
  @action
  Future<void> logEvent(
    AnalyticsEvent event, {
    Map<String, dynamic>? parameters,
  }) async {
    _session.logEvent(event.formattedName, parameters);
    super.logEvent(event, parameters: parameters).ignore();
  }

  @override
  @action
  Future<void> setUserId(String id) async {
    _session.userId = id;
  }

  @override
  @action
  Future<void> setUserProperty(
    AnalyticsUserProperty property,
  ) async {
    _session.userProperties[property.name24chars] = {
      'value': property.value36chars,
      'timestamp_micros': DateTime.now().microsecondsSinceEpoch,
    };
    super
        .setUserProperty(
          property,
        )
        .ignore();
  }

  @override
  @action
  Future<void> setLogin([GrantType loginMethod = GrantType.email]) async {}

  @override
  @action
  Future<void> logMessage(String message) async {}

  @override
  @action
  Future<void> logScreenViewed(String screenName) async {
    _session.logEvent(screenName);
    super.logScreenViewed(screenName).ignore();
  }

  @override
  @action
  Future<void> setConsents() async {}

  @override
  @action
  Future<void> setDeviceInfo() async {
    try {
      final deviceId = await _deviceIDStore.deviceIdFuture;
      if (kDebugMode) {
        debugPrint('Device ID: $deviceId');
        debugPrint('Device name: ${Env.deviceName}');
        debugPrint('Device model: ${Env.deviceModel}');
      }
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

class AnalyticsSession {
  AnalyticsSession(
    this.measurementId,
    this.apiSecret,
  ) {
    _sessionId = sessionStarted.toIso8601String();
  }

  final String measurementId;
  final String apiSecret;
  String? userId;
  Map<String, dynamic> userProperties = {};

  final DateTime sessionStarted = DateTime.now().toUtc();

  String get sessionId => _sessionId;
  String _sessionId = '';

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://www.google-analytics.com',
      headers: {
        'Content-Type': 'application/json',
        'Accepted-Language': PlatformDispatcher.instance.locale.toLanguageTag(),
      },
    ),
  );

  Future<void> logEvent(
    String eventName, [
    Map<String, Object?>? params,
  ]) async {
    assert(
      !reservedGa4Events.contains(eventName),
      'Event name $eventName is reserved by GA4',
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

    final defParams = <String, Object?>{
      'engagement_time_msec': DateTime.now().toUtc().difference(sessionStarted).inMilliseconds,
      'session_id': sessionId,
    };
    if (params != null) {
      defParams.addAll(params);
    }

    final body = jsonEncode({
      'client_id': defaultTargetPlatform.name,
      'user_id': userId,
      'user_properties': userProperties,
      'events': [
        {'name': eventName.truncate(40), 'params': defParams},
      ],
    });

    try {
      await dio.post(
        '/mp/collect?measurement_id=$measurementId&api_secret=$apiSecret',
        data: body,
      );
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}

/// Filter out non PageRoute ones
bool defaultRouteFilter(Route<dynamic>? route) => route is PageRoute;

/// Accepts any routes, e.g. the ones added via showDialog()
bool anyRouteFilter(Route<dynamic>? route) => true;

String? defaultNameExtractor(RouteSettings settings) => settings.name;

class WindowsAnalyticsObserver extends RouteObserver<ModalRoute<dynamic>> {
  WindowsAnalyticsObserver({
    required this.ambilytics,
    this.nameExtractor = defaultNameExtractor,
    this.routeFilter = defaultRouteFilter,
    this.alwaySendScreenViewCust = false,
  });

  final ScreenNameExtractor nameExtractor;
  final RouteFilter routeFilter;
  final bool alwaySendScreenViewCust;
  void Function(PlatformException error)? onError;
  AnalyticsSession ambilytics;

  void _sendScreenView(Route<dynamic> route) {
    assert(route.settings.name != null, 'Route name cannot be null');
    if (route.settings.name == null) {
      {
        return;
      }
    }

    final name = route.settings.name!;

    ambilytics.logEvent(PredefinedEvents.screenViewCust, {'screen_name': name});
  }

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);

    if (routeFilter(route)) {
      _sendScreenView(route);
    }
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);

    if (newRoute != null && routeFilter(newRoute)) {
      _sendScreenView(newRoute);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);

    if (previousRoute != null && routeFilter(previousRoute) && routeFilter(route)) {
      _sendScreenView(previousRoute);
    }
  }
}
