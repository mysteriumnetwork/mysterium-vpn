import 'package:flutter/material.dart';
import 'package:mysterium_vpn/stores/stores.dart';

class MystNavigationObserver extends RouteObserver<ModalRoute<dynamic>> {
  MystNavigationObserver({required this.analyticsStore});
  final AnalyticsStore analyticsStore;
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _logScreenName(route.settings);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    if (newRoute != null) {
      _logScreenName(newRoute.settings);
    }
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    if (previousRoute != null) {
      _logScreenName(previousRoute.settings);
    }
  }

  void _logScreenName(RouteSettings settings) {
    try {
      String path;
      if (settings is Page && settings.key is ValueKey<String>) {
        path = convertPathToRoute((settings.key! as ValueKey<String>).value);
      } else if (settings.name != null && settings.name!.isNotEmpty) {
        path = '${settings.name}_screen';
      } else {
        return;
      }

      analyticsStore.logScreenViewed(path);
    } catch (e, s) {
      analyticsStore.logError(err: e, stack: s);
    }
  }

  String convertPathToRoute(String input) => '${input.split('-').join('_')}_screen';
}
