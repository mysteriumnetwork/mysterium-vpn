import 'package:beamer/beamer.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/pages/subscription_plans_modal_page.dart';
import 'package:url_launcher/url_launcher.dart';

extension NavigationExtensions on BeamerDelegate {
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

    final canLaunch = await canLaunchUrl(uri);
    if (!canLaunch) {
      return;
    }

    await launchUrl(uri);
  }
}
