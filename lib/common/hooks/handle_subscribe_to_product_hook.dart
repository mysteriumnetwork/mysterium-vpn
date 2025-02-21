import 'package:collection/collection.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

Future<void> Function(String id) useHandleSubscribeToProduct() {
  final context = useContext();
  return useCallback(
    (String id) async {
      if (!context.mounted) {
        return;
      }
      final ref = ProviderScope.containerOf(context, listen: false);
      final subscriptionStore = ref.read(subscriptionStorePOD);
      final analyticsStore = ref.read(analyticsStorePOD);
      final products = await subscriptionStore.productsFuture;

      final selectedProduct = products.firstWhereOrNull((it) => it.id == id);
      if (selectedProduct == null) {
        return;
      }

      analyticsStore.logEvent(
        AnalyticsEvent.subscriptionNew,
        parameters: {'item_ids': products.map((e) => e.id).toList()},
      );

      await subscriptionStore.subscribeToPackage(product: selectedProduct.productDetails);
    },
    [context],
  );
}
