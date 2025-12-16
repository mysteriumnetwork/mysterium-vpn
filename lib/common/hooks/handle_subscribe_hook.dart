part of 'hooks.dart';

FutureOr<void> Function() useHandleSubscribe() {
  final context = useContext();
  final beamer = Beamer.of(context);

  final sessionStore = useProvider(authSessionStorePOD);
  final subscriptionStore = useProvider(subscriptionStorePOD);
  final upgradeSubscriptionStore = useProvider(subscriptionUpgradeStorePOD);

  final accessToken = useComputedValue(() => sessionStore.accessToken, [sessionStore]);

  return useCallback(
    () async {
      try {
        final subscription = await subscriptionStore.subscriptionFuture;
        if (!context.mounted) {
          return;
        }
        await handleOnBillingPage(
          context: context,
          upgradeProduct: upgradeSubscriptionStore.upgradeProduct,
          billingPage: Env.billingPage,
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
      accessToken,
      subscriptionStore,
      upgradeSubscriptionStore,
    ],
  );
}
