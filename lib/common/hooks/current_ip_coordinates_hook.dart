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
      String? code;
      if (vpnStore.connectionStatus == ConnectionStatus.connecting ||
          vpnStore.connectionStatus == ConnectionStatus.connected) {
        code = vpnStore.location?.code ?? vpnStore.connectingLocation?.code;
      }
      code ??= realIPStore.info?.country;
      if (code == null) {
        return null;
      }
      return latLngStore.coordinatesFor(code);
    },
    [latLngStore, vpnStore, realIPStore],
  );
}
