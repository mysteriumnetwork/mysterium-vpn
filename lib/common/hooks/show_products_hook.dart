import 'package:collection/collection.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/handle_subscribe_to_product_hook.dart';
import 'package:mysterium_vpn/common/utils/comparator_utils.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/subscription/widgets/product_picker_dialog.dart';

ShowProductsCallback useShowProducts() {
  final context = useContext();
  final handleSubscribe = useHandleSubscribeToProduct();

  return useCallback(
    ({
      bool seeAllPlans = true,
      Future<void> Function(String packageId)? subscribeToPackage,
    }) async {
      final ref = ProviderScope.containerOf(context, listen: false);
      final store = ref.read(subscriptionStorePOD);
      final products = (await store.productsFuture)
          .sortedByCompare((it) => it.duration, compareNums)
          .reversed
          .toList();

      subscribeToPackage ??= handleSubscribe;

      if (context.mounted) {
        await shownProductPickerDialog(
          context: context,
          products: products,
          subscribeToPackage: subscribeToPackage,
          seeAllPlans: seeAllPlans,
        );
      }
    },
    [handleSubscribe],
  );
}

typedef ShowProductsCallback = Future<void> Function({
  bool seeAllPlans,
  Future<void> Function(String packageId)? subscribeToPackage,
});
