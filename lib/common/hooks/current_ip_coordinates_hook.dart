import 'package:latlong2/latlong.dart';
import 'package:mysterium_vpn/core/enums/vpn_connection_status.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';

LatLng? useCurrentIPCoordinates() {
  final realIPStore = useProvider<RealIPInfoStore>(realIPInfoStorePOD);
  final vpnStore = useProvider<VpnStore>(vpnStorePOD);
  final latLngStore = useProvider<LatLngStore>(latLngStorePOD);

  return useComputedValue(() {
    if (vpnStore.connectionStatus == VpnConnectionStatus.connecting ||
        vpnStore.connectionStatus == VpnConnectionStatus.connected) {
      final location = vpnStore.location ?? vpnStore.connectingLocation;
      if (location != null) {
        return latLngStore.coordinatesForCity(location) ??
            latLngStore.coordinatesForCountry(location.countryCode);
      }
    }

    final realCountry = realIPStore.info?.country;
    if (realCountry != null) {
      return latLngStore.coordinatesForCountry(realCountry);
    }

    return null;
  }, [latLngStore, vpnStore, realIPStore]);
}
