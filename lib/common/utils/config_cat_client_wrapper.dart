import 'dart:io';

import 'package:configcat_client/configcat_client.dart';
import 'package:talker/talker.dart';

class ConfigCatUtils {
  const ConfigCatUtils(
    this.remoteConfigClient,
    this.abTestingClient,
    this.textsClient,
  );

  final ConfigCatClient remoteConfigClient;
  final ConfigCatClient abTestingClient;
  final ConfigCatClient textsClient;
}

class ConfigCatClientWrapper {
  const ConfigCatClientWrapper(this._client, this._logger);

  final ConfigCatClient _client;
  final Talker _logger;

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

  void setDefaultUser({
    required String email,
    required String userId,
  }) {
    _client.setDefaultUser(
      ConfigCatUser(
        identifier: userId,
        email: email,
        custom: {
          'platform': Platform.operatingSystem,
          'platformVersion': Platform.operatingSystemVersion,
        },
      ),
    );
  }
}
