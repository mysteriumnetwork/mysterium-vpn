import 'package:mysterium_vpn/common/enums/enums.dart';

/// Narrow port for handing a URL to the platform, so the data layer can send
/// the user to an external page without depending on the UI helpers.
typedef UrlOpener = Future<bool> Function(Uri url, {required RedirectSource source});
