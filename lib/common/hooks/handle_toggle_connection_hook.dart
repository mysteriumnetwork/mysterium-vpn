import 'dart:async';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/hooks/handle_subscribe_hook.dart';
import 'package:mysterium_vpn/common/hooks/provider_hook.dart';
import 'package:mysterium_vpn/common/hooks/subscription_active_hook.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

FutureOr<void> Function({
  String? location,
  bool? refreshIP,
  bool isRetrying,
}) useHandleToggleConnection() {
  final subscriptionActive = useSubscriptionActive();
  final handleSubscribe = useHandleSubscribe();
  final vpnStore = useProvider(vpnStorePOD);

  return useCallback(
    ({
      String? location,
      bool? refreshIP,
      bool isRetrying = false,
    }) async {
      if (!subscriptionActive) {
        handleSubscribe();
        return;
      }
      await vpnStore.toggleConnection(
        location: location,
        refreshIP: refreshIP,
        isRetrying: isRetrying,
      );
    },
    [handleSubscribe, subscriptionActive, vpnStore],
  );
}
