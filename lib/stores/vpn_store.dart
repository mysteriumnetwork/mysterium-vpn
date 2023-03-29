// Flutter imports:
// Package imports:
import 'dart:async';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/mock.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/models/vpn_config.dart';
import 'package:mysterium_vpn/models/vpn_connection.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

// Project imports:

part 'vpn_store.g.dart';

// ignore: library_private_types_in_public_api
class VpnStore = _VpnStore with _$VpnStore;

abstract class _VpnStore with Store {
  _VpnStore({
    required ApiService apiService,
    required LocationsStore locationsStore,
    required WireguardDart wireguardService,
  })  : _apiService = apiService,
        _locationsStore = locationsStore,
        _wireguardService = wireguardService {
    _vpnConnection = _emptyConnection;
    _connectionStatus = ConnectionStatus.disconnected;
    _duration = Duration.zero;
    _uploadSpeed = 0;
    _downloadSpeed = 0;
    _protocol = protocols.first;
    _killSwitch = true;
    _connectingLocationCode = '';
    setupTunnel();
  }

  static const VpnConnection _emptyConnection = VpnConnection(
    connectionIP: '--',
    location: '--',
  );

  final ApiService _apiService;
  final LocationsStore _locationsStore;
  final WireguardDart _wireguardService;
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

  @readonly
  VpnConfig? _vpnConfig;

  @readonly
  ConnectionStatus _connectionStatus = ConnectionStatus.disconnected;

  @computed
  bool get isConnected => _connectionStatus == ConnectionStatus.connected;
  @computed
  bool get isLoading =>
      _connectionStatus == ConnectionStatus.disconnecting ||
      _connectionStatus == ConnectionStatus.connecting;
  @readonly
  String _connectingLocationCode = '';

  @action
  Future<void> setupTunnel() async {
    try {
      await _wireguardService.setupTunnel(bundleId: 'com.mysteriumvpn.tun');
    } catch (e) {
      print(e);
    }
  }

  @action
  Future<void> generateKey() async {
    try {
      final res = await _wireguardService.generatePrivateKey();
      debugPrint(res.toString());
    } catch (e) {
      print(e);
    }
  }

  @action
  Future<void> connectWireguard() async {
    final config = _vpnConfig?.config;
    if (config == null) {
      return;
    }
    try {
      await _wireguardService.connect(cfg: config);
    } catch (e) {
      print(e);
    }
  }

  @action
  Future<void> disconnectWireguard() async {
    try {
      await _wireguardService.disconnect();
    } catch (e) {
      print(e);
    }
  }

  @action
  Future<void> connect({
    Location? location,
  }) async {
    if (_vpnConnection.location == location?.countryCode) {
      return;
    }
    location ??= Location(
      countryCode: 'DE',
      countryName: 'DE'.tr(),
    );
    _connectingLocationCode = location.countryCode;
    if (_vpnConnection != _emptyConnection) {
      await disconnect();
    }
    _connectionStatus = ConnectionStatus.connecting;
    // _vpnConfig = await _apiService.fetchVpnConfig(
    //   input: VpnConfigInput(
    //     publicKey: 'aJxmamM5IUbxkevqSGcOIASETCxeRl71iXPVbqT1gz0=',
    //     country: location.countryCode,
    //   ),
    // );
    const staticConfig = '''
    [Interface]
      PrivateKey = CD+RJ5YOaff004qq4BZCAx1QwD07qOKxJ9zSaTs/Olc=
      Address = 172.21.123.5/32
      DNS = 172.21.123.1
    [Peer]
      PublicKey = xo72tCDvCDjMxNZJ4buAWOlfhI0L4fPIxhcvpZwc/hs=
      AllowedIPs = 0.0.0.0/0
      Endpoint = 157.90.228.151:26611
      PersistentKeepalive = 15
    ''';
    _vpnConfig = const VpnConfig(config: staticConfig);
    print(_vpnConfig);
    connectWireguard();

    _vpnConnection = VpnConnection(
      connectionIP: '185.358.45.304',
      location: location.countryCode,
    );
    _connectionStatus = ConnectionStatus.connected;
    _apiService.setRecentLocation(location: location.countryCode);
    Future.delayed(const Duration(seconds: 1), _locationsStore.fetchRecentLocations);
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
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _duration = Duration(seconds: (_duration?.inSeconds ?? 0) + 1);
      _uploadSpeed = random.nextDouble() * 600;
      _downloadSpeed = random.nextDouble() * 600;
    });
  }

  @action
  Future<void> disconnect() async {
    disconnectWireguard();
    _connectionStatus = ConnectionStatus.disconnecting;
    await Future.delayed(const Duration(seconds: 1));
    _vpnConnection = _emptyConnection;
    _timer?.cancel();
    _downloadSpeed = null;
    _uploadSpeed = null;
    _duration = null;
    _connectionStatus = ConnectionStatus.disconnected;
  }

  Future<void> dispose() async {
    _timer?.cancel();
  }
}
