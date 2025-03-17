import 'dart:io';

import 'package:collection/collection.dart';
import 'package:configcat_client/configcat_client.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/models/ip_info.dart';
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
  }

  Future<void> refresh() async {
    try {
      configFuture = configFuture.replace(_fetch());
      await configFuture;
    } catch (e, stack) {
      _logger.handle(e, stack);
    }
  }

  @protected
  Future<Map<String, dynamic>> _fetch() async {
    try {
      final user = await _fetchUser();
      _client.setDefaultUser(user);
      _user = user;

      final res = await _client.forceRefresh();
      if (!res.isSuccess) {
        _logger.warning('Failed to refresh ConfigCat: ${res.error}');
      }

      return await _client.getAllValues();
    } catch (e, stack) {
      _logger.handle(e, stack);
      return {};
    }
  }

  Future<ConfigCatUser> _fetchUser() async {
    final platform = Platform.operatingSystem;
    (String id, String email) user;
    try {
      var [identifier, email] = await Future.wait([
        SecureStorageService.instance.getUserId(),
        SecureStorageService.instance.getUsername(),
      ]);
      if (identifier == null || identifier.isEmpty) {
        identifier = 'anonymous';
      }
      if (email == null || email.isEmpty) {
        email = 'anonymous';
      }
      user = (identifier, email);
    } catch (e, stack) {
      _logger.handle(e, stack);
      user = ('anonymous', 'anonymous');
    }

    IPInfo? ipInfo;
    try {
      ipInfo = SharedPreferenceService.instance.getIPInfo();
    } catch (e, stack) {
      _logger.handle(e, stack);
      ipInfo = null;
    }

    String? version;
    try {
      version = await PackageInfo.fromPlatform().then((value) => value.version);
    } catch (e, stack) {
      _logger.handle(e, stack);
      version = null;
    }

    return ConfigCatUser(
      identifier: user.$1,
      email: user.$2,
      country: ipInfo?.country,
      custom: {
        'platform': platform,
        if (version != null) 'version': version,
        if (ipInfo?.city != null) 'city': ipInfo!.city,
      },
    );
  }

  @action
  Future<void> notifyUserChanged() async {
    final user = await _fetchUser();
    if (!user.equals(_user)) {
      _client.setDefaultUser(user);
      _user = user;

      // TODO(dmacan): re-fetch config on user info change if needed. right now we're not doing that in order to reduce number of requests towards ConfigCat service
      // configFuture = ObservableFuture(_fetch());
      // await configFuture;
    }
  }
}

extension _ConfigCatUserExtension on ConfigCatUser {
  static const nativeKeys = ['Identifier', 'Email', 'Country'];
  static const customKeys = ['platform', 'version', 'city'];

  Map<String, dynamic> toMap() {
    const keys = [...nativeKeys, ...customKeys];

    return {for (final key in keys) key: getAttribute(key)};
  }

  bool equals(ConfigCatUser? user) =>
      user != null && const MapEquality().equals(toMap(), user.toMap());
}
