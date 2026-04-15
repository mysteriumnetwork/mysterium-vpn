import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_plans_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_store.dart';
import 'package:mysterium_vpn/models/models.dart';

part 'subscription_upgrade_store.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionUpgradeStore = _SubscriptionUpgradeStore with _$SubscriptionUpgradeStore;

abstract class _SubscriptionUpgradeStore with Store {
  _SubscriptionUpgradeStore(this._subscriptionStore, this._plansStore, this._remoteConfigStore);

  final SubscriptionStore _subscriptionStore;
  final SubscriptionPlansStore _plansStore;
  final RemoteConfigStore _remoteConfigStore;

  @computed
  List<PurchasableProduct> get purchasableProducts {
    final products = _plansStore.future.value;
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
    final plans = purchasableProducts;
    final bestValueProducts = _plansStore.bestValueProducts;

    // If no current product, return best value product for new users
    if (currentProduct == null) {
      final bestProduct = bestValueProducts.lastOrNull;
      return bestProduct;
    }

    // First priority: if user is on monthly, try to get yearly version of same tier
    final currentConfig = _plansStore.findConfig(currentProduct);
    final sameYearlyPlan = plans.firstWhereOrNull(
      (p) =>
          _plansStore.findConfig(p).name == currentConfig.name &&
          p.duration == 12 &&
          p.id != currentProduct.id,
    );

    if (sameYearlyPlan != null) {
      return sameYearlyPlan;
    }

    // Second priority: return the best value product if different from current
    final bestProduct = bestValueProducts.lastOrNull;
    if (bestProduct != null && bestProduct.id != currentProduct.id) {
      return bestProduct;
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

  @computed
  bool get useStorePrices {
    final gateway = _subscriptionStore.subscriptionFuture.value?.gateway;
    return gateway == null || gateway.isEmpty || isMobilePaymentGateway(gateway);
  }

  @computed
  bool get canUseSalesValues => _remoteConfigStore.pricingMonthly;

  /// The monthly product of the same tier as the best-value product,
  /// used as a price comparison baseline. Falls back to the user's purchased product.
  @computed
  PurchasableProduct? get upgradeComparisonProduct {
    final product = upgradeProduct;
    if (product == null) {
      return null;
    }
    final bestConfig = _plansStore.findConfig(product);
    final allProducts = [..._plansStore.annualProducts, ..._plansStore.monthlyProducts];
    return allProducts.firstWhereOrNull(
          (p) => _plansStore.findConfig(p).name == bestConfig.name && p.duration == 1,
        ) ??
        _plansStore.purchasedProduct;
  }

  /// Get comparison product for a given plan
  /// If user has a plan: returns the plan to compare against (for upgrade savings)
  /// If user has no plan: returns monthly of same tier (if yearly) or null (if monthly)
  PurchasableProduct? getComparisonProduct(
    PurchasableProduct product,
    List<PurchasableProduct> allProducts,
  ) {
    final currentProduct = this.currentProduct;
    final productConfig = _plansStore.findConfig(product);

    // If user has a current plan
    if (currentProduct != null) {
      final currentPlan = purchasableProducts.firstWhereOrNull((p) => p.id == currentProduct.id);

      if (currentPlan != null) {
        // If user is on monthly and viewing yearly of same tier: show savings
        if (currentPlan.duration == 1 && product.duration == 12) {
          final currentConfig = _plansStore.findConfig(currentPlan);
          if (currentConfig.name == productConfig.name) {
            return currentPlan;
          }
        }
        // Otherwise compare to their current plan
        return currentPlan;
      }
    }

    // No current plan: only compare yearly to monthly of same tier
    if (product.duration == 12) {
      return allProducts.firstWhereOrNull(
        (p) => _plansStore.findConfig(p).name == productConfig.name && p.duration == 1,
      );
    }

    return null;
  }
}
