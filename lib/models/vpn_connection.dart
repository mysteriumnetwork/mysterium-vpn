import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysterium_vpn/models/location.dart';

part 'vpn_connection.freezed.dart';
part 'vpn_connection.g.dart';

@freezed
class VpnConnection with _$VpnConnection {
  const factory VpnConnection({
    required String connectionIP,
    required Location location,
  }) = _VpnConnection;

  factory VpnConnection.fromJson(Map<String, Object?> json) => _$VpnConnectionFromJson(json);
}
