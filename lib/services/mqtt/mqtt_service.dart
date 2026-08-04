import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mqtt5_client/mqtt5_client.dart';
import 'package:mqtt5_client/mqtt5_server_client.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

class MQTTService {
  MQTTService(
    String url,
    String username,
    String password,
    String clientID,
    Talker logger,
    RemoteConfigStore remoteConfigStore,
  ) : this.withClient(
        MqttServerClient(url, clientID, maxConnectionAttempts: 2),
        url,
        username,
        password,
        logger,
        remoteConfigStore,
      );

  @visibleForTesting
  MQTTService.withClient(
    this._mqtt,
    String url,
    String username,
    String password,
    Talker logger,
    RemoteConfigStore remoteConfigStore,
  ) : _username = username,
      _password = password,
      _logger = logger,
      _remoteConfigStore = remoteConfigStore {
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
      ..onConnected = () {
        _logger.debug('MQTT connected');
        _subscriptions.forEach(_subscribeReal);
      }
      ..onAutoReconnect = () {
        _logger.verbose('MQTT reconnecting..');
      }
      ..onAutoReconnected = () {
        _logger.verbose('MQTT reconnected');
      }
      ..onDisconnected = () {
        _logger.verbose('MQTT disconnected');
      }
      ..onFailedConnectionAttempt = (attempt) {
        _logger.warning('MQTT connecting.. Attempt $attempt');
      };
    if (kDebugMode) {
      _mqtt.logging(on: true);
    }
  }

  final MqttServerClient _mqtt;
  final String _username;
  final String _password;
  final Talker _logger;
  final RemoteConfigStore _remoteConfigStore;

  final Map<String, StreamController<String>> _subscriptions = {};
  final Map<String, StreamSubscription<String>> _forwards = {};

  Future<void> start() async {
    if (!_remoteConfigStore.mqttExperiment) {
      return;
    }

    try {
      await _mqtt.connect(_username, _password);
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  void stop() {
    if (_mqtt.connectionStatus!.state != MqttConnectionState.connected) {
      return;
    }

    try {
      _mqtt.disconnect();
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
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
  /// Returns a stream of message payloads as strings.
  Stream<String> subscribe(String topic) {
    if (!_remoteConfigStore.mqttExperiment) {
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

    final sub = _mqtt.subscribe(topic, MqttQos.atLeastOnce);
    if (sub == null) {
      throw MQQTException();
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
    final forward = stream.listen(subject.add);
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
      _logger.handle(e, stack);
      return null;
    }
  }
}
