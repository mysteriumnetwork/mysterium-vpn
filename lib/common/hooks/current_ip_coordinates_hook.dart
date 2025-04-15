import 'package:latlong2/latlong.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

LatLng? useCurrentIPCoordinates() {
  final realIPStore = useProvider(realIPInfoStorePOD);
  final vpnStore = useProvider(vpnStorePOD);
  final latLngStore = useProvider(latLngStorePOD);

  return useComputedValue(
    () {
      final code = vpnStore.location?.code ?? realIPStore.info?.country;
      if (code == null) {
        return null;
      }
      return latLngStore.coordinatesFor(code);
    },
    [latLngStore, vpnStore, realIPStore],
  );
}
