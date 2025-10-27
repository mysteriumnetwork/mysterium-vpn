import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';

part 'subscription_upgrade_store.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionUpgradeStore = _SubscriptionUpgradeStore with _$SubscriptionUpgradeStore;

abstract class _SubscriptionUpgradeStore with Store {
  _SubscriptionUpgradeStore(this._subscriptionStore);

  final SubscriptionStore _subscriptionStore;

  @computed
  List<PurchasableProduct> get purchasableProducts {
    final products = _subscriptionStore.productsFuture.value;
    if (products == null) {
      return const <PurchasableProduct>[];
    }

    return products.sortedByCompare((it) => it.duration, (d1, d2) => d1.compareTo(d2));
  }

  @computed
  PurchasableProduct? get downgradeProduct {
    final subscription = _subscriptionStore.subscriptionFuture.value;
    final plans = purchasableProducts;
    if (subscription == null || !subscription.isGatewayOnCurrentPlatform) {
      return null;
    }

    if (!subscription.isExpired) {
      return plans.firstWhereOrNull((it) => it.id == subscription.planId);
    }
    return plans.firstOrNull;
  }

  @computed
  PurchasableProduct? get upgradeProduct {
    final downgradeProduct = this.downgradeProduct;
    final plans = purchasableProducts;
    if (downgradeProduct == null) {
      return null;
    }

    final largestPlan = plans.lastOrNull;
    if (largestPlan != null && largestPlan.id != downgradeProduct.id) {
      return largestPlan;
    }
    return null;
  }

  @computed
  int? get upgradeDiscountPercent {
    final downgrade = downgradeProduct;
    final upgrade = upgradeProduct;
    if (downgrade == null || upgrade == null) {
      return null;
    }

    return downgrade.periodDiscountPercentage(upgrade);
  }

  @computed
  bool get isEligibleForUpgrade {
    final discount = upgradeDiscountPercent;
    return discount != null && discount > 0;
  }

  @action
  Future<void> upgrade() async {
    await _subscriptionStore.subscribeToPackage(product: upgradeProduct!.productDetails);
  }
}
