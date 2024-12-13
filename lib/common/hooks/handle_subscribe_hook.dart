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
      try {
        await handleOnBillingPage(
          beamer: beamer,
          billingPage: billingPage,
          gateway: subscription?.gateway,
          subscriptionActive: subscription?.active ?? false,
          accessToken: accessToken,
          onManageSubscription: subscriptionStore.manageSubscription,
        );
      } on SubscriptionRequiredException catch (_) {
        // ignore and let the flow continue
      }
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
