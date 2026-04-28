import 'dart:async';

import 'package:collection/collection.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/models/subscription_plan_features.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:vpn_api/vpn_api.dart' hide Subscription;

part 'subscription_plans_store.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionPlansStore = _SubscriptionPlansStore with _$SubscriptionPlansStore;

abstract class _SubscriptionPlansStore with Store, Disposeable {
  _SubscriptionPlansStore(
    this._service,
    this._subscriptionStore,
    this._remoteConfigStore,
    this._inAppPurchase,
  ) {
    _reactions = [
      reaction(
        (_) => _subscriptionStore.subscriptionFuture.value?.planId,
        (_) => refresh(),
        fireImmediately: false,
      ),
    ];
  }

  final SubscriptionService _service;
  final SubscriptionStore _subscriptionStore;
  final RemoteConfigStore _remoteConfigStore;
  final InAppPurchase _inAppPurchase;
  bool? _storeAvailable;
  late final List<ReactionDisposer> _reactions;

  @readonly
  late ObservableFuture<List<PurchasableProduct>> _future = ObservableFuture(_fetchProducts());

  Future<List<PurchasableProduct>> refresh() async {
    _future = _future.replace(_fetchProducts());
    return await _future;
  }

  Future<List<PurchasableProduct>> _fetchProducts() async {
    if (isWindowsOrLinux()) {
      return const [];
    }
    final storeAvailable = _storeAvailable ??= await _inAppPurchase.isAvailable();
    if (!storeAvailable) {
      return const [];
    }

    final [subscription, config, _] = await Future.wait<Object?>([
      _subscriptionStore.subscriptionFuture,
      _subscriptionStore.subscriptionConfigFuture,
      _remoteConfigStore.configFuture,
    ]);
    if (subscription is! Subscription || config is! SubscriptionConfigResponse) {
      return const [];
    }

    final gateway = config.gateways.firstWhereOrNull(
      (element) => element.name == getPlatformGateway(),
    );
    if (gateway == null || !gateway.enabled) {
      return const [];
    }

    return _service.getProductsDetails(config, subscription.planId);
  }

  @computed
  PurchasableProduct? get purchasedProduct {
    final subscription = _subscriptionStore.subscriptionFuture.value;
    if (subscription == null) {
      return null;
    }
    final allProducts = _future.value ?? const [];
    return allProducts.firstWhereOrNull((it) => it.id == subscription.planId);
  }

  @computed
  List<PurchasableProduct> get products {
    final all = _future.value ?? const [];
    final ids = _remoteConfigStore.planFeatures.map((it) => it.planIds).flattenedToSet;
    return all.where((it) => ids.contains(it.id)).toList();
  }

  @computed
  List<PurchasableProduct> get monthlyProducts =>
      products.where((product) => product.duration == 1).toList();

  @computed
  List<PurchasableProduct> get annualProducts =>
      products.where((product) => product.duration == 12).toList();

  @action
  SubscriptionPlanFeatures findConfig(PurchasableProduct product) {
    final config = _remoteConfigStore.planFeatures.firstWhereOrNull(
      (it) => it.planIds.contains(product.id),
    );
    if (config == null) {
      throw StateError('No plan features found for product id: ${product.id}');
    }

    return config;
  }

  @computed
  List<PurchasableProduct> get bestValueProducts {
    final config = _remoteConfigStore.plansBestValue;
    return products
        .where((product) => config.contains(product.id))
        .sortedByCompare((it) => it.rawPrice, (p1, p2) => p1.compareTo(p2))
        .toList();
  }

  @override
  FutureOr<void> dispose() {
    for (final disposer in _reactions) {
      disposer();
    }
  }
}
