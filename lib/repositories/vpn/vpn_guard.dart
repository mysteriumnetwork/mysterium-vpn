import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/exceptions/exceptions.dart';
import 'package:mysterium_vpn/stores/stores.dart';

abstract class VpnGuard {
  VpnGuard({
    required SubscriptionStore subscriptionStore,
    required AuthSessionStore authSessionStore,
  }) : _subscriptionStore = subscriptionStore,
       _authSessionStore = authSessionStore;
  final SubscriptionStore _subscriptionStore;
  final AuthSessionStore _authSessionStore;

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
      if (!subscription.active) {
        throw const SubscriptionRequiredException();
      }
    } catch (e) {
      if (e is! SubscriptionRequiredException) {
        _subscriptionStore.refreshSubscription();
      }
      rethrow;
    }
  }
}
