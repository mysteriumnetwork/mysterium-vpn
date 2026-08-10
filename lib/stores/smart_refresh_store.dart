import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

part 'smart_refresh_store.g.dart';

// ignore: library_private_types_in_public_api
class SmartRefreshStore = _SmartRefreshStore with _$SmartRefreshStore;

abstract class _SmartRefreshStore with Store, Disposeable, WidgetsBindingObserver {
  _SmartRefreshStore(
    this._locationsStore,
    this._subscriptionStore,
    this._authSessionStore,
    this._logger,
  ) {
    _init();
  }

  final LocationsStore _locationsStore;
  final SubscriptionStore _subscriptionStore;
  final AuthSessionStore _authSessionStore;
  final Talker _logger;
  late final List<ReactionDisposer> _disposers;
  late final Debouncer _subscriptionDebouncer;

  void _init() {
    _subscriptionDebouncer = Debouncer();

    _disposers = [
      reaction(
        (_) => _subscriptionStore.subscriptionFuture.value?.planId ?? '',
        (_) => _refreshLocations(),
        delay: 200,
        fireImmediately: false,
      ),
      // Locations carry per-user isAvailable flags from the API. Refresh
      // on every auth-state transition so the cache reflects the current
      // user — especially after logout/login to the same account, where
      // planId doesn't change and the planId reaction wouldn't fire.
      reaction(
        (_) => _authSessionStore.isAuthenticated,
        (_) => _refreshLocations(invalidate: true),
        fireImmediately: false,
      ),
    ];
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        _onResume();
        break;
      case AppLifecycleState.paused:
        _onPause();
        break;
      default:
        break;
    }
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    _subscriptionDebouncer.dispose();
    for (final disposer in _disposers) {
      disposer();
    }
  }

  Future<void> _onResume() async {
    _subscriptionDebouncer.debounce(() {
      // Post-frame so the warm-start frame paints before the network refresh.
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final before = _subscriptionStore.subscriptionFuture.value;
        debugPrint(
          'MAZLOG resume refreshSubscription START '
          'active=${before?.active} recurring=${before?.recurring} '
          'planId=${before?.planId} storePlanId=${before?.storePlanId}',
        );
        try {
          final after = await _subscriptionStore.refreshSubscription(force: true);
          debugPrint(
            'MAZLOG resume refreshSubscription DONE '
            'active=${after.active} recurring=${after.recurring} '
            'planId=${after.planId} storePlanId=${after.storePlanId} '
            'activeUntil=${after.activeUntil}',
          );
        } on Object catch (e, stack) {
          debugPrint('MAZLOG resume refreshSubscription FAILED error=$e');
          _logger.handle(e, stack);
        }
      });
    });
  }

  Future<void> _onPause() async {}

  Future<void> _refreshLocations({bool invalidate = false}) async {
    try {
      await _locationsStore.refreshAll(invalidate: invalidate);
    } catch (e, stack) {
      _logger.handle(e, stack);
    }
  }
}
