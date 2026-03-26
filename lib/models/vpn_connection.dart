import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysterium_vpn/models/models.dart';

part 'vpn_connection.freezed.dart';

@freezed
abstract class VpnConnection with _$VpnConnection {
  const factory VpnConnection({required String connectionIP, required VPNLocation location}) =
      _VpnConnection;

  const VpnConnection._();

  bool get isResolvingconnectionIP => connectionIP.isEmpty;
}
