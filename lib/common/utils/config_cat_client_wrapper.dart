import 'dart:io';

import 'package:configcat_client/configcat_client.dart';
import 'package:mysterium_vpn/stores/real_ip_info_store.dart';
import 'package:talker/talker.dart';

class ConfigCatClientWrapper {
  const ConfigCatClientWrapper(
    this._client,
    this._logger,
    this._realIPInfoStore,
  );

  final ConfigCatClient _client;
  final Talker _logger;
  final RealIPInfoStore _realIPInfoStore;

  Future<Map<String, dynamic>> fetch() async {
    try {
      return await _client.getAllValues();
    } catch (e, stack) {
      _logger.handle(e, stack);
      return {};
    }
  }

  void watch(Function() callback) {
    _client.hooks.clear();
    _client.hooks.addOnConfigChanged((_) => callback());
  }

  Future<void> setDefaultUser({
    required String email,
    required String userId,
  }) async {
    final ipInfo = await _realIPInfoStore.infoFuture;
    _client.setDefaultUser(
      ConfigCatUser(
        identifier: userId,
        email: email,
        custom: {
          'platform': Platform.operatingSystem,
          'platformVersion': Platform.operatingSystemVersion,
          if (ipInfo != null) 'country': ipInfo.country,
          if (ipInfo != null) 'city': ipInfo.city,
        },
      ),
    );
  }
}
