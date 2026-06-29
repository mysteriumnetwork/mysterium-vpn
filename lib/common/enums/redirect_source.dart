import 'package:mysterium_vpn/common/extensions/extensions.dart';

/// Identifies the in-app origin of an external web redirect, recorded as the
/// `source` property of the `web_redirect` analytics event.
enum RedirectSource {
  manageSubscription,
  upgradeSubscription,
  webCheckout,
  manageDevices,
  login,
  termsOfService,
  privacyPolicy,
  helpSupport,
  appUpdate,
  googlePlaySubscriptions,
  external;

  String get formattedName => name.toSnakeCase;
}
