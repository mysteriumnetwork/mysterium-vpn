part of 'hooks.dart';

FutureOr<void> Function() useHandleSubscribe() {
  final context = useContext();
  final beamer = Beamer.of(context);

  return useCallback(
    () async {
      final ref = ProviderScope.containerOf(context, listen: false);
      final sessionStore = ref.read(authSessionStorePOD);
      final subscriptionStore = ref.read(subscriptionStorePOD);
      final upgradeSubscriptionStore = ref.read(subscriptionUpgradeStorePOD);
      final subscriptionPurchaseStore = ref.read(subscriptionPurchaseStorePOD);

      final accessToken = sessionStore.accessToken;

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
          onManageSubscription: subscriptionPurchaseStore.manageSubscription,
        );
      } on SubscriptionRequiredException catch (_) {
        // ignore and let the flow continue
      }
    },
    [beamer],
  );
}
