import 'dart:async';

import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/stores/stores.dart';

/// How long logout waits for the tunnel to come down before giving up on it.
/// Deliberately shorter than the delay users notice.
const logoutDisconnectTimeout = Duration(seconds: 2);

/// Tears the tunnel down, then logs out. The teardown is bounded and its
/// failures are swallowed: a hung or failing disconnect must never leave the
/// user unable to sign out.
Future<void> disconnectAndLogout({
  required VpnStore vpnStore,
  required AuthStore authStore,
  required AnalyticsStore analyticsStore,
  Duration timeout = logoutDisconnectTimeout,
}) async {
  try {
    await vpnStore.disconnectTunnel(reason: VpnDisconnectReason.appInitiated).timeout(timeout);
  } catch (e) {
    // Reporting the failure must not delay, or fail, the logout it reports on:
    // logEvent awaits a Firebase platform call.
    unawaited(
      analyticsStore
          .logEvent(
            AnalyticsEvent.logOutDisconnectFailed,
            parameters: {'reason': e is TimeoutException ? 'timeout' : 'error'},
          )
          .catchError((Object _) {}),
    );
  }
  await authStore.logout();
}
