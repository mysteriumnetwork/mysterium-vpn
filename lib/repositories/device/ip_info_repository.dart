import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/data/storage.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

/// Single source of truth for the user's real (untunnelled) IP info.
// ignore: one_member_abstracts
abstract class IpInfoRepository {
  /// The user's real IP info.
  ///
  /// While a tunnel is up the cached value is returned instead of a live
  /// lookup, which would report the exit node rather than the user.
  Future<IPInfo?> resolve();
}

/// [IpInfoRepository] backed by the external IP API, cached in
/// [SharedPreferenceService].
class RestIpInfoRepository implements IpInfoRepository {
  RestIpInfoRepository({
    required ExternalApiService api,
    required SharedPreferenceService preferences,
    required WireguardDart wireguardService,
  }) : _api = api,
       _preferences = preferences,
       _wireguardService = wireguardService;

  final ExternalApiService _api;
  final SharedPreferenceService _preferences;
  final WireguardDart _wireguardService;

  @override
  Future<IPInfo?> resolve() async {
    if (await _isConnectedToVPN()) {
      return _preferences.getIPInfo();
    }
    final info = await _api.getIPInfo();
    await _preferences.setIPInfo(info);
    return info;
  }

  Future<bool> _isConnectedToVPN() async {
    final status = await _wireguardService.status();
    return status != ConnectionStatus.disconnected && status != ConnectionStatus.unknown;
  }
}
