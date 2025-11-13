import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/extensions/observable_future_extensions.dart';
import 'package:mysterium_vpn/common/utils/disposeable.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/models/product_offer.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'subscription_limited_time_offer_store.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionLimitedTimeOfferStore = _SubscriptionLimitedTimeOfferStore
    with _$SubscriptionLimitedTimeOfferStore;

abstract class _SubscriptionLimitedTimeOfferStore with Store, Disposeable {
  _SubscriptionLimitedTimeOfferStore(this._subscriptionStore, this._remoteConfigStore) {
    _disposers.addAll(
      [
        reaction((_) => _subscriptionStore.productsFuture.value, (_) => _refresh()),
        reaction((_) => _remoteConfigStore.limitedTimeOfferId, (_) => _refresh()),
        reaction((_) => _remoteConfigStore.limitedTimeOfferExpiryDate, (_) => _refresh()),
      ],
    );
  }

  final SubscriptionStore _subscriptionStore;
  final RemoteConfigStore _remoteConfigStore;
  final List<ReactionDisposer> _disposers = [];

  @readonly
  late ObservableFuture<LimitedTimeOffer?> _future = ObservableFuture(_fetch());

  void _refresh() {
    _future = _future.replaceOrReset(_fetch());
  }

  Future<LimitedTimeOffer?> _fetch() async {
    await _remoteConfigStore.configFuture;

    final offerId = _remoteConfigStore.limitedTimeOfferId;
    final expiryDate = _remoteConfigStore.limitedTimeOfferExpiryDate;
    if (offerId == null || expiryDate == null || expiryDate.isBefore(DateTime.now())) {
      return null;
    }

    final products = await _subscriptionStore.productsFuture;
    for (final product in products) {
      final offers = product.offers;
      for (final offer in offers) {
        if (offer.id == offerId) {
          return (product: product, offer: offer, expiryDate: expiryDate);
        }
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
}

typedef LimitedTimeOffer = ({PurchasableProduct product, ProductOffer offer, DateTime expiryDate});
