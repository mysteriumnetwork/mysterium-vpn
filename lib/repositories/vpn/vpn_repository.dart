import 'package:mysterium_vpn/common/enums/vpn_connection_status.dart';
import 'package:mysterium_vpn/models/vpn_config.dart';
import 'package:vpn_api/vpn_api.dart';

abstract class VpnRepository {
  Future<void> setupTunnel();
  Future<void> connect({
    required String config,
  });
  Future<bool> disconnectFromVpn();
  Future<bool> isTunnelConfigured();
  Stream<VpnConnectionStatus> statusStream();
  Future<VpnConnectionStatus> currentStatus();
  Future<void> removeTunnelConfiguration();
  Future<void> init();
  Future<void> notifyApiVpnDisconnected();
  Future<void> rateConnection({
    required String ipType,
    required String country,
    required String? feedback,
    required String? reasons,
    required RateConnectionRequestModeEnum mode,
  });
  Future<VpnConfig> fetchVpnConfig({
    required String? countryOriginate,
    required String? country,
    required String? city,
    required String? ipType,
    required String? userIntent,
    required String? cluster,
    required bool? resetConnection,
  });
  Future<void> resetApp();
}
