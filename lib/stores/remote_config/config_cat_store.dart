import 'dart:async';

import 'package:configcat_client/configcat_client.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/stores/remote_config/config_cat_user_store.dart';
import 'package:talker/talker.dart';

abstract class ConfigCatStore with Store {
  ConfigCatStore(this._client, this.logger) {
    _init();
  }

  final ConfigCatClient _client;
  @protected
  final Talker logger;

  final Completer<void> _initUserCompleter = Completer<void>();
  ConfigCatUser? _user;

  @readonly
  late ObservableFuture<Map<String, dynamic>> configFuture = ObservableFuture(_fetchCached());

  @computed
  Map<String, dynamic> get config => configFuture.value ?? {};

  @action
  Future<void> _init() async {
    await configFuture;
    await refresh();
  }

  Future<void> refresh() async {
    try {
      configFuture = configFuture.replace(_fetch());
      await configFuture;
    } catch (e, stack) {
      logger.handle(e, stack);
    }
  }

  Future<void> setUser(ConfigCatUser user) async {
    final current = _user;
    _user = user;
    _client.setDefaultUser(user);
    if (!_initUserCompleter.isCompleted) {
      _initUserCompleter.complete();
    }

    // Refresh config only if the user has changed
    if (current != null && !current.equals(user)) {
      await refresh();
    }
  }

  Future<ConfigCatUser> _fetchUser() async {
    await _initUserCompleter.future;
    return _user!;
  }

  @protected
  Future<Map<String, dynamic>> _fetch() async {
    try {
      await _fetchUser();

      final result = await _client.forceRefresh();
      if (!result.isSuccess) {
        logger.warning('Failed to refresh ConfigCat: ${result.error}');
      }

      return await _client.getAllValues();
    } catch (e, stack) {
      logger.handle(e, stack);
      return {};
    }
  }

  Future<Map<String, dynamic>> _fetchCached() async {
    try {
      await _fetchUser();
      return await _client.getAllValues();
    } catch (e, stack) {
      logger.handle(e, stack);
      return {};
    }
  }
}
