import 'package:beamer/beamer.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/pages/subscription_plans_modal_page.dart';

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
  Future<void> navigateToUrl(String url, BuildContext context) async {
    if (url == '/subscribe') {
      showSubscriptionPlansModalPage(context);
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

    openUrlLink(uri);
  }
}
