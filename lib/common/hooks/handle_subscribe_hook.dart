import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/hooks/computed_hook.dart';
import 'package:mysterium_vpn/common/hooks/provider_hook.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

void Function() useHandleSubscribe() {
  final context = useContext();

  final authStore = useProvider(authStorePOD);
  final subscriptionStore = useProvider(subscriptionStorePOD);
  final environmentStore = useProvider(environmentPOD);

  final accessToken = useComputed(() => authStore.authData?.accessToken, [authStore]).value;
  final subscription = useComputed(() => subscriptionStore.subscription, [subscriptionStore]).value;
  final billingPage =
      useComputed(() => environmentStore.values.billingPage, [environmentStore]).value;

  return useCallback(
    () {
      handleOnBillingPage(
        billingPage: billingPage,
        context: context,
        gateway: subscription?.gateway,
        subscriptionActive: subscription?.active ?? false,
        accessToken: authStore.authData?.accessToken,
      );
    },
    [billingPage, subscription?.gateway, subscription?.active, accessToken],
  );
}
