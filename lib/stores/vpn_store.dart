// Flutter imports:
// Package imports:
import 'dart:async';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/mock.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/exceptions/wireguard_connect.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/models/vpn_config.dart';
import 'package:mysterium_vpn/models/vpn_connection.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/secured_storage_service.dart';
import 'package:mysterium_vpn/stores/analytics_store.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
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
    required AnalyticsStore analyticsStore,
    required SubscriptionStore subscriptionStore,
  })  : _apiService = apiService,
        _locationsStore = locationsStore,
        _wireguardService = wireguardService,
        _analyticsStore = analyticsStore,
        _subscriptionStore = subscriptionStore {
    _vpnConnection = _emptyConnection;
    _connectionStatus = ConnectionStatus.disconnected;
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
  final AnalyticsStore _analyticsStore;
  final SubscriptionStore _subscriptionStore;
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
  String? _connectingLocationCode;

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
    try {
      await _wireguardService.connect(cfg: config);
    } catch (e) {
      throw WireguardConnectException(e.toString());
    }
  }

  @action
  Future<void> disconnectWireguard() async {
    await _wireguardService.disconnect();
  }

  @action
  Future<void> connect({
    Location? location,
  }) async {
    if (_subscriptionStore.subscription?.active == false ||
        _subscriptionStore.subscriptionFuture?.status == FutureStatus.rejected ||
        _subscriptionStore.subscriptionFuture?.status == FutureStatus.pending) {
      showSnackbar(LocaleKeys.activateSubscription.tr());
      return;
    }
    if (_vpnConnection.location == location?.countryCode) {
      return;
    }
    location ??= _locationsStore.recentLocations.isNotEmpty
        ? _locationsStore.recentLocations.first
        : _locationsStore.allLocations.isNotEmpty
            ? _locationsStore.allLocations.first
            : null;
    _connectingLocationCode = location?.countryCode;
    try {
      if (_vpnConnection != _emptyConnection) {
        await disconnect();
      }
      final stopwatch = Stopwatch()..start();
      _connectionStatus = ConnectionStatus.connecting;
      _vpnConfig = await _apiService.fetchVpnConfig(
        input: VpnConfigInput(
          publicKey: _publicKey,
          country: location?.countryCode,
        ),
        privateKey: _privateKey,
      );

      debugPrint(_vpnConfig?.config);
      await connectWireguard();
      final ipAddress = await _apiService.getIPAdress();
      _vpnConnection = VpnConnection(
        connectionIP: ipAddress ?? '--',
        location: location?.countryCode ?? '--',
      );
      _connectionStatus = ConnectionStatus.connected;
      stopwatch.stop();
      _analyticsStore.setVpnConnect(
        vpnServer: _vpnConnection.location,
        vpnProcessingTime: stopwatch.elapsed,
      );
      //startTracking();
      if (location != null) {
        _apiService.setRecentLocation(location: location.countryCode);
        _locationsStore.fetchRecentLocations();
      }
    } catch (e) {
      showSnackbar(
        LocaleKeys.failedToConnect.tr(
          namedArgs: {
            'countryName': location?.countryName ?? '',
          },
        ),
      );
      _connectionStatus = ConnectionStatus.disconnected;
      if (e is WireguardConnectException) {
        _analyticsStore.setVpnError(
          errorCode: e.code,
          errorMessage: e.message,
          errorSource: 'wireguard',
        );
      } else if (e is ApiException) {
        _analyticsStore.setVpnError(
          errorCode: e.code,
          errorMessage: e.message,
          errorSource: 'backend',
        );
      } else {
        _analyticsStore.setVpnError(
          errorCode: 500,
          errorMessage: e.toString(),
          errorSource: 'internal',
        );
      }
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
    _analyticsStore.setVpnDisconnect(vpnServer: _vpnConnection.location);
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
