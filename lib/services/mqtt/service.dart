import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mysterium_vpn/common/exceptions/authentication_required.dart';
import 'package:mysterium_vpn/services/auth/auth_session_store.dart';
import 'package:mysterium_vpn/services/mqtt/exceptions.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:talker/talker.dart';

class MQTTService {
  MQTTService(
    String url,
    String clientID,
    AuthSessionStore authSession,
    Talker logger,
    RemoteConfigStore remoteConfigStore,
  )   : _mqtt = MqttServerClient(url, clientID),
        _authSession = authSession,
        _logger = logger,
        _remoteConfigStore = remoteConfigStore {
    final uri = Uri.parse(url);

    // Client ID length can not exceed 23, see http://docs.oasis-open.org/mqtt/mqtt/v3.1.1/os/mqtt-v3.1.1-os.html
    if (clientID.length > 23) {
      throw MQQTException();
    }

    _mqtt
      ..port = uri.port
      ..autoReconnect = true
      ..resubscribeOnAutoReconnect = true
      ..useWebSocket = true
      ..keepAlivePeriod = 60 * 5
      ..onConnected = () {
        _logger.debug('MQTT connected');
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
  final AuthSessionStore _authSession;
  final Talker _logger;
  final RemoteConfigStore _remoteConfigStore;

  Future<void> start() async {
    if (!_remoteConfigStore.mqttExperiment) {
      return;
    }

    try {
      if (_authSession.accessToken == null) {
        throw AuthenticationRequiredException();
      }

      await _mqtt.connect('dvpn', _authSession.accessToken);
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  void stop() {
    if (!_remoteConfigStore.mqttExperiment) {
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

  Future<void> ensureStart() async {
    if (!_remoteConfigStore.mqttExperiment) {
      return;
    }

    if (!isStarted()) {
      await start();
    }
  }

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

    if (_mqtt.connectionStatus!.state != MqttConnectionState.connected) {
      throw MQQTConnectionRequiredException();
    }

    return Stream.multi(
      (subject) async {
        // make sure to unsubscribe when the stream is cancelled
        subject.onCancel = () => _mqtt.unsubscribe(topic);

        _mqtt.subscribe(topic, MqttQos.atLeastOnce);
        // filter and map the messages
        final stream = _mqtt.updates!
            // filter the messages by the topic
            .where((messages) => messages.any((message) => message.topic == topic))
            // map the messages to the payload
            .map(
              (messages) => messages
                  .where(
                    (message) => message.topic == topic && message.payload is MqttPublishMessage,
                  )
                  .map((message) => _deserializePayload(message.payload as MqttPublishMessage))
                  .nonNulls
                  .toList(),
            )
            // flatten the list of messages
            .expand((messages) => messages);

        // add the stream to the subject
        await subject.addStream(stream);
      },
    );
  }

  String? _deserializePayload(MqttPublishMessage message) {
    try {
      return MqttPublishPayload.bytesToStringAsString(message.payload.message);
    } catch (e, stack) {
      _logger.handle(e, stack);
      return null;
    }
  }
}
