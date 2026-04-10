import 'package:latlong2/latlong.dart';
import 'package:mysterium_vpn/core/enums/vpn_connection_status.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/features/locations/store/latlng_store.dart';
import 'package:mysterium_vpn/features/vpn/store/real_ip_info_store.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_store.dart';

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
