import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/stores.dart';

abstract class VpnGuard {
  VpnGuard({
    required SubscriptionStore subscriptionStore,
    required AuthSessionStore authSessionStore,
  }) : _subscription = subscriptionStore,
       _session = authSessionStore;

  final SubscriptionStore _subscription;
  final AuthSessionStore _session;

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

  /// Throws when the active plan doesn't include [location].
  ///
  /// This is the single gate for every connect surface — lists, map, recents
  /// and favourites all reach the tunnel through here, so none of them can
  /// quietly bypass the plan. Surfaces that can show an upgrade affordance
  /// still check [LocationMode] themselves to avoid a pointless round trip;
  /// this is the backstop for the ones that can't.
  void checkPlanSupportsLocation(VPNLocation? location) {
    if (location != null && !planSupportsLocation(location)) {
      throw const PlanUpgradeRequiredException();
    }
  }

  /// Waits for the subscription config so the plan is known before gating; on
  /// a cold start it is still in flight when the connect begins.
  Future<void> awaitPlanResolution() async {
    try {
      await _subscription.subscriptionConfigFuture;
    } catch (_) {
      // A config that won't load leaves the plan unknown, which gates nothing.
    }
  }

  /// Whether the active plan includes [location].
  ///
  /// An unresolved plan means its features are unknown, not absent — a failed
  /// subscription-config fetch must never block a paying user from connecting.
  bool planSupportsLocation(VPNLocation location) => !LocationMode.isUnsupportedByPlan(
    location: location,
    hasResolvedPlan: _subscription.hasResolvedPlan,
    residentialIPsAllowed: _subscription.residentialIPsAllowed,
    cityLevelAllowed: _subscription.cityLevelAllowed,
  );

  Future<void> checkVpnGuards() async {
    await _session.accessTokenFuture;
    if (!_session.isAuthenticated) {
      throw AuthenticationRequiredException();
    }
    // A loaded entitlement is enough; never wait on a refresh to confirm it.
    // ObservableFuture.replace carries the previous status forward, so a
    // refresh in flight still reads as fulfilled and would be awaited here —
    // blocking the connect for the whole request. On a degraded tunnel that
    // request is slow or failing, which is exactly when the user is pressing
    // Refresh IP to fix it.
    final loaded = _subscription.subscriptionFuture.value;
    if (loaded != null && loaded.grantsVpnAccess) {
      return;
    }

    // The first load has no cached entitlement to fall back on, so wait for it
    // rather than letting an unentitled user through.
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
