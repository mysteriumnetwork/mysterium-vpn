part of 'hooks.dart';

FutureOr<void> Function({bool manageSubscription}) useHandleSubscribe() {
  final context = useContext();

  return useCallback(({bool manageSubscription = false}) async {
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
      await _handleOnBillingPage(
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
  }, const []);
}

FutureOr<void> _handleOnBillingPage({
  required BuildContext context,
  required bool subscriptionActive,
  required String manageSubscriptionPage,
  required String upgradeSubscriptionPage,
  required String? gateway,
  required String? accessToken,
  required bool manageSubscription,
  FutureOr<void> Function()? onManageSubscription,
}) async {
  // getPlatformGateway() returns a lowercase gateway id, so normalize the
  // subscription's gateway before comparing — otherwise a capitalized value
  // from the backend would read as "foreign" on the correct platform.
  final normalizedGateway = gateway?.toLowerCase();
  final isMobileGateway = isMobilePaymentGateway(normalizedGateway);

  if (subscriptionActive && isMobileGateway) {
    if (normalizedGateway != getPlatformGateway()) {
      // Direct the user to the store that actually holds the subscription,
      // derived from its gateway — not the current platform (which is wrong
      // on desktop, where the platform gateway is empty).
      showSnackbar(S.current.activeSubsPaidVia(storeNameForGateway(normalizedGateway)));
      return;
    }
    await onManageSubscription?.call();
    return;
  }

  if (!subscriptionActive && !Platform.isWindows) {
    await showSubscriptionUpgradeModalPage(context);
    return;
  }

  final uri = Uri.parse(manageSubscription ? manageSubscriptionPage : upgradeSubscriptionPage);
  final httpsUri = Uri(
    scheme: uri.scheme,
    host: uri.host,
    path: uri.path,
    queryParameters: {'access_token': accessToken ?? ''},
  );

  await openUrlLink(
    httpsUri,
    source: manageSubscription
        ? RedirectSource.manageSubscription
        : RedirectSource.upgradeSubscription,
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
      showError(S.current.activeSubsPaidVia(subscription.gatewayName));
      return;
    }
    final gateway = subscription.gateway?.toLowerCase();
    final supportsUpgrade =
        remoteConfigStore.gatewaysSupportingUpgrade.contains(gateway) ||
        isMobilePaymentGateway(gateway);

    if (!supportsUpgrade || Platform.isWindows) {
      final uri = Uri.parse(remoteConfigStore.upgradeSubscriptionPage);
      final sessionStore = ref.read(authSessionStorePOD);
      final token = await sessionStore.accessTokenFuture;
      final httpsUri = Uri(
        scheme: uri.scheme,
        host: uri.host,
        path: uri.path,
        queryParameters: {'access_token': token ?? ''},
      );

      openUrlLink(httpsUri, source: RedirectSource.upgradeSubscription).ignore();
      return;
    }
    if (!context.mounted) {
      return;
    }

    await showSubscriptionUpgradeModalPage(context);
  });
}
