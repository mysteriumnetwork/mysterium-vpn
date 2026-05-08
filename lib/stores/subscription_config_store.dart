import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/extensions/observable_future_extensions.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:vpn_api/vpn_api.dart' hide Subscription;

part 'subscription_config_store.g.dart';

// ignore: library_private_types_in_public_api
class SubscriptionConfigStore = _SubscriptionConfigStore with _$SubscriptionConfigStore;

abstract class _SubscriptionConfigStore with Store, Disposeable {
  _SubscriptionConfigStore(this._authSessionStore, this._service) {
    _reactions = [
      reaction((_) => _authSessionStore.accessToken, (token) {
        if (token != null) {
          _future = ObservableFuture(_fetch());
        }
      }, fireImmediately: true),
    ];
  }

  final AuthSessionStore _authSessionStore;
  final SubscriptionService _service;

  late final List<ReactionDisposer> _reactions;

  @readonly
  late ObservableFuture<SubscriptionConfigResponse?> _future = ObservableFuture.value(null);

  @readonly
  late ObservableFuture<GetPlanResponse> _subscriptionPlanFuture = ObservableFuture(
    Completer<GetPlanResponse>().future,
  );

  /// The planId that [_subscriptionPlanFuture] was last fetched for. Consumers
  /// gate their use of the plan response on this matching the current
  /// subscription's planId — otherwise the response is stale (e.g. after an
  /// upgrade, before the planId reaction refetches).
  @readonly
  String? _fetchedPlanId;

  Future<SubscriptionConfigResponse?> _fetch() async {
    final config = await _service.fetchSubscriptionConfig();
    _service.clearPendingTransactions().catchError((Object _) {});
    return config;
  }

  @action
  void refreshPlan(String planId) {
    _fetchedPlanId = planId;
    _subscriptionPlanFuture = ObservableFuture(_service.fetchSubscriptionPlan());
  }

  @action
  Future<SubscriptionConfigResponse?> refreshConfig() async {
    _future = _future.replaceOrReset(_fetch());
    return await _future;
  }

  @override
  FutureOr<void> dispose() {
    for (final disposer in _reactions) {
      disposer();
    }
  }
}
