part of 'hooks.dart';

FutureOr<void> Function() useHandleSubscribe() {
  final context = useContext();
  final beamer = Beamer.of(context);

  final sessionStore = useProvider(authSessionStorePOD);
  final subscriptionStore = useProvider(subscriptionStorePOD);
  final environmentStore = useProvider(environmentPOD);

  final accessToken = useComputedValue(() => sessionStore.accessToken, [sessionStore]);
  final subscription = useComputedValue(() => subscriptionStore.subscription, [subscriptionStore]);
  final billingPage = useComputedValue(
    () => environmentStore.values.billingPage,
    [environmentStore],
  );

  return useCallback(
    () async {
      if (subscription?.active ?? false) {
        try {
          await subscriptionStore.manageSubscription();
          return;
        } on SubscriptionRequiredException catch (_) {
          // ignore and let the flow continue
        }
      }

      handleOnBillingPage(
        beamer: beamer,
        billingPage: billingPage,
        gateway: subscription?.gateway,
        subscriptionActive: subscription?.active ?? false,
        accessToken: accessToken,
      );
    },
    [
      beamer,
      billingPage,
      subscription?.gateway,
      subscription?.active,
      accessToken,
      subscriptionStore,
    ],
  );
}
