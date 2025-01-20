import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/models/ip_info.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/data/local/shared_preferences_service.dart';
import 'package:wireguard_dart/connection_status.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

part 'real_ip_info_store.g.dart';

// ignore: library_private_types_in_public_api
class RealIPInfoStore = _RealIPInfoStore with _$RealIPInfoStore;

abstract class _RealIPInfoStore with Store {
  _RealIPInfoStore(
    this._api,
    this._preferences,
    this._wireguardService,
  );

  final ApiService _api;
  final SharedPreferenceService _preferences;
  final WireguardDart _wireguardService;

  @observable
  late ObservableFuture<IPInfo?> infoFuture = ObservableFuture(_fetch());

  @computed
  IPInfo? get info => infoFuture.value;

  Future<IPInfo?> _fetch() async {
    if (await _isConnectedToVPN()) {
      // return last cached value if currently connected to VPN
      return _preferences.getIPInfo();
    }
    final info = await _api.getIPAdress();
    await _preferences.setIPInfo(info);
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
