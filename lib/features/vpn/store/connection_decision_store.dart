import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'connection_decision_store.g.dart';

// ignore: library_private_types_in_public_api
class ConnectionDecisionStore = _ConnectionDecisionStore with _$ConnectionDecisionStore;

abstract class _ConnectionDecisionStore with Store {
  _ConnectionDecisionStore({
    required LocationsStore locationsStore,
    required RecentLocationsStore recentLocationsStore,
    required UserIntentsStore userIntentsStore,
  }) : _locationsStore = locationsStore,
       _recentLocationsStore = recentLocationsStore,
       _userIntentsStore = userIntentsStore;

  final LocationsStore _locationsStore;
  final RecentLocationsStore _recentLocationsStore;
  final UserIntentsStore _userIntentsStore;

  // ==================== Computed Properties ====================

  @computed
  VPNLocation? get potentialLocation {
    final recent = _recentLocationsStore.future.value?.firstOrNull;
    if (recent != null) {
      return recent;
    }

    final allLocations = [
      ...?_locationsStore.dcLocationsFuture.value?.allLocations,
      ...?_locationsStore.residentialLocationsFuture.value?.allLocations,
    ];

    return allLocations.isNotEmpty ? VPNLocation.closest : null;
  }

  // ==================== Decision Logic ====================

  ConnectionAction determineToggleAction({
    required VpnConnectionStatus currentStatus,
    required VPNLocation? currentLocation,
    required bool isRefreshIP,
    VPNLocation? requestedLocation,
    UserIntent? requestedIntent,
  }) {
    // If not connected, always connect
    if (currentStatus != VpnConnectionStatus.connected) {
      return ConnectionAction.connect;
    }

    if (isRefreshIP) {
      return ConnectionAction.refreshIP;
    }

    // If connected and no location/intent specified, disconnect
    if (requestedLocation == null && requestedIntent == null) {
      return ConnectionAction.disconnect;
    }

    final currentIntent = _userIntentsStore.userIntent;

    // If same location requested, disconnect
    if (requestedLocation != null && requestedLocation == currentLocation) {
      return ConnectionAction.disconnect;
    }

    // If same intent requested, disconnect
    if (requestedIntent != null && requestedIntent == currentIntent) {
      return ConnectionAction.disconnect;
    }

    // Different location/intent requested, reconnect
    return ConnectionAction.reconnect;
  }

  VPNLocation? determineConnectingLocation({
    VPNLocation? requestedLocation,
    VPNLocation? currentLocation,
    bool isRefreshIP = false,
    UserIntent? intent,
  }) {
    if (requestedLocation != null) {
      return requestedLocation;
    }
    if (isRefreshIP) {
      return currentLocation;
    }
    if (intent != null) {
      return null;
    }
    return potentialLocation;
  }

  bool shouldResolveClosestLocation(VPNLocation? location) => location?.ipType == IPType.closest;
}
