import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/enums/indicator_type.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/utils/debouncer.dart';
import 'package:mysterium_vpn/models/location.dart';

mixin AnalyticsStore {
  final Debouncer _debouncer = Debouncer();

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
  Future<void> setLogin([GrantType loginMethod = GrantType.email]);
  Future<void> setSearchEvent(String searchTerm) =>
      logEvent(AnalyticsEvent.search, parameters: {'search_term': searchTerm});
  Future<void> logMessage(String message);
  Future<void> logScreenViewed(String screenName);

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
    VPNLocation? location, [
    AnalyticsEvent? event,
  ]) async {
    await logEvent(
      AnalyticsEvent.connectToVpn,
      parameters: location != null
          ? {
              'location': location.code,
              'ip_type': location.ipType.name.toSnakeCase,
            }
          : null,
    );
  }

  Future<void> logDisconnect(
    VPNLocation? location, [
    AnalyticsEvent? event,
  ]) async {
    await logEvent(
      AnalyticsEvent.disconnectFromVpn,
      parameters: location != null
          ? {
              'location': location.code,
              'ip_type': location.ipType.name.toSnakeCase,
            }
          : null,
    );
  }

  Future<void> logConnectSuccess({
    required VPNLocation location,
    required Duration time,
    required bool? isRefresh,
  }) async {
    logEvent(
      AnalyticsEvent.connectSuccess,
      parameters: {
        'location': location.code,
        'ipType': location.ipType.name.toSnakeCase,
        'time': time.inSeconds,
        'refresh_ip': isRefresh,
      },
    );
  }

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

  Future<void> logTooltipClick(TooltipType tooltip) async {
    final type = tooltip.name.toSnakeCase;
    logEvent(AnalyticsEvent.tooltipClick, parameters: {'type': type});
  }

  Future<void> logAppLaunchEvent() async {
    final params = {'platform': defaultTargetPlatform.name};
    logEvent(AnalyticsEvent.appLaunch, parameters: params);
  }

  void dispose() {
    _debouncer.dispose();
  }
}
