import 'dart:async';

import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_plans_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_purchase_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_store.dart';
part 'subscription_checkout_store.g.dart';

enum CheckoutOutcome { purchased, alreadyActive, webRedirectCompleted, error }

// ignore: library_private_types_in_public_api
class SubscriptionCheckoutStore = _SubscriptionCheckoutStore with _$SubscriptionCheckoutStore;

abstract class _SubscriptionCheckoutStore with Store, Disposeable {
  _SubscriptionCheckoutStore(
    this._plansStore,
    this._subscriptionStore,
    this._purchaseStore,
    this._remoteConfigStore,
    this._sessionStore,
    this._analyticsStore,
  ) {
    _statusReactionDisposer = reaction((_) => _purchaseStore.subscriptionStatus, _onStatusChanged);
  }

  final SubscriptionPlansStore _plansStore;
  final SubscriptionStore _subscriptionStore;
  final SubscriptionPurchaseStore _purchaseStore;
  final RemoteConfigStore _remoteConfigStore;
  final AuthSessionStore _sessionStore;
  final AnalyticsStore _analyticsStore;

  late final ReactionDisposer _statusReactionDisposer;

  @observable
  bool isLoading = false;

  @observable
  CheckoutOutcome? outcome;

  @observable
  Object? error;

  @action
  void _onStatusChanged(SubscriptionStatus? status) {
    isLoading = status?.isLoading ?? false;
    if (status?.isError ?? false) {
      error = _purchaseStore.subscriptionError;
      outcome = CheckoutOutcome.error;
      return;
    }
    if (status == SubscriptionStatus.canceled) {
      return;
    }
    if (status != null && !status.isLoading) {
      if (status == SubscriptionStatus.purchased) {
        outcome = CheckoutOutcome.purchased;
      }
      _subscriptionStore.refreshAll().ignore();
    }
  }

  @action
  Future<void> subscribe(String id) async {
    final products = await _plansStore.future;
    final selectedProduct = products.firstWhereOrNull((it) => it.id == id);
    if (selectedProduct == null) {
      return;
    }

    if (selectedProduct.id == _subscriptionStore.subscriptionFuture.value?.planId) {
      outcome = CheckoutOutcome.alreadyActive;
      return;
    }

    _analyticsStore.logEvent(
      AnalyticsEvent.subscriptionNew,
      parameters: {'item_ids': products.map((e) => e.id).toList()},
    );

    final gateway = _subscriptionStore.subscriptionFuture.value?.gateway;
    if (_remoteConfigStore.gatewaysSupportingUpgrade.contains(gateway?.toLowerCase())) {
      final uri = _remoteConfigStore.checkoutWebRedirectUrl.replace(
        queryParameters: {
          'plan': selectedProduct.id,
          'access_token': _sessionStore.accessToken ?? '',
        },
      );
      await openUrlLink(uri);
      outcome = CheckoutOutcome.webRedirectCompleted;
      return;
    }

    await _purchaseStore.subscribeToPackage(product: selectedProduct.productDetails);
  }

  @action
  void clearOutcome() => outcome = null;

  @override
  void dispose() {
    _statusReactionDisposer();
  }
}
