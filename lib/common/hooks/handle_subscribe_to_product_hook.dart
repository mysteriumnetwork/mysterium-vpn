import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

/// [onAfterRedirect] fires after web-checkout hand-off or "already on this
/// plan" — modal callers pass [Navigator.pop]; tab callers leave it null.
Future<void> Function(String id) useHandleSubscribeToProduct({VoidCallback? onAfterRedirect}) {
  final context = useContext();
  final onAfterRedirectRef = useRef(onAfterRedirect)..value = onAfterRedirect;
  return useCallback((String id) async {
    if (!context.mounted) {
      return;
    }
    final ref = ProviderScope.containerOf(context, listen: false);
    final analyticsStore = ref.read(analyticsStorePOD);
    final plansStore = ref.read(subscriptionPlansStorePOD);
    final purchaseStore = ref.read(subscriptionPurchaseStorePOD);
    final subscriptionStore = ref.read(subscriptionStorePOD);
    final remoteConfigStore = ref.read(remoteConfigStorePOD);
    final sessionStore = ref.read(authSessionStorePOD);
    final accessToken = await sessionStore.accessTokenFuture;
    final products = await plansStore.future;
    final subscription = subscriptionStore.subscriptionFuture.value;
    final gateway = subscription?.gateway;
    final selectedProduct = products.firstWhereOrNull((it) => it.id == id);
    if (selectedProduct == null) {
      return;
    }

    if ((subscription?.active ?? false) && selectedProduct.id == subscription?.planId) {
      // already subscribed to this product, do nothing
      if (context.mounted) {
        showSnackbar(LocaleKeys.planAlreadyPurchasedMsg.tr());
        onAfterRedirectRef.value?.call();
      }
      return;
    }

    analyticsStore.logEvent(
      AnalyticsEvent.subscriptionNew,
      parameters: {'item_ids': products.map((e) => e.id).toList()},
    );

    if ((subscription?.active ?? false) &&
        remoteConfigStore.gatewaysSupportingUpgrade.contains(gateway?.toLowerCase())) {
      final uri = remoteConfigStore.checkoutWebRedirectUrl.replace(
        queryParameters: {'plan': selectedProduct.id, 'access_token': accessToken ?? ''},
      );
      await openUrlLink(uri, source: RedirectSource.webCheckout);
      if (context.mounted) {
        onAfterRedirectRef.value?.call();
      }
      return;
    }

    // Cross-platform mobile mismatch: don't start a new IAP alongside the
    // active sub on the other store.
    if ((subscription?.active ?? false) &&
        isMobilePaymentGateway(gateway) &&
        !(subscription?.isGatewayOnCurrentPlatform ?? true)) {
      if (context.mounted) {
        showSnackbar(
          LocaleKeys.activeSubsPaidVia.tr(namedArgs: {'store': subscription!.gatewayName}),
        );
      }
      return;
    }

    await purchaseStore.subscribeToPackage(product: selectedProduct.productDetails);
  }, [context]);
}
