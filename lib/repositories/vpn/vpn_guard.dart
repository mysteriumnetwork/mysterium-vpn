import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/repositories/vpn/vpn_access_ports.dart';

abstract class VpnGuard {
  VpnGuard({
    required VpnSubscriptionAccess subscriptionAccess,
    required VpnSessionAccess sessionAccess,
  }) : _subscription = subscriptionAccess,
       _session = sessionAccess;

  final VpnSubscriptionAccess _subscription;
  final VpnSessionAccess _session;

  /// Whether the loaded subscription currently entitles the user to a tunnel.
  /// A not-yet-fulfilled subscription counts as entitled, so a pending fetch
  /// never tears down a live tunnel.
  bool get subscriptionGrantsVpnAccess {
    final future = _subscription.subscriptionFuture;
    if (future.status != FutureStatus.fulfilled) {
      return true;
    }
    return future.value?.grantsVpnAccess ?? false;
  }

  Future<void> checkVpnGuards() async {
    await _session.accessTokenFuture;
    if (!_session.isAuthenticated) {
      throw AuthenticationRequiredException();
    }
    if (_subscription.subscriptionFuture.status == FutureStatus.pending) {
      return;
    }
    try {
      final subscription = await _subscription.subscriptionFuture;
      if (subscription.grantsVpnAccess) {
        return;
      }
      // Entitlement is lost — report the most specific reason so the UI can
      // offer resume rather than a subscribe upsell.
      if (subscription.isPaused) {
        throw const SubscriptionPausedException();
      }
      throw const SubscriptionRequiredException();
    } catch (e) {
      if (e is! SubscriptionRequiredException && e is! SubscriptionPausedException) {
        _subscription.refreshSubscription();
      }
      rethrow;
    }
  }
}
