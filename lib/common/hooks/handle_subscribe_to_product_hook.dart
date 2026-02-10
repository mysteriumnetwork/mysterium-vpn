import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> Function(String id) useHandleSubscribeToProduct() {
  final context = useContext();
  return useCallback(
    (String id) async {
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
      final gateway = subscriptionStore.subscriptionFuture.value?.gateway;
      final selectedProduct = products.firstWhereOrNull((it) => it.id == id);
      if (selectedProduct == null) {
        return;
      }

      if (selectedProduct.id == subscriptionStore.subscriptionFuture.value?.planId) {
        // already subscribed to this product, do nothing
        if (context.mounted) {
          showSnackbar("You're all set! You already have this plan active");
          Navigator.of(context).pop();
        }
        return;
      }

      analyticsStore.logEvent(
        AnalyticsEvent.subscriptionNew,
        parameters: {'item_ids': products.map((e) => e.id).toList()},
      );

      if (remoteConfigStore.gatewaysSupportingUpgrade.contains(gateway)) {
        final uri = remoteConfigStore.checkoutWebRedirectUrl.replace(
          queryParameters: {
            'plan': selectedProduct.id,
            'access_token': accessToken ?? '',
          },
        );
        await openUrlLink(uri);
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        return;
      }

      await purchaseStore.subscribeToPackage(product: selectedProduct.productDetails);
    },
    [context],
  );
}
