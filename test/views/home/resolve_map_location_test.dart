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

  void setDcLocations(Set<VPNLocation> locations) {
    _dcFuture = ObservableFuture.value(VPNLocations(locations: locations.toList()));
  }

  @override
  ObservableFuture<VPNLocations> get dcLocationsFuture => _dcFuture;
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
  }) => VPNLocation(
    id: id,
    ipType: ipType,
    translations: const {'en': 'United States'},
    countryCode: countryCode,
    isAvailable: isAvailable,
    nodeCount: nodeCount ?? 10,
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
      );

      expect(result, same(residential));
      expect(result.ipType, IPType.residential);
    });
  });
}
