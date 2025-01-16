import 'dart:io';

import 'package:configcat_client/configcat_client.dart';
import 'package:mysterium_vpn/models/ip_info.dart';
import 'package:talker/talker.dart';

class ConfigCatService {
  ConfigCatService(
    this.remoteConfigClient,
    this.abTestingClient,
    this.textsClient,
    this._logger,
  );

  final ConfigCatClient remoteConfigClient;
  final ConfigCatClient abTestingClient;
  final ConfigCatClient textsClient;
  final Talker _logger;

  IPInfo? _originIP;
  String? _identifier;
  String? _email;

  Future<Map<String, dynamic>> _fetch(ConfigCatClient client) async {
    try {
      return await client.getAllValues();
    } catch (e, stack) {
      _logger.handle(e, stack);
      return {};
    }
  }

  void _watch(ConfigCatClient client, Function() callback) {
    client.hooks.clear();
    client.hooks.addOnConfigChanged((_) => callback());
  }

  Future<Map<String, dynamic>> fetchRemoteConfig() => _fetch(remoteConfigClient);

  Future<Map<String, dynamic>> fetchABTesting() => _fetch(abTestingClient);

  Future<Map<String, dynamic>> fetchTexts() => _fetch(textsClient);

  void watchRemoteConfig(Function() callback) => _watch(remoteConfigClient, callback);

  void watchABTesting(Function() callback) => _watch(abTestingClient, callback);

  void watchTexts(Function() callback) => _watch(textsClient, callback);

  void _setUser() {
    if (_identifier == null) {
      return;
    }

    final user = ConfigCatUser(
      identifier: _identifier!,
      email: _email,
      country: _originIP?.country,
      custom: {
        'platform': Platform.operatingSystem,
        'platformVersion': Platform.operatingSystemVersion,
        if (_originIP != null) 'city': _originIP!.city,
      },
    );

    _logger.info('Setting ConfigCatUser: $user');

    remoteConfigClient.setDefaultUser(user);
    abTestingClient.setDefaultUser(user);
    textsClient.setDefaultUser(user);
  }

  void setUserInfo({required String identifier, required String email}) {
    _identifier = identifier;
    _email = email;
    _setUser();
  }

  void setOriginIP(IPInfo? originIP) {
    _originIP = originIP;
    _setUser();
  }

  void clearUser() {
    _identifier = null;
    _email = null;
    remoteConfigClient.clearDefaultUser();
    abTestingClient.clearDefaultUser();
    textsClient.clearDefaultUser();
  }
}
