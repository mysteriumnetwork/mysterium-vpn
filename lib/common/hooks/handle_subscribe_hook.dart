part of 'hooks.dart';

FutureOr<void> Function() useHandleSubscribe() {
  final context = useContext();
  final beamer = Beamer.of(context);

  final sessionStore = useProvider(authSessionStorePOD);
  final subscriptionStore = useProvider(subscriptionStorePOD);
  final environmentStore = useProvider(environmentPOD);

  final accessToken = useComputedValue(() => sessionStore.accessToken, [sessionStore]);
  final billingPage = useComputedValue(
    () => environmentStore.values.billingPage,
    [environmentStore],
  );

  return useCallback(
    () async {
      try {
        final subscription = await subscriptionStore.subscriptionFuture;
        await handleOnBillingPage(
          beamer: beamer,
          billingPage: billingPage,
          gateway: subscription.gateway,
          subscriptionActive: subscription.active,
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
      accessToken,
      subscriptionStore,
    ],
  );
}
