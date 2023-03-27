// Flutter imports:
// Package imports:
import 'dart:async';
import 'dart:math';

import 'package:easy_localization/easy_localization.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/mock.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/models/vpn_connection.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';

// Project imports:

part 'vpn_store.g.dart';

// ignore: library_private_types_in_public_api
class VpnStore = _VpnStore with _$VpnStore;

abstract class _VpnStore with Store {
  _VpnStore({required ApiService apiService, required LocationsStore locationsStore})
      : _apiService = apiService,
        _locationsStore = locationsStore {
    _vpnConnection = _emptyConnection;
    _connectionStatus = ConnectionStatus.disconnected;
    _duration = Duration.zero;
    _uploadSpeed = 0;
    _downloadSpeed = 0;
    _protocol = protocols.first;
    _killSwitch = true;
    _connectingLocationCode = '';
  }

  static const VpnConnection _emptyConnection = VpnConnection(
    connectionIP: '--',
    location: '--',
  );

  final ApiService _apiService;
  final LocationsStore _locationsStore;
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
    await Future.delayed(const Duration(seconds: 3));
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
