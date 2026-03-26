import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vpn_api/vpn_api.dart';

part 'vpn_config.freezed.dart';

@freezed
abstract class VpnConfig with _$VpnConfig {
  const factory VpnConfig({
    required String id,
    required String config, // either wgConfig or ovpnConfig
    required String hash,
    String? exitIp,
    bool? limitExceeded,
    String? ipType,
    String? country,
    String? city,
    String? type, // "wireguard" or "openvpn"
  }) = _VpnConfig;

  /// Factory to map WireguardConnectResponse to VpnConfig
  factory VpnConfig.fromWireguard(WireguardConnectResponse wg) => VpnConfig(
    id: wg.id,
    config: wg.wgConfig,
    hash: wg.hash,
    exitIp: wg.exitIp,
    limitExceeded: wg.limitExceeded,
    ipType: wg.ipType,
    country: wg.country,
    city: wg.city,
    type: 'wireguard',
  );

  /// Factory to map OpenVpnConnectResponse to VpnConfig
  factory VpnConfig.fromOpenVpn(OpenVpnConnectResponse ovpn) => VpnConfig(
    id: ovpn.id,
    config: ovpn.ovpnConfig,
    hash: ovpn.hash,
    exitIp: ovpn.exitIp,
    limitExceeded: ovpn.limitExceeded,
    ipType: ovpn.ipType,
    country: ovpn.country,
    city: ovpn.city,
    type: 'openvpn',
  );
}
