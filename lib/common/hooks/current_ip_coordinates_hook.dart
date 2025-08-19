import 'package:latlong2/latlong.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:wireguard_dart/connection_status.dart';

LatLng? useCurrentIPCoordinates() {
  final realIPStore = useProvider(realIPInfoStorePOD);
  final vpnStore = useProvider(vpnStorePOD);
  final latLngStore = useProvider(latLngStorePOD);

  return useComputedValue(
    () {
      if (vpnStore.connectionStatus == ConnectionStatus.connecting ||
          vpnStore.connectionStatus == ConnectionStatus.connected) {
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
    },
    [latLngStore, vpnStore, realIPStore],
  );
}
