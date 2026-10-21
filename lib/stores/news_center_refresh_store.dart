import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mysterium_vpn/common/observers/background_duration_observer.dart';
import 'package:mysterium_vpn/stores/news_center_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';

/// Auto-refreshes the News Center feed when the app returns to the foreground
/// after being backgrounded longer than
/// [RemoteConfigStore.newsCenterRefreshIntervalMinutes].
///
/// Backgrounded-duration detection comes from [BackgroundDurationObserver];
/// this only decides whether the gap was long enough to act on.
class NewsCenterRefreshStore with WidgetsBindingObserver, BackgroundDurationObserver {
  NewsCenterRefreshStore(this._newsCenterStore, this._config, {DateTime Function()? clock})
    : _clock = clock ?? DateTime.now {
    WidgetsBinding.instance.addObserver(this);
  }

  final NewsCenterStore _newsCenterStore;
  final RemoteConfigStore _config;
  final DateTime Function() _clock;

  @override
  DateTime Function() get clock => _clock;

  @override
  void onReturnedToForeground(Duration backgroundedFor) => _maybeRefresh(backgroundedFor);

  void _maybeRefresh(Duration inactiveFor) {
    // Respect the feature kill switch — no background network calls when the
    // News Center is disabled.
    if (!_config.newsCenterEnabled) {
      return;
    }
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
