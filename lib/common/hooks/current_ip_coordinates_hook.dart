import 'package:collection/collection.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:latlong2/latlong.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

LatLng? useCurrentIPCoordinates() {
  final locationsStore = useProvider(locationsStorePOD);
  final realIPStore = useProvider(realIPInfoStorePOD);
  final vpnStore = useProvider(vpnStorePOD);

  final location = useComputedValue(() => vpnStore.location);
  final originIP = useComputedValue(() => realIPStore.info);
  final locations = useComputedValue(() => locationsStore.locationsStream.value?.allLocations);

  return useMemoized(
    () {
      final match = locations?.firstWhereOrNull(
        (it) => it.coordinates != null && it.code == location?.code || it.code == originIP?.country,
      );
      return match?.coordinates;
    },
    [location, originIP, locations],
  );
}
