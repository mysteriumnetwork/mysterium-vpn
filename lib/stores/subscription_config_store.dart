import 'dart:async';
import 'dart:io';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:vpn_api/vpn_api.dart' hide Subscription;

part 'subscription_config_store.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionConfigStore = _SubscriptionConfigStore with _$SubscriptionConfigStore;

abstract class _SubscriptionConfigStore with Store, Disposeable {
  _SubscriptionConfigStore(this._authSessionStore, this._service, this._analyticsStore) {
    _reactions = [
      reaction((_) => _authSessionStore.accessToken, (token) {
        if (token != null) {
          _future = ObservableFuture(_fetch());
          _subscriptionFuture = ObservableFuture(_fetchSubscription());
        }
      }, fireImmediately: true),
      reaction((_) => _subscriptionFuture.value?.planId, (plan) {
        _subscriptionPlanFuture = ObservableFuture(_service.fetchSubscriptionPlan());
      }),
    ];
  }

  final AuthSessionStore _authSessionStore;
  final SubscriptionService _service;
  final AnalyticsStore _analyticsStore;

  late final List<ReactionDisposer> _reactions;

  @readonly
  late ObservableFuture<SubscriptionConfigResponse?> _future = ObservableFuture(_fetch());

  @readonly
  late ObservableFuture<Subscription> _subscriptionFuture = ObservableFuture(_fetchSubscription());

  @readonly
  late ObservableFuture<GetPlanResponse> _subscriptionPlanFuture = ObservableFuture(
    _service.fetchSubscriptionPlan(),
  );

  Future<SubscriptionConfigResponse?> _fetch() async {
    if (Platform.isWindows) {
      return null;
    }
    try {
      final config = await _service.fetchSubscriptionConfig();
      await _service.clearPendingTransactions();
      return config;
    } on NotAvailableException catch (_) {
      return null;
    }
  }

  Future<Subscription> _fetchSubscription() async {
    if (!_authSessionStore.isAuthenticated) {
      return Subscription.empty();
    }
    final subscription = await _service.fetchSubscriptionDetails();
    _setSubscriptionAnalyticsProps(subscription).ignore();
    return subscription;
  }

  Future<void> _setSubscriptionAnalyticsProps(Subscription subscription) async {
    final userStatus = subscription.active
        ? 'paid'
        : (subscription.expired ?? false)
        ? 'expired_paid'
        : 'not_paid';
    _analyticsStore
      ..setUserProperty(
        AnalyticsUserProperty.fromEnum(
          name: AnalyticsUserPropName.planId,
          value: subscription.planId ?? '',
        ),
      )
      ..setUserProperty(
        AnalyticsUserProperty.fromEnum(
          name: AnalyticsUserPropName.validTo,
          value: subscription.activeUntil.toString(),
        ),
      )
      ..setUserProperty(
        AnalyticsUserProperty.fromEnum(name: AnalyticsUserPropName.userStatus, value: userStatus),
      );
  }

  @override
  FutureOr<void> dispose() {
    for (final disposer in _reactions) {
      disposer();
    }
  }
}
