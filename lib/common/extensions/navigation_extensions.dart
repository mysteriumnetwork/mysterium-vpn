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
    final authenticatedRoutes = {
      '/subscribe': () => showSubscriptionPlansModalPage(context),
      '/subscription-upgrade': () => showSubscriptionUpgradeModalPage(context),
    };

    if (authenticatedRoutes.containsKey(url)) {
      if (!isAuthenticated) {
        return;
      }
      authenticatedRoutes[url]!.call();
      return;
    }

    final tab = HomeTab.fromPath(url);
    if (tab != null) {
      final tabsStore = ProviderScope.containerOf(context, listen: false).read(homeTabsStorePOD);
      if (!tabsStore.trySelect(tab)) {
        // Auth-gated tab (e.g. Products) hit while unauthenticated — kick
        // the user to the login route so they can come back to the tab.
        beamToNamed(Routes.platformLogin.path);
        return;
      }
      // Beam to /main only when the user isn't already there — re-beaming
      // the current location pushes onto Beamer's history and rebuilds the
      // home shell. When already on /main the scaffold's MobX [Observer]
      // picks up the tab change via [trySelect] without a route swap.
      if (configuration.uri.path != Routes.main.path) {
        beamToNamed(Routes.main.path);
      }
      return;
    }

    final route = Routes.values.firstWhereOrNull((it) => it.name == url || it.path == url);
    if (route != null) {
      beamToNamed(route.path);
      return;
    }

    final uri = Uri.tryParse(url);

    if (uri == null) {
      return;
    }

    // Only open if it's a valid HTTP(S) URL
    if (uri.scheme != 'http' && uri.scheme != 'https') {
      return;
    }
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

    await openUrlLink(httpsUri);
  }
}
