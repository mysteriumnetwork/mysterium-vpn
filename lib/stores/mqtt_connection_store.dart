import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mysterium_vpn/common/observers/background_duration_observer.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:talker/talker.dart';

/// Owns the MQTT connection's lifecycle.
///
/// The broker connection is useless while the app is backgrounded — Dart is
/// frozen — and leaving it open lets auto-reconnect churn against a socket the
/// OS already dropped. Closing on the way out makes the return one deliberate
/// connect instead of a reconnect storm.
class MqttConnectionStore with WidgetsBindingObserver, BackgroundDurationObserver, Disposeable {
  MqttConnectionStore({required MQTTService mqtt, required Talker logger})
    : _mqtt = mqtt,
      _logger = logger;

  final MQTTService _mqtt;
  final Talker _logger;

  Future<void> init() async {
    WidgetsBinding.instance.addObserver(this);
    await connect();
  }

  @override
  void onLeftForeground() => disconnect();

  @override
  void onReturnedToForeground(Duration backgroundedFor) => unawaited(connect());

  @visibleForTesting
  Future<void> connect() async {
    try {
      await _mqtt.start();
    } catch (e, stack) {
      // Expected whenever the network is unavailable; the next resume retries.
      _logger.warning('MQTT connect failed', e, stack);
    }
  }

  @visibleForTesting
  void disconnect() {
    try {
      _mqtt.stop();
    } catch (e, stack) {
      _logger.warning('MQTT disconnect failed', e, stack);
    }
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    disconnect();
  }
}
