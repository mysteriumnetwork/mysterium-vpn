import 'dart:io';

import 'package:mysterium_vpn/common/enums/enums.dart';

bool isDesktop() => Platform.isWindows || Platform.isLinux || Platform.isMacOS;

bool isMobile() => Platform.isAndroid || Platform.isIOS;

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
