import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:talker/talker.dart';

class MqttService {
  MqttService(String url, String clientID, Talker logger)
      : _mqtt = MqttServerClient(url, clientID),
        _logger = logger {
    final uri = Uri.parse(url);
    _mqtt
      ..port = uri.port
      ..autoReconnect = true
      ..useWebSocket = true
      ..keepAlivePeriod = 60 * 5
      ..resubscribeOnAutoReconnect = true
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
  final Talker _logger;

  Future<void> start() async {
    try {
      await _mqtt.connect();
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
    }
  }

  void stop() {
    try {
      _mqtt.disconnect();
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
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
  Stream<String> listen(String topic) => Stream.multi(
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
                    .where((message) => message.topic == topic)
                    .where((message) => message.payload is MqttPublishMessage)
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

  String? _deserializePayload(MqttPublishMessage message) {
    try {
      return MqttPublishPayload.bytesToStringAsString(message.payload.message);
    } catch (e, stack) {
      _logger.handle(e, stack);
      return null;
    }
  }
}
