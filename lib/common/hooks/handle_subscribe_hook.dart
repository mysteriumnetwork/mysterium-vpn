part of 'hooks.dart';

void Function() useHandleSubscribe() {
  final context = useContext();

  final authStore = useProvider(authStorePOD);
  final sessionStore = useProvider(authSessionStorePOD);
  final subscriptionStore = useProvider(subscriptionStorePOD);
  final environmentStore = useProvider(environmentPOD);

  final accessToken = useComputedValue(() => sessionStore.accessToken, [authStore]);
  final subscription = useComputedValue(() => subscriptionStore.subscription, [subscriptionStore]);
  final billingPage = useComputedValue(
    () => environmentStore.values.billingPage,
    [environmentStore],
  );

  return useCallback(
    () {
      handleOnBillingPage(
        billingPage: billingPage,
        context: context,
        gateway: subscription?.gateway,
        subscriptionActive: subscription?.active ?? false,
        accessToken: accessToken,
      );
    },
    [billingPage, subscription?.gateway, subscription?.active, accessToken],
  );
}
