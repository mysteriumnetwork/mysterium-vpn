import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mysterium_vpn/stores/news_center_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';

/// Auto-refreshes the News Center feed when the app returns to the foreground
/// after being backgrounded longer than
/// [RemoteConfigStore.newsCenterRefreshIntervalMinutes].
///
/// Tracks the last lifecycle transition and when the app was paused; on resume
/// it refreshes only if the previous state was paused and enough time elapsed.
class NewsCenterRefreshStore with WidgetsBindingObserver {
  NewsCenterRefreshStore(this._newsCenterStore, this._config, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now {
    WidgetsBinding.instance.addObserver(this);
  }

  final NewsCenterStore _newsCenterStore;
  final RemoteConfigStore _config;
  final DateTime Function() _clock;

  AppLifecycleState? _lastState;
  DateTime? _backgroundedAt;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final previous = _lastState;
    _lastState = state;
    final now = _clock();

    switch (state) {
      case AppLifecycleState.paused:
        _backgroundedAt = now;
      case AppLifecycleState.resumed:
        final backgroundedAt = _backgroundedAt;
        _backgroundedAt = null;
        if (previous == AppLifecycleState.paused && backgroundedAt != null) {
          _maybeRefresh(now.difference(backgroundedAt));
        }
      default:
        break;
    }
  }

  void _maybeRefresh(Duration inactiveFor) {
    final minutes = _config.newsCenterRefreshIntervalMinutes;
    if (minutes <= 0 || inactiveFor < Duration(minutes: minutes)) {
      return;
    }
    unawaited(_newsCenterStore.refresh());
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }
}
