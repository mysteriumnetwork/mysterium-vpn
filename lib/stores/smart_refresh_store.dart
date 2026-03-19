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
  _SmartRefreshStore(this._locationsStore, this._subscriptionStore, this._logger) {
    _init();
  }

  final LocationsStore _locationsStore;
  final SubscriptionStore _subscriptionStore;
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
    _subscriptionDebouncer.debounce(_subscriptionStore.refreshSubscription);
  }

  Future<void> _onPause() async {}

  Future<void> _refreshLocations() async {
    try {
      await _locationsStore.refreshAll();
    } catch (e, stack) {
      _logger.handle(e, stack);
    }
  }
}
