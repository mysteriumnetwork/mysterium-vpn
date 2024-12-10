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

  Stream<String> listen(String topic) {
    final stream = StreamController<String>();

    _mqtt.subscribe(topic, MqttQos.atLeastOnce);
    // TODO(Waldz): This library support once stream for all subscriptions, would be good to run only one listen loop
    _mqtt.updates!.listen(_onMessage(topic, stream));

    return stream.stream;
  }

  void Function(List<MqttReceivedMessage<MqttMessage?>>? c) _onMessage(
    String topicExpected,
    StreamController<String> topicStream,
  ) =>
      (List<MqttReceivedMessage<MqttMessage?>>? c) {
        try {
          if (c == null) {
            _logger.warning('MQTT topic empty');
            return;
          }
          if (c[0].payload == null) {
            _logger.warning('MQTT payload empty');
            return;
          }
          final topic = c[0].topic;
          final topicMessage = c[0].payload! as MqttPublishMessage;

          final topicPayload =
              MqttPublishPayload.bytesToStringAsString(topicMessage.payload.message);
          _logger.debug('MQTT message. <$topic> $topicPayload');

          if (topic == topicExpected) {
            topicStream.add(topicPayload);
          }
        } catch (e, stackTrace) {
          _logger.handle(e, stackTrace);
        }
      };
}
