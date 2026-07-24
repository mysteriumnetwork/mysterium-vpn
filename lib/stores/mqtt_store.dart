import 'dart:async';
import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

// Include generated file
part 'mqtt_store.g.dart';

// ignore: library_private_types_in_public_api
class MqttStore = _MqttStore with _$MqttStore;

abstract class _MqttStore with Store {
  _MqttStore({required MQTTService mqtt, required Talker logger}) : _mqtt = mqtt, _logger = logger;

  final MQTTService _mqtt;
  final Talker _logger;
  StreamSubscription<String>? _healthcheckSub;

  @observable
  HealthcheckMessage? lastHealthcheck;

  Future<void> initStore() async {
    try {
      _healthcheckSub ??= _mqtt.subscribe('healthcheck').listen((event) {
        lastHealthcheck = HealthcheckMessage.fromJson(json.decode(event) as Map<String, dynamic>);
      });
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      rethrow;
    }
  }

  void dispose() {
    if (_healthcheckSub != null) {
      _healthcheckSub!.cancel();
    }
  }
}
