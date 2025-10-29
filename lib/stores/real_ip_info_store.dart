import 'dart:async';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/analytics_user_property.dart';
import 'package:mysterium_vpn/models/ip_info.dart';
import 'package:mysterium_vpn/services/api/external_api_service.dart';
import 'package:mysterium_vpn/services/data/local/shared_preferences_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

part 'real_ip_info_store.g.dart';

// ignore: library_private_types_in_public_api
class RealIPInfoStore = _RealIPInfoStore with _$RealIPInfoStore;

abstract class _RealIPInfoStore with Store {
  _RealIPInfoStore(
    this._api,
    this._preferences,
    this._wireguardService,
    this._analyticsStore,
  ) {
    infoFuture = ObservableFuture(_fetch());
  }
  final ExternalApiService _api;
  final SharedPreferenceService _preferences;
  final WireguardDart _wireguardService;
  final AnalyticsStore _analyticsStore;

  @observable
  late ObservableFuture<IPInfo?> infoFuture;

  @computed
  IPInfo? get info => infoFuture.value;

  Future<IPInfo?> _fetch() async {
    IPInfo? info;
    if (await _isConnectedToVPN()) {
      // return last cached value if currently connected to VPN
      info = _preferences.getIPInfo();
    } else {
      info = await _api.getIPInfo();
      await _preferences.setIPInfo(info);
    }
    if (info != null) {
      unawaited(
        _analyticsStore.setUserProperty(
          AnalyticsUserProperty.fromEnum(
            name: AnalyticsUserPropName.countryUser,
            value: info.country,
          ),
        ),
      );
    }
    return info;
  }

  @action
  Future<void> refresh() async {
    infoFuture = ObservableFuture(_fetch());
    await infoFuture;
  }

  Future<bool> _isConnectedToVPN() async {
    final status = await _wireguardService.status();
    return status != ConnectionStatus.disconnected && status != ConnectionStatus.unknown;
  }
}
