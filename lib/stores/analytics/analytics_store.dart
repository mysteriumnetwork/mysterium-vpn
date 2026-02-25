import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/extensions/map_extensions.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:vpn_api/vpn_api.dart';

mixin AnalyticsStore {
  final Debouncer _debouncer = Debouncer();
  final ReplayStreamController<AnalyticsLogEntry> _logStreamController = ReplayStreamController();
  final ReplayStreamController<AnalyticsUserProperty> _userPropertiesStreamController =
      ReplayStreamController();

  Future<void> logError({
    required Object err,
    StackTrace? stack,
    Object? reason,
    bool fatal = false,
  }) async {
    _logStreamController.add(
      AnalyticsLogEntry(
        type: AnalyticsLogType.error,
        message: err.toString(),
        params: {'fatal': fatal},
        timestamp: DateTime.now(),
      ),
    );
  }

  List<NavigatorObserver> navigationObservers();

  Future<void> logEvent(
    AnalyticsEvent event, {
    Map<String, dynamic>? parameters,
  }) async {
    _logStreamController.add(
      AnalyticsLogEntry(
        message: event.formattedName,
        type: AnalyticsLogType.event,
        params: parameters,
        timestamp: DateTime.now(),
      ),
    );
  }

  Future<void> setUserId(String id);

  Future<void> setUserProperty(AnalyticsUserProperty property) async {
    _userPropertiesStreamController.add(
      property,
    );
  }

  Future<void> setLogin([GrantType loginMethod = GrantType.email]);

  Future<void> setSearchEvent(String searchTerm) =>
      logEvent(AnalyticsEvent.search, parameters: {'search_term': searchTerm});

  Future<void> logMessage(String message) async {
    _logStreamController.add(
      AnalyticsLogEntry(
        message: message,
        type: AnalyticsLogType.message,
        timestamp: DateTime.now(),
      ),
    );
  }

  Future<void> logScreenViewed(String screenName) async {
    _logStreamController.add(
      AnalyticsLogEntry(
        message: screenName,
        type: AnalyticsLogType.screenView,
        timestamp: DateTime.now(),
      ),
    );
  }

  Future<void> logLocationsListScroll() async {
    _debouncer.debounce(
      () {
        logEvent(AnalyticsEvent.scrollLocations);
      },
      const Duration(milliseconds: 800),
    );
  }

  Future<void> logThemeChange(String themeMode) async {
    logEvent(AnalyticsEvent.setThemeMode, parameters: {'themeMode': themeMode});
  }

  Future<void> logLanguageChange(String language) async {
    logEvent(
      AnalyticsEvent.setLanguageCode,
      parameters: {'language': language},
    );
  }

  Future<void> setConsents();

  Future<void> logProductSelected(
    String productId,
    List<String> productIds,
  ) async {
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

  Future<void> logBannerClose(BannerType banner) async {
    await logEvent(
      AnalyticsEvent.bannerClose,
      parameters: {'banner': banner.name},
    );
  }

  Future<void> logBannerClick(BannerType banner) async {
    logEvent(AnalyticsEvent.bannerClick, parameters: {'banner': banner.name});
  }

  Future<void> logLocationTabOpen(IPType locationType) async {
    logEvent(
      AnalyticsEvent.locationsTabOpen,
      parameters: {'ip_type': locationType.name},
    );
  }

  Future<void> logConnect(
    VPNLocation? location, {
    AnalyticsEvent? event,
    UserIntent? intent,
  }) async {
    await logEvent(
      AnalyticsEvent.connectToVpn,
      parameters: location != null
          ? {
              'location': location.id,
              'ip_type': location.ipType.name.toSnakeCase,
              if (intent != null) 'user_intent': intent.key,
            }
          : null,
    );
  }

  Future<void> logDisconnect(
    VPNLocation? location, {
    AnalyticsEvent? event,
    UserIntent? intent,
  }) async {
    await logEvent(
      AnalyticsEvent.disconnectFromVpn,
      parameters: location != null
          ? {
              'location': location.id,
              'ip_type': location.ipType.name.toSnakeCase,
              if (intent != null) 'user_intent': intent.key,
            }
          : null,
    );
  }

  Future<void> logConnectSuccess({
    required VPNLocation location,
    required Duration time,
    required bool? isRefresh,
    required ProtocolType protocol,
  }) async {
    logEvent(
      AnalyticsEvent.connectSuccess,
      parameters: {
        'location': location.id,
        'ipType': location.ipType.name.toSnakeCase,
        'time': time.inSeconds,
        'refresh_ip': isRefresh,
        'protocol': protocol.name,
      },
    );
  }

  Future<void> logConnectFailure({
    required Duration time,
    required String error,
    required String errorType,
    required ProtocolType protocol,
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

  Future<void> logTooltipClick(TooltipType tooltip) async {
    final type = tooltip.name.toSnakeCase;
    logEvent(AnalyticsEvent.tooltipClick, parameters: {'type': type});
  }

  Future<void> logAppLaunchEvent() async {
    final params = {'platform': defaultTargetPlatform.name};
    logEvent(AnalyticsEvent.appLaunch, parameters: params);
  }

  Future<void> logPanelMoved(PanelState state) async {
    await logEvent(AnalyticsEvent.panelMoved, parameters: {'state': state.name});
  }

  Future<void> logRefreshIP([String? currentIP]) async {
    await logEvent(
      AnalyticsEvent.refreshIp,
      parameters: currentIP != null ? {'ip': currentIP} : null,
    );
  }

  void dispose() {
    _debouncer.dispose();
    _logStreamController.close();
    _userPropertiesStreamController.close();
  }

  Future<void> logTabChange(IPType type) async {
    await logEvent(
      AnalyticsEvent.locationsTabClick,
      parameters: {'tab': type.name},
    );
  }

  Future<void> setDeviceInfo() async {}

  Future<void> logRateConnnectionClicked(RateConnectionRequestModeEnum mode) async {
    logEvent(
      AnalyticsEvent.rateConnectionClicked,
      parameters: {'mode': mode.name},
    );
  }

  Future<void> logRateConnectionCancel(RateConnectionRequestModeEnum mode) async {
    logEvent(
      AnalyticsEvent.rateConnectionCancel,
      parameters: {'mode': mode.name},
    );
  }

  Future<void> logPaymentSuccess({
    required String productId,
    required String price,
    required String currency,
    required int duration,
  }) async {
    logEvent(
      AnalyticsEvent.paymentVerificationSuccess,
      parameters: {
        'planType': productId,
        'price': price,
        'currency': currency,
        'duration': duration,
      },
    );
    final event = switch (duration) {
      1 => AnalyticsEvent.paymentSuccess1m,
      6 => AnalyticsEvent.paymentSuccess6m,
      12 => AnalyticsEvent.paymentSuccess1y,
      _ => null,
    };
    if (event != null) {
      logEvent(
        event,
        parameters: {
          'planType': productId,
          'price': price,
          'currency': currency,
          'duration': duration,
        },
      );
    }
  }

  Future<void> logSubscriptionCancellationSurvey({
    required Set<String> reasons,
    String? feedback,
  }) async {
    await logEvent(
      AnalyticsEvent.subscriptionCancellationSurvey,
      parameters: {
        'reasons': reasons.join(','),
        if (feedback != null) 'feedback': feedback,
      },
    );
  }

  Future<void> logMapScroll({MapCamera? from, MapCamera? to}) async {
    _debouncer.debounce(
      () => logEvent(
        AnalyticsEvent.mapScroll,
        parameters: {
          ...?from?.toMap().map((key, value) => MapEntry('from_$key', value)),
          ...?to?.toMap().map((key, value) => MapEntry('to_$key', value)),
        },
      ),
      const Duration(milliseconds: 800),
    );
  }

  Future<void> logMapLocationClick(String id, LatLng point) async {
    await logEvent(
      AnalyticsEvent.mapPointClick,
      parameters: {'location': id, 'point': point.toShortString()},
    );
  }

  Future<void> logSubscriptionUpgradeBannerClick() async {
    await logEvent(AnalyticsEvent.subUpgradeBannerClick);
  }

  Future<void> logSubscriptionUpgradePopupShow() async {
    await logEvent(AnalyticsEvent.subUpgradePopupShow);
  }

  Future<void> logSubscriptionUpgradePopupClose() async {
    await logEvent(AnalyticsEvent.subUpgradePopupClose);
  }

  Future<void> logSubscriptionUpgradePopupConfirm() async {
    await logEvent(AnalyticsEvent.subUpgradePopupConfirm);
  }

  Future<void> logSubscriptionUpgradeInfoClick(String url) async {
    await logEvent(
      AnalyticsEvent.subUpgradeInfoClick,
      parameters: {'url': url},
    );
  }

  Future<void> logPushNotificationsPermissionsChanged({required bool permissionsGranted}) async {
    await logEvent(
      permissionsGranted
          ? AnalyticsEvent.pushNotificationsPermissionsGranted
          : AnalyticsEvent.pushNotificationsPermissionsDenied,
      parameters: {'permission': permissionsGranted.toString()},
    );
    await setUserProperty(
      AnalyticsUserProperty.fromEnum(
        name: AnalyticsUserPropName.pnPermissionStatus,
        value: permissionsGranted.toString(),
      ),
    );
  }

  Stream<AnalyticsLogEntry> watchLogs() => _logStreamController.stream;
  Stream<AnalyticsUserProperty> watchUserProperties() => _userPropertiesStreamController.stream;
}

class AnalyticsLogEntry {
  const AnalyticsLogEntry({
    required this.message,
    required this.type,
    required this.timestamp,
    this.params,
  });

  final String message;
  final AnalyticsLogType type;
  final Map<String, Object?>? params;
  final DateTime timestamp;
}

enum AnalyticsLogType { event, screenView, message, error }
