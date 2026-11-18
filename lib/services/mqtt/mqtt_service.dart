import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/services/mqtt/mqtt_experiment_flag.dart';
import 'package:talker/talker.dart';

class MQTTService {
  MQTTService(
    String url,
    String username,
    String password,
    String clientID,
    Talker logger,
    MqttExperimentFlag experimentFlag,
  ) : this.withClient(
        MqttServerClient(url, clientID, maxConnectionAttempts: 2),
        url,
        username,
        password,
        logger,
        experimentFlag,
      );

  @visibleForTesting
  MQTTService.withClient(
    this._mqtt,
    String url,
    String username,
    String password,
    Talker logger,
    MqttExperimentFlag experimentFlag,
  ) : _username = username,
      _password = password,
      _logger = logger,
      _experimentFlag = experimentFlag {
    final uri = Uri.parse(url);

    // Client ID length can not exceed 23, see http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/os/mqtt-v3.1.1-os.html
    if (_mqtt.clientIdentifier.length > 23) {
      throw MQQTException();
    }

    _mqtt
      ..port = uri.port
      ..autoReconnect = true
      ..resubscribeOnAutoReconnect = true
      ..useWebSocket = true
      ..keepAlivePeriod = 50
      // One breadcrumb per side of a flap. onConnected fires on auto-reconnects
      // too, so logging onAutoReconnect as well tripled the volume — and every
      // breadcrumb is a platform hop on the main thread.
      // onFailedConnectionAttempt is omitted: the client never calls it while
      // autoReconnect is set.
      ..onConnected = () {
        _logger.debug('MQTT connected');
        _subscriptions.forEach(_subscribeReal);
        onConnectionChanged?.call(connected: true);
      }
      ..onDisconnected = () {
        _logger.debug('MQTT disconnected');
        onConnectionChanged?.call(connected: false);
      }
      // Forwarded unlogged. An unsolicited drop never reaches onDisconnected
      // while autoReconnect is set: the client fires MqttAutoReconnect instead
      // and returns, so this is the only signal a dropped socket gives.
      ..onAutoReconnect = () => onConnectionChanged?.call(connected: false);
    if (kDebugMode) {
      _mqtt.logging(on: false);
    }
  }

  final MqttServerClient _mqtt;
  final String _username;
  final String _password;
  final Talker _logger;
  final MqttExperimentFlag _experimentFlag;

  final Map<String, StreamController<String>> _subscriptions = {};
  final Map<String, StreamSubscription<String>> _forwards = {};

  /// Notified on every transition, auto-reconnects included, so the owner can
  /// tell a deliberate close from a dropped socket.
  void Function({required bool connected})? onConnectionChanged;

  Future<void> start() async {
    if (!_experimentFlag()) {
      return;
    }

    try {
      await _mqtt.connect(_username, _password);
    } catch (e, stackTrace) {
      _logger.warning('MQTT connect failed', e, stackTrace);
      rethrow;
    }
  }

  /// Closes the connection, from any state but already-disconnected.
  ///
  /// Narrowing this to `connected` made it a no-op mid-handshake and while
  /// auto-reconnecting, so a backgrounding left the socket to open anyway and
  /// the retry loop to run on. `disconnect()` is null-safe throughout and
  /// destroys the event bus that drives auto-reconnect.
  void stop() {
    if (_mqtt.connectionStatus?.state == MqttConnectionState.disconnected) {
      return;
    }

    try {
      _mqtt.disconnect();
    } catch (e, stackTrace) {
      _logger.warning('MQTT disconnect failed', e, stackTrace);
      rethrow;
    }
  }

  bool isStarted() => _mqtt.connectionStatus!.state == MqttConnectionState.connected;

  /// Listens to messages on a specified MQTT topic.
  ///
  /// This function returns a stream of messages for the given topic.
  /// It subscribes to the topic and filters incoming messages to only
  /// include those that match the topic. When the stream is cancelled,
  /// it unsubscribes from the topic.
  ///
  /// The stream emits the payload of the messages as strings.
  ///
  /// [topic] - The MQTT topic to listen to.
  ///
  /// Returns a stream of message payloads as strings. The stream never emits
  /// errors — broker failures are reported and swallowed in [_subscribeReal],
  /// and the next onConnected re-attaches.
  Stream<String> subscribe(String topic) {
    if (!_experimentFlag()) {
      return const Stream<String>.empty();
    }

    final subject = _subscribeDeferred(topic);
    if (_mqtt.connectionStatus!.state == MqttConnectionState.connected) {
      _subscribeReal(topic, subject);
    }

    return subject.stream;
  }

  StreamController<String> _subscribeDeferred(String topic) {
    final subject = StreamController<String>();
    subject.onCancel = () {
      if (_subscriptions[topic] == subject) {
        _subscriptions.remove(topic);
      }
    };
    _subscriptions[topic] = subject;
    return subject;
  }

  void _subscribeReal(String topic, StreamController<String> subject) {
    // null while disconnected; the next onConnected re-attaches
    final updates = _mqtt.updates;
    if (updates == null) {
      return;
    }

    // null means the broker refused the subscription on a live connection
    // (not-connected throws instead). Retried by the next onConnected, since
    // the topic stays registered in _subscriptions.
    final sub = _mqtt.subscribe(topic, MqttQos.atLeastOnce);
    if (sub == null) {
      _logger.warning('MQTT subscribe refused for $topic');
      return;
    }

    // filter and map the messages
    final stream = updates
        // filter the messages by the topic
        .where((messages) => messages.any((message) => message.topic == topic))
        // map the messages to the payload
        .map(
          (messages) => messages
              .where((message) => message.topic == topic && message.payload is MqttPublishMessage)
              .map((message) => _deserializePayload(message.payload as MqttPublishMessage))
              .nonNulls
              .toList(),
        )
        // flatten the list of messages
        .expand((messages) => messages);

    // listen instead of addStream: onConnected re-fires on every reconnect and
    // addStream on a never-done stream cannot be called twice
    _forwards[topic]?.cancel();
    final forward = stream.listen(
      subject.add,
      onError: (Object e, StackTrace stack) =>
          _logger.warning('MQTT stream failed for $topic', e, stack),
    );
    _forwards[topic] = forward;

    // make sure to unsubscribe when the stream is cancelled
    subject.onCancel = () {
      forward.cancel();
      if (_forwards[topic] == forward) {
        _forwards.remove(topic);
      }
      if (_subscriptions[topic] == subject) {
        _subscriptions.remove(topic);
      }
      if (isStarted()) {
        _mqtt.unsubscribeSubscription(sub);
      }
    };
  }

  String? _deserializePayload(MqttPublishMessage message) {
    try {
      return MqttUtilities.bytesToStringAsString(message.payload.message!);
    } catch (e, stack) {
      _logger.warning('MQTT payload is not valid UTF-8', e, stack);
      return null;
    }
  }
}
