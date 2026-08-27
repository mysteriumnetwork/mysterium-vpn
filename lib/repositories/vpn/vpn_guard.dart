import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/stores/stores.dart';

abstract class VpnGuard {
  VpnGuard({
    required SubscriptionStore subscriptionStore,
    required AuthSessionStore authSessionStore,
  }) : _subscriptionStore = subscriptionStore,
       _authSessionStore = authSessionStore;

  final SubscriptionStore _subscriptionStore;
  final AuthSessionStore _authSessionStore;

  /// Whether the loaded subscription currently entitles the user to a tunnel.
  /// A not-yet-fulfilled subscription counts as entitled, so a pending fetch
  /// never tears down a live tunnel.
  bool get subscriptionGrantsVpnAccess {
    final future = _subscriptionStore.subscriptionFuture;
    if (future.status != FutureStatus.fulfilled) {
      return true;
    }
    return future.value?.grantsVpnAccess ?? false;
  }

  Future<void> checkVpnGuards() async {
    await _authSessionStore.accessTokenFuture;
    if (!_authSessionStore.isAuthenticated) {
      throw AuthenticationRequiredException();
    }
    if (_subscriptionStore.subscriptionFuture.status == FutureStatus.pending) {
      return;
    }
    try {
      final subscription = await _subscriptionStore.subscriptionFuture;
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
        _subscriptionStore.refreshSubscription();
      }
      rethrow;
    }
  }
}
