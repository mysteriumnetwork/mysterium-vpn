// Flutter imports:
// Package imports:
import 'dart:async';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/mock.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/models/vpn_config.dart';
import 'package:mysterium_vpn/models/vpn_connection.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/secured_storage_service.dart';
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
    generateKey();
  }

  static const VpnConnection _emptyConnection = VpnConnection(
    connectionIP: '--',
    location: '--',
  );

  final ApiService _apiService;
  final LocationsStore _locationsStore;
  final WireguardDart _wireguardService;
  final _securedStorage = SecureStorageService();

  final random = Random();

  Timer? _timer;

  @observable
  ObservableFuture<void> setupTunnelFuture = ObservableFuture.value(null);

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
  String _privateKey = '';

  @readonly
  String _publicKey = '';

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
    setupTunnelFuture =
        ObservableFuture(_wireguardService.setupTunnel(bundleId: 'com.mysteriumvpn.tun'));
    await setupTunnelFuture;
  }

  @action
  Future<void> generateKey() async {
    if (await _securedStorage.checkExistance(StorageKeys.wireguardPrivateKey.value) &&
        await _securedStorage.checkExistance(StorageKeys.wireguardPublicKey.value)) {
      _privateKey = await _securedStorage.read(StorageKeys.wireguardPrivateKey.value);
      _publicKey = await _securedStorage.read(StorageKeys.wireguardPublicKey.value);
    } else {
      final res = await _wireguardService.generateKeyPair();
      _privateKey = res['privateKey'] ?? '';
      _publicKey = res['publicKey'] ?? '';
      await _securedStorage.write(StorageKeys.wireguardPrivateKey.value, _privateKey);
      await _securedStorage.write(StorageKeys.wireguardPublicKey.value, _publicKey);
    }
  }

  @action
  Future<void> connectWireguard() async {
    final config = _vpnConfig?.config;
    if (config == null) {
      return;
    }
    await _wireguardService.connect(cfg: config);
  }

  @action
  Future<void> disconnectWireguard() async {
    await _wireguardService.disconnect();
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
    try {
      if (_vpnConnection != _emptyConnection) {
        await disconnect();
      }
      _connectionStatus = ConnectionStatus.connecting;
      _vpnConfig = await _apiService.fetchVpnConfig(
        input: VpnConfigInput(
          publicKey: _publicKey,
          country: location.countryCode,
        ),
        privateKey: _privateKey,
      );

      debugPrint(_vpnConfig?.config);
      await connectWireguard();

      _vpnConnection = VpnConnection(
        connectionIP: '185.358.45.304',
        location: location.countryCode,
      );
      _connectionStatus = ConnectionStatus.connected;
      startTracking();
      _apiService.setRecentLocation(location: location.countryCode);
      _locationsStore.fetchRecentLocations();
    } catch (e) {
      _connectionStatus = ConnectionStatus.disconnected;
    }
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
    _connectionStatus = ConnectionStatus.disconnecting;
    await Future.delayed(const Duration(seconds: 1));
    await disconnectWireguard();
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
