import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/observers/background_duration_observer.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:talker/talker.dart';

/// Owns the MQTT connection's lifecycle.
///
/// The broker connection is useless while the app is backgrounded — Dart is
/// frozen — and leaving it open lets auto-reconnect churn against a socket the
/// OS already dropped. Closing on the way out makes the return one deliberate
/// connect instead of a reconnect storm.
class MqttConnectionStore with WidgetsBindingObserver, BackgroundDurationObserver, Disposeable {
  MqttConnectionStore({
    required MQTTService mqtt,
    required AnalyticsStore analytics,
    required Talker logger,
  }) : _mqtt = mqtt,
       _analytics = analytics,
       _logger = logger;

  final MQTTService _mqtt;
  final AnalyticsStore _analytics;
  final Talker _logger;

  /// Whether a live connection is wanted. A handshake can settle *after* the
  /// backgrounding that asked for shutdown, and stopping mid-handshake cannot
  /// cancel one already in flight — so the intent is re-read once it lands.
  bool _wantConnected = false;

  /// The in-flight connect, so a resume arriving mid-handshake joins it rather
  /// than opening a second connection.
  Future<void>? _connecting;

  /// Set when a shutdown lands mid-handshake. The client cannot cancel one, and
  /// `stop()` clears the handler it needs to finish, so what settles afterwards
  /// is void rather than merely failed — and a resume must not accept it.
  bool _attemptVoided = false;

  /// Drops nobody asked for, and when the current foreground run began.
  /// Reported once per foreground period rather than once per flap: every
  /// event is a platform hop on the main thread.
  int _unwantedDrops = 0;

  /// Last state the broker reported, so a drop is counted on the transition.
  bool _connected = false;
  DateTime? _foregroundSince;

  /// [lifecycleState] defaults to the binding's. Injectable because a plain
  /// `test()` cannot drive the binding's lifecycle state.
  Future<void> init({AppLifecycleState? lifecycleState}) async {
    final state = lifecycleState ?? WidgetsBinding.instance.lifecycleState;
    WidgetsBinding.instance.addObserver(this);
    _mqtt.onConnectionChanged = handleConnectionChanged;
    // Registration replays no lifecycle callback, and deferred init can land
    // after the app is already backgrounded — connecting then holds a socket
    // open until a full cycle completes.
    seedBackgroundState(state);
    if (state == null || state == AppLifecycleState.resumed) {
      await connect();
    }
  }

  @override
  void onLeftForeground() {
    _reportDrops();
    disconnect();
  }

  @override
  void onReturnedToForeground(Duration backgroundedFor) => unawaited(connect());

  @visibleForTesting
  Future<void> connect() async {
    _wantConnected = true;
    _foregroundSince ??= clock();
    await (_connecting ??= _start());
    // Retried once: joining a voided attempt and stopping there would leave
    // MQTT down for the whole foreground period, since nothing else retries.
    if (_wantConnected && _attemptVoided) {
      _attemptVoided = false;
      await (_connecting ??= _start());
    }
    // The intent can have flipped while the handshake ran, and the stop it
    // asked for was a no-op against a client that had not connected yet.
    if (!_wantConnected) {
      disconnect();
    }
  }

  Future<void> _start() async {
    try {
      await _mqtt.start();
    } catch (e, stack) {
      // Expected whenever the network is unavailable; the next resume retries.
      _logger.warning('MQTT connect failed', e, stack);
    } finally {
      _connecting = null;
    }
  }

  @visibleForTesting
  void disconnect() {
    _wantConnected = false;
    if (_connecting != null) {
      _attemptVoided = true;
    }
    try {
      _mqtt.stop();
    } catch (e, stack) {
      _logger.warning('MQTT disconnect failed', e, stack);
    }
  }

  /// Counts drops rather than reconnects: `onConnected` fires on auto-reconnects
  /// too, so counting those would also tally every deliberate open.
  ///
  /// Only connected-to-disconnected transitions count, so a retry sequence that
  /// signals more than once still reads as the single drop that started it.
  @visibleForTesting
  void handleConnectionChanged({required bool connected}) {
    if (!connected && _connected && _wantConnected) {
      _unwantedDrops++;
    }
    _connected = connected;
  }

  void _reportDrops() {
    final since = _foregroundSince;
    _foregroundSince = null;
    if (_unwantedDrops == 0) {
      return;
    }
    _analytics.logEvent(
      AnalyticsEvent.mqttReconnects,
      parameters: {
        'count': _unwantedDrops,
        'foreground_seconds': since == null ? 0 : clock().difference(since).inSeconds,
      },
    );
    _unwantedDrops = 0;
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    _mqtt.onConnectionChanged = null;
    _reportDrops();
    disconnect();
  }
}
