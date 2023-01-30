// Flutter imports:
// Package imports:
import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/vpn_connection.dart';

// Project imports:

part 'vpn_store.g.dart';

// ignore: library_private_types_in_public_api
class VpnStore = _VpnStore with _$VpnStore;

abstract class _VpnStore with Store {
  _VpnStore();

  static const VpnConnection _emptyConnection =
      VpnConnection(connectionIP: '--', connectionStatus: ConnectionStatus.disconnected, location: '--');

  @readonly
  VpnConnection _vpnConnection = _emptyConnection;

  @readonly
  String? _countryFlag;

  @action
  Future<void> connect() async {
    await Future.delayed(const Duration(seconds: 1));
    _vpnConnection = const VpnConnection(
      connectionIP: '185.358.45.304',
      connectionStatus: ConnectionStatus.connected,
      location: 'Austria',
    );
  }

  @action
  Future<void> disconnect() async {
    await Future.delayed(const Duration(seconds: 1));
    _vpnConnection = _emptyConnection;
  }

  @action
  void setCountryFlag() {
    _countryFlag = availableFlags.firstWhereOrNull(
      (element) => element.contains(_vpnConnection.location.toLowerCase()),
    );
  }
}
