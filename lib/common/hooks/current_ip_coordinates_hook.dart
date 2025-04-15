import 'package:collection/collection.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:latlong2/latlong.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/data/local/shared_preferences_service.dart';

LatLng? useCurrentCoordinates() {
  final locationsStore = useProvider(locationsStorePOD);
  final vpnStore = useProvider(vpnStorePOD);

  final location = useComputedValue(() => vpnStore.location);
  final originIP = SharedPreferenceService.instance.getIPInfo();
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
