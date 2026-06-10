import 'dart:io';

String getPlatformGateway() {
  if (Platform.isAndroid) {
    return 'google';
  } else if (Platform.isIOS || Platform.isMacOS) {
    return 'apple';
  } else {
    return '';
  }
}

bool isMobilePaymentGateway(String? gateway) {
  final normalized = gateway?.toLowerCase();
  return normalized == 'google' || normalized == 'apple';
}

/// Whether [gateway]'s store can be managed on the given platform: Apple on
/// iOS/macOS, Google on Android. Platform flags are passed in so callers can
/// supply real `Platform.*` values or test overrides.
bool isGatewayOnPlatform(
  String? gateway, {
  required bool isIOS,
  required bool isAndroid,
  required bool isMacOS,
}) => switch (gateway?.toLowerCase()) {
  'apple' => isIOS || isMacOS,
  'google' => isAndroid,
  _ => false,
};

/// Human-readable store name for a mobile gateway, used in messages that
/// direct the user to manage their subscription where it was purchased.
/// Derived from the subscription's gateway, never the current platform.
String storeNameForGateway(String? gateway) => switch (gateway?.toLowerCase()) {
  'apple' => 'Apple App Store',
  'google' => 'Google Play Store',
  _ => '',
};
