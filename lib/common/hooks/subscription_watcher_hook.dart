import 'package:flutter/widgets.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';

void useSubscriptionWatcher() {
  final authSessionStore = useProvider<AuthSessionStore>(authSessionStorePOD);
  final subscriptionStore = useProvider<SubscriptionStore>(subscriptionStorePOD);

  useReaction(() => authSessionStore.status, (_) {
    if (!authSessionStore.isAuthenticated) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      subscriptionStore.refreshSubscription(force: true);
    });
  });
}
