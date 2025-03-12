import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/services/mqtt/service.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

// Include generated file
part 'api_store.g.dart';

// ignore: library_private_types_in_public_api
class ApiStore = _ApiStore with _$ApiStore;

abstract class _ApiStore with Store {
  _ApiStore({
    required MQTTService mqtt,
    required Talker logger,
  })  : _mqtt = mqtt,
        _logger = logger;

  final MQTTService _mqtt;
  final Talker _logger;
  StreamSubscription<String>? _healthcheckSub;

  @readonly
  HealthcheckMessage? _lastHealthcheck;

  Future<void> initStore() async {
    try {
      _healthcheckSub ??= _mqtt.subscribe('healthcheck').listen((event) {
        _lastHealthcheck = HealthcheckMessage.fromJson(json.decode(event) as Map<String, dynamic>);
      });
    } catch (e, stackTrace) {
      _logger.handle(e, stackTrace);
      showSnackbar(LocaleKeys.somethingWentWrong.tr());
      rethrow;
    }
  }

  void dispose() {
    if (_healthcheckSub != null) {
      _healthcheckSub!.cancel();
    }
  }
}
