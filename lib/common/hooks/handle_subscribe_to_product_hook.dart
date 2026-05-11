import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

Future<void> Function(String id) useHandleSubscribeToProduct() {
  final context = useContext();
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
        Navigator.of(context).pop();
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
      await openUrlLink(uri);
      if (context.mounted) {
        Navigator.of(context).pop();
      }
      return;
    }

    await purchaseStore.subscribeToPackage(product: selectedProduct.productDetails);
  }, [context]);
}
