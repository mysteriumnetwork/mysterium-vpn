import 'package:beamer/beamer.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/pages/subscription_plans_modal_page.dart';
import 'package:mysterium_vpn/pages/subscription_upgrade_modal_page.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

extension NavigationExtensions on BeamerDelegate {
  /// Navigates based on the given [url], handling internal routes and external links.
  ///
  /// The [url] is interpreted according to the following rules, in order:
  ///  * `'/subscribe'` &mdash; opens the subscription plans modal using [context].
  ///  * A value matching [Routes.values] or [Routes.path] &mdash; performs internal
  ///    navigation via [beamToNamed] to the corresponding route path.
  ///  * Any other value that can be parsed as a [Uri] and launched by
  ///    `url_launcher` &mdash; is opened as an external URL.
  ///
  /// If [url] cannot be parsed as a [Uri], or if `canLaunchUrl` returns `false`,
  /// the method returns without performing any navigation.
  Future<void> navigateToUrl({
    required String url,
    required bool isAuthenticated,
    required BuildContext context,
    required String? accessToken,
  }) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return;
    }

    if (uri.scheme == 'http' || uri.scheme == 'https') {
      final queryParameters = Map<String, String>.from(uri.queryParameters);
      if (accessToken != null && Env.webAppUrl == uri.host) {
        queryParameters['access_token'] = accessToken;
      }

      final httpsUri = Uri(
        scheme: uri.scheme,
        host: uri.host,
        path: uri.path,
        queryParameters: queryParameters,
      );

      await openUrlLink(httpsUri, source: RedirectSource.external);
      return;
    }

    // Match in-app routes on the URI path so query params, fragments, and a
    // trailing slash don't cause us to silently fall through.
    final path = _normalizeInAppPath(uri);

    final authenticatedRoutes = {
      '/subscribe': () => showSubscriptionPlansModalPage(context),
      '/subscription-upgrade': () => showSubscriptionUpgradeModalPage(context),
    };

    if (authenticatedRoutes.containsKey(path)) {
      if (!isAuthenticated) {
        return;
      }
      authenticatedRoutes[path]!.call();
      return;
    }

    final tab = HomeTab.fromPath(path);
    if (tab != null) {
      // Mobile-only tabs (Locations) fold into Map on desktop.
      final isDesktop = ScreenType.of(context) >= ScreenType.tablet;
      final targetTab = (tab.mobileOnly && isDesktop) ? HomeTab.map : tab;

      final tabsStore = ProviderScope.containerOf(context, listen: false).read(homeTabsStorePOD);
      if (!tabsStore.trySelect(targetTab)) {
        beamToNamed(Routes.platformLogin.path);
        return;
      }
      // Skip re-beam when already on /main; the Observer picks up trySelect.
      if (configuration.uri.path != Routes.main.path) {
        beamToNamed(Routes.main.path);
      }
      return;
    }

    final route = Routes.values.firstWhereOrNull((it) => it.name == path || it.path == path);
    if (route != null) {
      beamToNamed(route.path);
    }
  }

  String _normalizeInAppPath(Uri uri) {
    final path = uri.path;
    if (path.length > 1 && path.endsWith('/')) {
      return path.substring(0, path.length - 1);
    }
    return path;
  }
}
