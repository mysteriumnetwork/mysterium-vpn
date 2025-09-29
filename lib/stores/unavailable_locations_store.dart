import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/utils/disposeable.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';

part 'unavailable_locations_store.g.dart';

// ignore: library_private_types_in_public_api
class UnavailableLocationsStore = _UnavailableLocationsStore with _$UnavailableLocationsStore;

abstract class _UnavailableLocationsStore with Store, Disposeable {
  _UnavailableLocationsStore(
    LocationsStore locationsStore,
  ) {
    _locationsReactionDisposer = reaction(
      (_) => {
        ...?locationsStore.dcLocationsFuture.value?.allLocationsFlattened,
        ...?locationsStore.residentialLocationsFuture.value?.allLocationsFlattened,
      },
      equals: (s1, s2) => const SetEquality().equals(s1, s2),
      (available) {
        _unavailableLocations =
            _unavailableLocations.where((it) => !available.contains(it)).toSet();
      },
    );
  }

  late final ReactionDisposer _locationsReactionDisposer;

  @readonly
  late Set<VPNLocation> _unavailableLocations = const <VPNLocation>{};

  @action
  void toggleAvailability(VPNLocation location, {bool? availability}) {
    availability ??= !_unavailableLocations.contains(location);
    if (availability) {
      _unavailableLocations = _unavailableLocations.where((l) => l != location).toSet();
    } else {
      _unavailableLocations = {..._unavailableLocations, location};
    }
  }

  @action
  void clear() {
    _unavailableLocations = const <VPNLocation>{};
  }

  @override
  void dispose() {
    _locationsReactionDisposer();
  }
}
