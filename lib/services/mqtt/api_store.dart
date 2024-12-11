import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/services/mqtt/service.dart';
import 'package:vpn_api/vpn_api.dart';

// Include generated file
part 'api_store.g.dart';

// ignore: library_private_types_in_public_api
class ApiStore = _ApiStore with _$ApiStore;

abstract class _ApiStore with Store {
  _ApiStore({required MqttService mqtt}) : _mqtt = mqtt;

  final MqttService _mqtt;

  @readonly
  HealthcheckResponse? _healthcheck;

  @action
  void initStore() {
    _mqtt.listen('healthcheck').listen((event) {
      _healthcheck = HealthcheckResponse.fromJson(json.decode(event) as Map<String, dynamic>);
    });
  }
}
