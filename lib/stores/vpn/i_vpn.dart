import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/vpn_connection_status.dart';
import 'package:mysterium_vpn/common/exceptions/authentication_required.dart';
import 'package:mysterium_vpn/common/exceptions/subscription_required_exception.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/models/user_intent.dart';
import 'package:mysterium_vpn/models/vpn_connection.dart';
import 'package:mysterium_vpn/services/auth/auth_session_store.dart';
import 'package:mysterium_vpn/services/auth/auth_status.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
import 'package:vpn_api/vpn_api.dart';

abstract class IVpnStore extends VpnGuard {
  IVpnStore({
    required super.subscriptionStore,
    required super.authSessionStore,
  });

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
  bool get connectionLimitReached;
  set connectionLimitReached(bool value);
  VpnConnection? get vpnConnection;
  RateConnectionRequestModeEnum? get connectionRated;
  set connectionRated(RateConnectionRequestModeEnum? value);
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

class VpnGuard {
  VpnGuard({
    required SubscriptionStore subscriptionStore,
    required AuthSessionStore authSessionStore,
  })  : _subscriptionStore = subscriptionStore,
        _authSessionStore = authSessionStore;
  final SubscriptionStore _subscriptionStore;
  final AuthSessionStore _authSessionStore;

  Future<void> checkVpnGuards() async {
    await _authSessionStore.accessTokenFuture;
    if (_authSessionStore.status != AuthStatus.authenticated) {
      throw AuthenticationRequiredException();
    }
    if (_subscriptionStore.subscriptionFuture.status == FutureStatus.pending) {
      return;
    }
    try {
      final subscription = await _subscriptionStore.subscriptionFuture;
      if (!subscription.active) {
        throw const SubscriptionRequiredException();
      }
    } catch (e) {
      if (e is! SubscriptionRequiredException) {
        _subscriptionStore.refreshSubscription();
      }
      rethrow;
    }
  }
}
