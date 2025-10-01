import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/vpn_connection_status.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/models/user_intent.dart';
import 'package:mysterium_vpn/models/vpn_connection.dart';
import 'package:vpn_api/vpn_api.dart';

abstract class IVpnStore {
  ObservableFuture<void>? get resolveConnectionLocationFuture;
  ObservableFuture<VPNLocation?>? get fetchLocationFuture;
  ObservableFuture<void>? get disconnectAllDevicesFuture;
  ObservableFuture<void>? get resetAppFuture;

  bool get isConnected;
  bool get isLoading;
  bool get isFetchingLocation;
  bool get isFetchingConfig;
  VpnConnectionStatus get vpnStatus;
  VPNLocation? get location;
  Set<UserIntent> get userIntents;
  VPNLocation? get connectingLocation;
  VPNLocation? get potentialLocation;
  bool connectionLimitReached = false;
  VpnConnection? get vpnConnection;
  RateConnectionRequestModeEnum? connectionRated;
  String? get publicKey;
  bool get limitExceeded;
  UserIntent? get userIntent;

  Future<void> toggleConnection({
    VPNLocation? location,
    UserIntent? intent,
    bool isRetrying,
  });

  Future<void> disconnectFromVpn({bool isReconnecting});
  Future<void> disconnectAllDevices();
  Future<void> resetApp();
  Future<VpnConnectionStatus> checkTunnelStatus();
  Future<void> setupTunnel();
  Future<void> startConnectionWithRefreshIP();
  Future<void> disposeStore();
}
