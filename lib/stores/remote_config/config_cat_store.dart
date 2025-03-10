import 'dart:io';

import 'package:collection/collection.dart';
import 'package:configcat_client/configcat_client.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/services/data/local/secured_storage_service.dart';
import 'package:mysterium_vpn/services/data/local/shared_preferences_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:talker/talker.dart';

abstract class ConfigCatStore with Store {
  ConfigCatStore(
    this._client,
    this._logger,
  ) {
    _init();
  }

  final ConfigCatClient _client;
  final Talker _logger;

  @readonly
  late ObservableFuture<Map<String, dynamic>> configFuture = ObservableFuture(_fetch());

  @computed
  Map<String, dynamic> get config => configFuture.value ?? {};

  ConfigCatUser? _user;

  @action
  Future<void> _init() async {
    await configFuture;
    _client.hooks.clear();
    _client.hooks.addOnConfigChanged((_) => configFuture = ObservableFuture(_fetch()));
  }

  @protected
  Future<Map<String, dynamic>> _fetch() async {
    try {
      final user = await _fetchUser();
      if (!user.equals(_user)) {
        _client.setDefaultUser(user);
        _user = user;
      }
      return await _client.getAllValues();
    } catch (e, stack) {
      _logger.handle(e, stack);
      return {};
    }
  }

  Future<ConfigCatUser?> _fetchUser() async {
    try {
      final [identifier, email] = await Future.wait([
        SecureStorageService.instance.getUserId(),
        SecureStorageService.instance.getUsername(),
      ]);

      if (identifier == null) {
        return null;
      }

      final ipInfo = SharedPreferenceService.instance.getIPInfo();
      return ConfigCatUser(
        identifier: identifier,
        email: email,
        country: ipInfo?.country,
        custom: {
          'platform': Platform.operatingSystem,
          'version': await PackageInfo.fromPlatform().then((value) => value.version),
          if (ipInfo?.city != null) 'city': ipInfo!.city,
        },
      );
    } catch (e, stack) {
      _logger.handle(e, stack);
      return null;
    }
  }

  @action
  Future<void> notifyUserChanged() async {
    final user = await _fetchUser();
    if (!user.equals(_user)) {
      _client.setDefaultUser(user);
      _user = user;
      configFuture = ObservableFuture(_fetch());
      await configFuture;
    }
  }
}

extension _ConfigCatUserExtension on ConfigCatUser {
  Map<String, dynamic> toMap() {
    const keys = [
      // native
      'Identifier',
      'Email',
      'Country',
      // custom
      'platform',
      'version',
      'city',
    ];

    return {for (final key in keys) key: getAttribute(key)};
  }

  bool equals(ConfigCatUser user) => const MapEquality().equals(toMap(), user.toMap());
}

extension _NullishConfigCatUserExtension on ConfigCatUser? {
  bool equals(ConfigCatUser? other) {
    if (this == null && other == null) {
      return true;
    }
    if (this == null || other == null) {
      return false;
    }
    return this!.equals(other);
  }
}
