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
  if (gateway == 'google' || gateway == 'apple') {
    return true;
  }
  return false;
}

/// Human-readable store name for a mobile gateway, used in messages that
/// direct the user to manage their subscription where it was purchased.
/// Derived from the subscription's gateway, never the current platform.
String storeNameForGateway(String? gateway) => switch (gateway?.toLowerCase()) {
  'apple' => 'Apple App Store',
  'google' => 'Google Play Store',
  _ => '',
};
