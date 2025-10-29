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
  PurchasableProduct? get currentProduct {
    final subscription = _subscriptionStore.subscriptionFuture.value;
    final plans = purchasableProducts;
    if (subscription == null ||
        !subscription.isGatewayOnCurrentPlatform ||
        subscription.isExpired) {
      return null;
    }

    return plans.firstWhereOrNull((it) => it.id == subscription.planId);
  }

  @computed
  PurchasableProduct? get upgradeProduct {
    final currentProduct = this.currentProduct;
    if (currentProduct == null) {
      return null;
    }

    final plans = purchasableProducts;
    final largestPlan = plans.lastOrNull;
    if (largestPlan != null && largestPlan.id != currentProduct.id) {
      return largestPlan;
    }
    return null;
  }

  @computed
  int? get upgradeDiscountPercent {
    final current = currentProduct;
    final upgrade = upgradeProduct;
    if (current == null || upgrade == null) {
      return null;
    }

    return current.periodDiscountPercentage(upgrade);
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
