import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/models/models.dart';

/// Narrow subscription port for `VpnGuard`, so the repository layer can check
/// entitlement without depending on `SubscriptionStore`.
abstract interface class VpnSubscriptionAccess {
  ObservableFuture<Subscription> get subscriptionFuture;

  Future<Subscription> refreshSubscription({bool force});
}

/// Narrow session port for `VpnGuard`, so the repository layer can check
/// authentication without depending on `AuthSessionStore`.
abstract interface class VpnSessionAccess {
  ObservableFuture<String?> get accessTokenFuture;

  bool get isAuthenticated;
}
