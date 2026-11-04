import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/home/home_map.dart';

// ---------------------------------------------------------------------------
// Minimal fake that satisfies the single property resolveMapLocation reads.
// ---------------------------------------------------------------------------

class _FakeLocationsStore extends Fake implements LocationsStore {
  ObservableFuture<VPNLocations> _dcFuture = ObservableFuture.value(VPNLocations());
  ObservableFuture<VPNLocations> _residentialFuture = ObservableFuture.value(VPNLocations());

  void setDcLocations(Set<VPNLocation> locations) {
    _dcFuture = ObservableFuture.value(VPNLocations(locations: locations.toList()));
  }

  void setResidentialLocations(Set<VPNLocation> locations) {
    _residentialFuture = ObservableFuture.value(VPNLocations(locations: locations.toList()));
  }

  @override
  ObservableFuture<VPNLocations> get dcLocationsFuture => _dcFuture;

  @override
  VPNLocation? findParent(VPNLocation location) {
    if (location.isCountry) {
      return null;
    }
    final locations = switch (location.ipType) {
      IPType.datacenter => _dcFuture.value?.allLocations,
      IPType.residential => _residentialFuture.value?.allLocations,
      _ => null,
    };
    return locations
        ?.where((it) => it.isCountry && it.countryCode == location.countryCode)
        .firstOrNull;
  }
}

void main() {
  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  VPNLocation makeLocation({
    String id = 'US',
    IPType ipType = IPType.residential,
    String countryCode = 'US',
    bool isAvailable = true,
    int? nodeCount,
    List<VPNLocation>? children,
  }) => VPNLocation(
    id: id,
    ipType: ipType,
    translations: const {'en': 'United States'},
    countryCode: countryCode,
    isAvailable: isAvailable,
    nodeCount: nodeCount ?? 10,
    children: children,
  );

  late _FakeLocationsStore fakeLocationsStore;

  setUp(() {
    fakeLocationsStore = _FakeLocationsStore();
  });

  // ---------------------------------------------------------------------------
  // Test cases
  // ---------------------------------------------------------------------------

  group('resolveMapLocation', () {
    test('returns residential when allowed and available', () {
      final residential = makeLocation();

      final result = resolveMapLocation(
        location: residential,
        locationsStore: fakeLocationsStore,
        residentialIPsAllowed: true,
        cityLevelAllowed: true,
      );

      expect(result, same(residential));
      expect(result.ipType, IPType.residential);
    });

    test('falls back to datacenter when residential not allowed', () {
      final residential = makeLocation();
      final datacenter = makeLocation(ipType: IPType.datacenter);
      fakeLocationsStore.setDcLocations({datacenter});

      final result = resolveMapLocation(
        location: residential,
        locationsStore: fakeLocationsStore,
        residentialIPsAllowed: false,
        cityLevelAllowed: true,
      );

      expect(result, same(datacenter));
      expect(result.ipType, IPType.datacenter);
    });

    test('falls back to datacenter when residential not available', () {
      final residential = makeLocation(isAvailable: false);
      final datacenter = makeLocation(ipType: IPType.datacenter);
      fakeLocationsStore.setDcLocations({datacenter});

      final result = resolveMapLocation(
        location: residential,
        locationsStore: fakeLocationsStore,
        residentialIPsAllowed: true,
        cityLevelAllowed: true,
      );

      expect(result, same(datacenter));
      expect(result.ipType, IPType.datacenter);
    });

    test('returns original residential when neither type is available (triggers paywall)', () {
      final residential = makeLocation(isAvailable: false);
      // No datacenter locations at all.

      final result = resolveMapLocation(
        location: residential,
        locationsStore: fakeLocationsStore,
        residentialIPsAllowed: true,
        cityLevelAllowed: true,
      );

      expect(result, same(residential));
      expect(result.ipType, IPType.residential);
    });

    test('returns original when datacenter exists but is unavailable', () {
      final residential = makeLocation();
      final datacenter = makeLocation(ipType: IPType.datacenter, isAvailable: false);
      fakeLocationsStore.setDcLocations({datacenter});

      final result = resolveMapLocation(
        location: residential,
        locationsStore: fakeLocationsStore,
        residentialIPsAllowed: false,
        cityLevelAllowed: true,
      );

      expect(result, same(residential));
      expect(result.ipType, IPType.residential);
    });

    test('returns datacenter location as-is without resolution', () {
      final datacenter = makeLocation(ipType: IPType.datacenter);

      final result = resolveMapLocation(
        location: datacenter,
        locationsStore: fakeLocationsStore,
        residentialIPsAllowed: false,
        cityLevelAllowed: true,
      );

      expect(result, same(datacenter));
      expect(result.ipType, IPType.datacenter);
    });

    test('matches by country code — ignores other countries', () {
      final residentialUS = makeLocation();
      final datacenterDE = makeLocation(id: 'DE', ipType: IPType.datacenter, countryCode: 'DE');
      fakeLocationsStore.setDcLocations({datacenterDE});

      final result = resolveMapLocation(
        location: residentialUS,
        locationsStore: fakeLocationsStore,
        residentialIPsAllowed: false,
        cityLevelAllowed: true,
      );

      // No DC match for US, so returns original residential.
      expect(result, same(residentialUS));
    });

    test('residential prioritised when both types are available and plan allows', () {
      final residential = makeLocation();
      final datacenter = makeLocation(ipType: IPType.datacenter);
      fakeLocationsStore.setDcLocations({datacenter});

      final result = resolveMapLocation(
        location: residential,
        locationsStore: fakeLocationsStore,
        residentialIPsAllowed: true,
        cityLevelAllowed: true,
      );

      expect(result, same(residential));
      expect(result.ipType, IPType.residential);
    });

    test('city-level location resolves to matching datacenter city', () {
      final residentialCity = makeLocation(id: 'new-york');
      final dcCity = makeLocation(id: 'new-york', ipType: IPType.datacenter);
      final dcCountry = makeLocation(ipType: IPType.datacenter, children: [dcCity]);
      fakeLocationsStore.setDcLocations({dcCountry});

      final result = resolveMapLocation(
        location: residentialCity,
        locationsStore: fakeLocationsStore,
        residentialIPsAllowed: false,
        cityLevelAllowed: true,
      );

      expect(result, same(dcCity));
      expect(result.ipType, IPType.datacenter);
    });

    test('city-level location falls back to datacenter country when no city match', () {
      final residentialCity = makeLocation(id: 'new-york');
      final dcCountry = makeLocation(ipType: IPType.datacenter);
      fakeLocationsStore.setDcLocations({dcCountry});

      final result = resolveMapLocation(
        location: residentialCity,
        locationsStore: fakeLocationsStore,
        residentialIPsAllowed: false,
        cityLevelAllowed: true,
      );

      expect(result, same(dcCountry));
      expect(result.ipType, IPType.datacenter);
    });

    test('city resolves to its country when the plan has no city targeting', () {
      final dcCity = makeLocation(id: 'new-york', ipType: IPType.datacenter);
      final dcCountry = makeLocation(ipType: IPType.datacenter);
      fakeLocationsStore.setDcLocations({dcCountry, dcCity});

      final result = resolveMapLocation(
        location: dcCity,
        locationsStore: fakeLocationsStore,
        residentialIPsAllowed: true,
        cityLevelAllowed: false,
      );

      expect(result, same(dcCountry));
    });

    test('country is unaffected when the plan has no city targeting', () {
      final dcCountry = makeLocation(ipType: IPType.datacenter);
      fakeLocationsStore.setDcLocations({dcCountry});

      final result = resolveMapLocation(
        location: dcCountry,
        locationsStore: fakeLocationsStore,
        residentialIPsAllowed: true,
        cityLevelAllowed: false,
      );

      expect(result, same(dcCountry));
    });
  });
}
