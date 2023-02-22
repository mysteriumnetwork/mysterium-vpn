// Flutter imports:
// Package imports:
import 'dart:async';
import 'dart:math';

import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/mock.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/vpn_connection.dart';

// Project imports:

part 'vpn_store.g.dart';

// ignore: library_private_types_in_public_api
class VpnStore = _VpnStore with _$VpnStore;

abstract class _VpnStore with Store {
  _VpnStore();

  static const VpnConnection _emptyConnection = VpnConnection(
    connectionIP: '--',
    connectionStatus: ConnectionStatus.disconnected,
    location: '--',
  );

  final random = Random();

  Timer? _timer;

  @readonly
  Duration? _duration;
  @readonly
  double? _uploadSpeed;
  @readonly
  double? _downloadSpeed;
  @readonly
  String _protocol = protocols.first;
  @readonly
  bool _killSwitch = true;

  @readonly
  VpnConnection _vpnConnection = _emptyConnection;

  @computed
  bool get isConnected => _vpnConnection.connectionStatus == ConnectionStatus.connected;

  @action
  Future<void> connect(String? country) async {
    if (_vpnConnection.location == country) {
      return;
    }
    if (_vpnConnection != _emptyConnection) {
      await disconnect();
    }
    await Future.delayed(const Duration(seconds: 1));
    _vpnConnection = VpnConnection(
      connectionIP: '185.358.45.304',
      connectionStatus: ConnectionStatus.connected,
      location: country ?? 'Austria',
    );
    await startTracking();
  }

  @action
  Future<void> changeProtocol(String protocol) async {
    _protocol = protocol;
  }

  @action
  Future<void> toggleKillSwitch() async {
    _killSwitch = !_killSwitch;
  }

  @action
  Future<void> startTracking() async {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      _duration = Duration(seconds: (_duration?.inSeconds ?? 0) + 1);
      _uploadSpeed = random.nextDouble() * 600;
      _downloadSpeed = random.nextDouble() * 600;
    });
  }

  @action
  Future<void> disconnect() async {
    await Future.delayed(const Duration(seconds: 1));
    _vpnConnection = _emptyConnection;
    _timer?.cancel();
    _downloadSpeed = null;
    _uploadSpeed = null;
    _duration = null;
  }

  Future<void> dispose() async {
    _timer?.cancel();
  }
}
