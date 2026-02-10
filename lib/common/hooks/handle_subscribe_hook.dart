part of 'hooks.dart';

FutureOr<void> Function({bool manageSubscription}) useHandleSubscribe() {
  final context = useContext();
  final beamer = Beamer.of(context);

  return useCallback(
    ({bool manageSubscription = false}) async {
      final ref = ProviderScope.containerOf(context, listen: false);
      final sessionStore = ref.read(authSessionStorePOD);
      final subscriptionStore = ref.read(subscriptionStorePOD);
      final subscriptionPurchaseStore = ref.read(subscriptionPurchaseStorePOD);
      final remoteConfigStore = ref.read(remoteConfigStorePOD);

      final accessToken = sessionStore.accessToken;

      try {
        final subscription = await subscriptionStore.subscriptionFuture;
        if (!context.mounted) {
          return;
        }
        await handleOnBillingPage(
          context: context,
          manageSubscriptionPage: remoteConfigStore.manageSubscriptionPage,
          upgradeSubscriptionPage: remoteConfigStore.upgradeSubscriptionPage,
          gateway: subscription.gateway,
          subscriptionActive: subscription.active,
          accessToken: accessToken,
          onManageSubscription: subscriptionPurchaseStore.manageSubscription,
          manageSubscription: manageSubscription,
        );
      } on SubscriptionRequiredException catch (_) {
        // ignore and let the flow continue
      }
    },
    [beamer],
  );
}

FutureOr<void> Function() useHandleUpgradePlan() {
  final context = useContext();

  return useCallback(() async {
    final ref = ProviderScope.containerOf(context, listen: false);
    final subscriptionStore = ref.read(subscriptionStorePOD);
    final subscription = await subscriptionStore.subscriptionFuture;
    final remoteConfigStore = ref.read(remoteConfigStorePOD);

    final isCorrectGateway = switch (subscription.gateway) {
      'google' => Platform.isAndroid,
      'apple' => Platform.isIOS || Platform.isMacOS,
      _ => true,
    };

    if (!isCorrectGateway) {
      showError(LocaleKeys.activeSubsPaidVia.tr(namedArgs: {'store': subscription.gatewayName}));
      return;
    }

    if (!remoteConfigStore.gatewaysSupportingUpgrade.contains(subscription.gateway) ||
        Platform.isWindows) {
      final uri = Uri.parse(remoteConfigStore.upgradeSubscriptionPage);
      final sessionStore = ref.read(authSessionStorePOD);
      final token = await sessionStore.accessTokenFuture;
      final httpsUri = Uri(
        scheme: uri.scheme,
        host: uri.host,
        path: uri.path,
        queryParameters: {
          'access_token': token ?? '',
        },
      );

      launchUrl(httpsUri).ignore();
      return;
    }
    if (!context.mounted) {
      return;
    }

    await showSubscriptionUpgradeModalPage(context);
  });
}
