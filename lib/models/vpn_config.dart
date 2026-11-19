import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vpn_api/vpn_api.dart';

part 'vpn_config.freezed.dart';

@freezed
abstract class VpnConfig with _$VpnConfig {
  const factory VpnConfig({
    required String id,
    required String config, // wgConfig, ovpnConfig, or a vless:// URI
    required String hash,
    String? exitIp,
    String? sessionId,
    bool? limitExceeded,
    String? ipType,
    String? country,
    String? city,
    String? type, // "wireguard", "openvpn" or "vless"
  }) = _VpnConfig;

  /// Factory to map WireguardConnectResponse to VpnConfig
  factory VpnConfig.fromWireguard(WireguardConnectResponse wg) => VpnConfig(
    id: wg.id,
    config: wg.wgConfig,
    hash: wg.hash,
    exitIp: wg.exitIp,
    sessionId: wg.sessionId,
    limitExceeded: wg.limitExceeded,
    ipType: wg.ipType,
    country: wg.country,
    city: wg.city,
    type: 'wireguard',
  );

  /// Factory to map VlessConnectResponse to VpnConfig
  ///
  /// `config` carries the raw `vless://` URI; vless_dart parses it.
  factory VpnConfig.fromVless(VlessConnectResponse vless) => VpnConfig(
    id: vless.id,
    config: vless.vlessUri,
    hash: vless.hash,
    exitIp: vless.exitIp,
    sessionId: vless.sessionId,
    limitExceeded: vless.limitExceeded,
    ipType: vless.ipType,
    country: vless.country,
    city: vless.city,
    type: 'vless',
  );

  /// Factory to map OpenVpnConnectResponse to VpnConfig
  factory VpnConfig.fromOpenVpn(OpenVpnConnectResponse ovpn) => VpnConfig(
    id: ovpn.id,
    config: ovpn.ovpnConfig,
    hash: ovpn.hash,
    exitIp: ovpn.exitIp,
    sessionId: ovpn.sessionId,
    limitExceeded: ovpn.limitExceeded,
    ipType: ovpn.ipType,
    country: ovpn.country,
    city: ovpn.city,
    type: 'openvpn',
  );
}
