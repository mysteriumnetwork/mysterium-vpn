import 'dart:async';

import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/utils/disposeable.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';
import 'package:mysterium_vpn/models/subscription_plan_features.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'subscription_plans_store.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionPlansStore = _SubscriptionPlansStore with _$SubscriptionPlansStore;

abstract class _SubscriptionPlansStore with Store, Disposeable {
  _SubscriptionPlansStore(
    this._subscriptionStore,
    this._remoteConfigStore,
  ) {
    _reactions = [
      reaction(
        (_) => _subscriptionStore.productsFuture,
        (_) => _future = ObservableFuture(_refresh()),
      ),
      reaction(
        (_) => _remoteConfigStore.configFuture,
        (_) => _future = ObservableFuture(_refresh()),
      ),
    ];
  }

  final SubscriptionStore _subscriptionStore;
  final RemoteConfigStore _remoteConfigStore;
  late final List<ReactionDisposer> _reactions;

  Future<void> _refresh() async {
    await Future.wait([
      _subscriptionStore.subscriptionFuture,
      _subscriptionStore.productsFuture,
      _remoteConfigStore.configFuture,
    ]);
  }

  @readonly
  late ObservableFuture<void> _future = ObservableFuture(_refresh());

  @computed
  PurchasableProduct? get purchasedProduct {
    final subscription = _subscriptionStore.subscriptionFuture.value;
    if (subscription == null) {
      return null;
    }
    final allProducts = _subscriptionStore.productsFuture.value ?? const [];
    return allProducts.firstWhereOrNull((it) => it.id == subscription.planId);
  }

  @computed
  List<PurchasableProduct> get products {
    final all = _subscriptionStore.productsFuture.value ?? const [];
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
    final config =
        _remoteConfigStore.planFeatures.firstWhereOrNull((it) => it.planIds.contains(product.id));
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
