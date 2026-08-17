import 'package:flutter/foundation.dart';
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

  @protected
  SubscriptionStore get subscriptionStore => _subscriptionStore;

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
      } else if (subscription.paused ?? false) {
        throw const SubscriptionPausedException();
      }
    } catch (e) {
      if (e is! SubscriptionRequiredException && e is! SubscriptionPausedException) {
        _subscriptionStore.refreshSubscription();
      }
      rethrow;
    }
  }
}
