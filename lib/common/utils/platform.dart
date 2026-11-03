import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/env.dart';

bool isDesktop() => Platform.isWindows || Platform.isLinux || Platform.isMacOS;

bool isMobile() => Platform.isAndroid || Platform.isIOS;

/// True when an iOS build is running on a host that is not an iPhone or iPad —
/// an Apple Silicon Mac or Vision Pro. Both report [Platform.isIOS].
///
/// Pass [info] in tests; it defaults to the device info loaded at startup.
bool isIosAppOnOtherHost([BaseDeviceInfo? info]) {
  final device = info ?? Env.deviceInfo;
  return device is IosDeviceInfo && (device.isiOSAppOnMac || device.isiOSAppOnVision);
}

/// Whether the device can actually produce haptic feedback.
///
/// Narrower than [isMobile]: neither a Mac nor Vision Pro has a Taptic Engine,
/// so the iOS feedback generators are no-ops there and a setting for them
/// would control nothing.
bool hapticsSupported() => isMobile() && !isIosAppOnOtherHost();

/// Platforms with a push transport. macOS is included: firebase_messaging ships
/// a native macOS implementation and the app already carries the
/// `com.apple.developer.aps-environment` entitlement. Windows and Linux have no
/// FCM support, so they keep the no-op notifications repository.
bool isPushSupported() => Platform.isAndroid || Platform.isIOS || Platform.isMacOS;

/// Windows takes app updates from GitHub rather than a store.
bool isWindowsPlatform() => Platform.isWindows;

/// Which subscription-management flow this platform supports.
SubscriptionManagementMode subscriptionManagementMode() {
  if (Platform.isAndroid) {
    return SubscriptionManagementMode.playStore;
  }
  if (Platform.isIOS || Platform.isMacOS) {
    return SubscriptionManagementMode.appStore;
  }
  return SubscriptionManagementMode.unsupported;
}
