import 'dart:async';

import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/extensions/observable_future_extensions.dart';
import 'package:mysterium_vpn/common/utils/comparator_utils.dart';
import 'package:mysterium_vpn/common/utils/disposeable.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/models/product_offer.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/subscription_plans_store.dart';

part 'subscription_limited_time_offer_store.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionLimitedTimeOfferStore = _SubscriptionLimitedTimeOfferStore
    with _$SubscriptionLimitedTimeOfferStore;

abstract class _SubscriptionLimitedTimeOfferStore with Store, Disposeable {
  _SubscriptionLimitedTimeOfferStore(this._plansStore, this._remoteConfigStore) {
    _disposers.addAll(
      [
        reaction((_) => _remoteConfigStore.limitedTimeOfferId, (_) => _refresh()),
        reaction((_) => _remoteConfigStore.limitedTimeOfferExpiryDate, (_) => _refresh()),
      ],
    );
  }

  final SubscriptionPlansStore _plansStore;
  final RemoteConfigStore _remoteConfigStore;
  final List<ReactionDisposer> _disposers = [];

  @readonly
  late ObservableFuture<LimitedTimeOffer?> _future = ObservableFuture(_fetch());

  @computed
  int get discountPercent => _future.value?.offer.discountPercent ?? 0;

  void _refresh() {
    _future = _future.replaceOrReset(_fetch());
  }

  Future<LimitedTimeOffer?> _fetch() async {
    await _remoteConfigStore.configFuture;

    final offerId = _remoteConfigStore.limitedTimeOfferId;
    final expiryDate = _remoteConfigStore.limitedTimeOfferExpiryDate;

    if (expiryDate == null || expiryDate.isBefore(DateTime.now())) {
      return null;
    }

    final products =
        (await _plansStore.future).sortedByCompare((it) => it.duration, compareNums).reversed;
    for (final product in products) {
      final matching = product.offers
          .where((it) => it.id == offerId)
          .sortedByCompare((it) => it.price, compareNums)
          .firstOrNull;

      if (matching != null) {
        return (
          product: product,
          offer: matching,
          expiryDate: expiryDate,
        );
      }
    }
    return null;
  }

  @override
  FutureOr<void> dispose() {
    for (final disposer in _disposers) {
      disposer();
    }
  }

  @action
  Future<void> mockOffer() async {
    final product = (await _plansStore.future).first;
    _future = ObservableFuture.value(
      (
        product: product,
        offer: ProductOffer(
          id: 'mock_offer',
          price: 49.99,
          durationUnit: OfferDuration.month,
          durationValue: 1,
          fullPrice: 200,
        ),
        expiryDate: DateTime.now().add(const Duration(days: 7)),
      ),
    );
  }
}

typedef LimitedTimeOffer = ({PurchasableProduct product, ProductOffer offer, DateTime expiryDate});
