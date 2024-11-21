import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/hooks/provider_hook.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

void Function() useHandleSubscribe() {
  final context = useContext();
  final authStore = useProvider(authStorePOD);
  final subscriptionStore = useProvider(subscriptionStorePOD);
  final environment = useProvider(environmentPOD);

  final subscriptionActive = subscriptionStore.subscription?.active ?? false;

  return useCallback(
    () {
      handleOnBillingPage(
        billingPage: environment.values.billingPage,
        context: context,
        gateway: subscriptionStore.subscription?.gateway,
        subscriptionActive: subscriptionActive,
        accessToken: authStore.authData?.accessToken,
      );
    },
    [
      environment.values.billingPage,
      subscriptionStore.subscription?.gateway,
      subscriptionActive,
      authStore.authData?.accessToken,
    ],
  );
}
