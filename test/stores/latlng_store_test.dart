import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/mocks.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/services/data/local/assets_service.dart';
import 'package:mysterium_vpn/services/data/network/nominatim_service.dart';
import 'package:mysterium_vpn/stores/latlng_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';

import 'latlng_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AssetsService>(),
  MockSpec<NominatimService>(),
  MockSpec<RemoteConfigStore>(),
])
void main() {
  late MockAssetsService mockAssetsService;
  late LatLngStore latLngStore;
  late MockRemoteConfigStore mockRemoteConfigStore;
  const mockData = {'US': LatLng(37.7749, -122.4194)};
  const latLngNewYork = LatLng(40.7128, -74.0060);
  const newYork = VPNLocation(
    id: 'new_york',
    ipType: IPType.residential,
    translations: {},
    countryCode: 'US',
    coordinates: LatLng(40.7128, -74.0060),
  );

  setUp(() {
    mockAssetsService = MockAssetsService();
    mockRemoteConfigStore = MockRemoteConfigStore();
    latLngStore = LatLngStore(mockAssetsService, mockRemoteConfigStore);
  });

  group('LatLngStore.coordinatesForCountry', () {
    setUp(() async {
      when(mockAssetsService.getCoordinates()).thenAnswer((_) async => mockData);
      await latLngStore.countryCoordinatesFuture;
    });

    test('returns coordinates for a valid country code', () async {
      await latLngStore.countryCoordinatesFuture;

      final result = latLngStore.coordinatesForCountry('us');
      expect(result, mockData['US']);
    });

    test('returns null for an invalid country code', () async {
      when(mockAssetsService.getCoordinates()).thenAnswer((_) async => mockData);

      await latLngStore.countryCoordinatesFuture;

      final result = latLngStore.coordinatesForCountry('invalid');
      expect(result, isNull);
    });

    test('handles empty coordinates map gracefully', () async {
      final latLngStore = LatLngStore(mockAssetsService, mockRemoteConfigStore);
      when(mockAssetsService.getCoordinates()).thenAnswer((_) async => {});

      await latLngStore.countryCoordinatesFuture;

      final result = latLngStore.coordinatesForCountry('US');
      expect(result, isNull);
    });
  });

  group('LatLngStore.coordinatesFor', () {
    setUp(() async {
      when(mockAssetsService.getCoordinates()).thenAnswer((_) async => mockData);
      await latLngStore.countryCoordinatesFuture;
    });

    test('returns country coordinates when location is country and cities not supported', () {
      const location = Mocks.locationDatacenterUS;
      when(mockRemoteConfigStore.showCitiesAndStates).thenReturn(false);
      when(mockRemoteConfigStore.countriesWithCitiesOnMap).thenReturn(mockData.keys.toSet());

      final result = latLngStore.coordinatesFor(location);
      expect(result, mockData['US']);
    });

    test('returns null when location is country and cities are supported', () {
      const location = Mocks.locationDatacenterUS;
      when(mockRemoteConfigStore.showCitiesAndStates).thenReturn(true);
      when(mockRemoteConfigStore.countriesWithCitiesOnMap).thenReturn(mockData.keys.toSet());

      final result = latLngStore.coordinatesFor(location);
      expect(result, isNull);
    });

    test('returns city coordinates when location is city and cities are supported', () {
      when(mockRemoteConfigStore.showCitiesAndStates).thenReturn(true);
      when(mockRemoteConfigStore.countriesWithCitiesOnMap).thenReturn(mockData.keys.toSet());

      final result = latLngStore.coordinatesFor(newYork);
      expect(result, latLngNewYork);
    });

    test('returns null when location is city and cities are not supported', () {
      when(mockRemoteConfigStore.showCitiesAndStates).thenReturn(false);
      when(mockRemoteConfigStore.countriesWithCitiesOnMap).thenReturn({});

      final result = latLngStore.coordinatesFor(newYork);
      expect(result, isNull);
    });
  });
}
