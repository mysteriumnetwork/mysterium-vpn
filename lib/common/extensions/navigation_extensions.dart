import 'package:beamer/beamer.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/string.dart';
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
  /// Returns whether [url] resolved to a destination. `false` means no
  /// destination was opened and the caller may substitute its own — an
  /// unparseable URI, an authenticated-only route while signed out, News Center
  /// while the feature is killed remotely, or a path matching no route. Callers
  /// that need a fallback (a push notification opening the inbox) branch on
  /// this; the rest ignore it.
  Future<bool> navigateToUrl({
    required String url,
    required bool isAuthenticated,
    required BuildContext context,
    required String? accessToken,
  }) async {
    final uri = Uri.tryParse(url);
    if (uri == null) {
      return false;
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
      return true;
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
        return false;
      }
      authenticatedRoutes[path]!.call();
      return true;
    }

    final tab = HomeTab.fromPath(path);
    if (tab != null) {
      // Mobile-only tabs (Locations) fold into Map on desktop.
      final isDesktop = ScreenType.of(context) >= ScreenType.tablet;
      final targetTab = (tab.mobileOnly && isDesktop) ? HomeTab.map : tab;

      final tabsStore = ProviderScope.containerOf(context, listen: false).read(homeTabsStorePOD);
      if (!tabsStore.trySelect(targetTab)) {
        // Signed out: the login redirect is the outcome. Reporting this as
        // unhandled would stack a fallback destination on top of it.
        beamToNamed(Routes.platformLogin.path);
        return true;
      }
      // Skip re-beam when already on /main; the Observer picks up trySelect.
      if (configuration.uri.path != Routes.main.path) {
        beamToNamed(Routes.main.path);
      }
      return true;
    }

    final route = Routes.values.firstWhereOrNull((it) => it.name == path || it.path == path);
    if (route != null) {
      // Ignore News Center deep links while the feature is killed remotely — a
      // notification must not open a disabled feature.
      if (route == Routes.newsCenter &&
          !ProviderScope.containerOf(
            context,
            listen: false,
          ).read(remoteConfigStorePOD).newsCenterEnabled) {
        return false;
      }
      // Preserve query params (e.g. news-center `?id=`) so the destination page
      // can act on them.
      final query = uri.hasQuery ? '?${uri.query}' : '';
      beamToNamed('${route.path}$query');
      return true;
    }

    return false;
  }

  String _normalizeInAppPath(Uri uri) {
    var path = uri.path;
    if (!path.startsWith('/')) {
      path = '/$path';
    }
    if (path.length > 1 && path.endsWith('/')) {
      path = path.substring(0, path.length - 1);
    }
    return path;
  }
}

/// Routes a tapped notification, falling back to the inbox (News Center) when
/// the target is missing, invalid or unsupported.
///
/// Parsing and validation stay inside [NavigationExtensions.navigateToUrl] —
/// this only reacts to whether it handled the link.
Future<void> openPushNotificationTarget({
  required String? deepLink,
  required BeamerDelegate delegate,
  required BuildContext context,
  required bool isAuthenticated,
  required String? accessToken,
}) async {
  if (deepLink.isNotNullOrEmpty) {
    final handled = await delegate.navigateToUrl(
      url: deepLink!,
      context: context,
      isAuthenticated: isAuthenticated,
      accessToken: accessToken,
    );
    if (handled) {
      return;
    }
  }

  if (!context.mounted) {
    return;
  }
  // navigateToUrl still applies the newsCenterEnabled kill switch, so this is a
  // no-op rather than opening a disabled feature.
  await delegate.navigateToUrl(
    url: Routes.newsCenter.path,
    context: context,
    isAuthenticated: isAuthenticated,
    accessToken: accessToken,
  );
}
