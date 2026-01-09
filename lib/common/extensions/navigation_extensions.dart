import 'package:beamer/beamer.dart';
import 'package:collection/collection.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:url_launcher/url_launcher.dart';

extension NavigationExtensions on BeamerDelegate {
  Future<void> navigateToUrl(String url) async {
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
