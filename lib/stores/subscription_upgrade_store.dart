import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/utils/computed_observable_future.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';
import 'package:mysterium_vpn/models/subscription.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';

part 'subscription_upgrade_store.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionUpgradeStore = _SubscriptionUpgradeStore with _$SubscriptionUpgradeStore;

abstract class _SubscriptionUpgradeStore with Store {
  _SubscriptionUpgradeStore(this._subscriptionStore);

  final SubscriptionStore _subscriptionStore;

  @computed
  ObservableFuture<List<PurchasableProduct>> get purchasableProducts => ComputedObservableFuture(
        _subscriptionStore.productsFuture,
        transform: (products) =>
            products.sortedByCompare((it) => it.duration, (d1, d2) => d1.compareTo(d2)),
      );

  @computed
  ObservableFuture<PurchasableProduct?> get downgradeProduct => ComputedObservableFuture.multi(
        [_subscriptionStore.subscriptionFuture, purchasableProducts],
        combine: (values) {
          final [subscription as Subscription, plans as List<PurchasableProduct>] = values;
          if (!subscription.isGatewayOnCurrentPlatform) {
            return null;
          }

          return plans.firstWhereOrNull(
                  (it) => it.id == subscription.planId && !subscription.isExpired) ??
              plans.firstOrNull;
        },
      );

  @computed
  ObservableFuture<PurchasableProduct?> get upgradeProduct => ComputedObservableFuture.multi(
        [downgradeProduct, purchasableProducts],
        combine: (values) {
          final [
            downgradeProduct as PurchasableProduct?,
            purchasableProducts as List<PurchasableProduct>
          ] = values;

          if (downgradeProduct == null) {
            return null;
          }

          return purchasableProducts.lastOrNull;
        },
      );

  @computed
  int? get upgradeDiscountPercent {
    final downgrade = downgradeProduct.value;
    final upgrade = upgradeProduct.value;
    if (downgrade == null || upgrade == null) {
      return null;
    }

    return downgrade.periodDiscountPercentage(upgrade);
  }

  @action
  Future<void> upgrade() async {
    final product = await upgradeProduct;
    await _subscriptionStore.subscribeToPackage(product: product!.productDetails);
  }
}
