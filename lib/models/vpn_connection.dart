import 'package:freezed_annotation/freezed_annotation.dart';

part 'vpn_connection.freezed.dart';

@freezed
class VpnConnection with _$VpnConnection {
  const factory VpnConnection({
    required String connectionIP,
    required String location,
  }) = _VpnConnection;
}
