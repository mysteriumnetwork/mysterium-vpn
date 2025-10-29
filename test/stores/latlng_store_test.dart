import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/data/local/assets_service.dart';
import 'package:mysterium_vpn/services/data/network/nominatim_service.dart';
import 'package:mysterium_vpn/stores/stores.dart';

import 'latlng_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AssetsService>(),
  MockSpec<NominatimService>(),
  MockSpec<RemoteConfigStore>(),
])
void main() {
  late MockAssetsService mockAssetsService;
  late LatLngStore latLngStore;
  const newYork = VPNLocation(
    id: 'new_york',
    ipType: IPType.residential,
    translations: {},
    countryCode: 'US',
    coordinates: LatLng(40.7128, -74.0060),
  );

  const unitedStates = VPNLocation(
    id: 'US',
    ipType: IPType.residential,
    translations: {},
    countryCode: 'US',
    coordinates: LatLng(37.7749, -122.4194),
    children: [newYork],
  );

  final mockData = {unitedStates.id: unitedStates.coordinates!};

  setUp(() {
    mockAssetsService = MockAssetsService();
    latLngStore = LatLngStore(mockAssetsService);
  });

  group('LatLngStore.coordinatesForCountry', () {
    setUp(() async {
      when(mockAssetsService.getCoordinates()).thenAnswer((_) async => mockData);
      await latLngStore.countryCoordinatesFuture;
    });

    test('returns coordinates for a valid country code', () async {
      final result = latLngStore.coordinatesForCountry('us');
      expect(result, mockData['US']);
    });

    test('returns null for an invalid country code', () async {
      final result = latLngStore.coordinatesForCountry('invalid');
      expect(result, isNull);
    });

    test('handles empty coordinates map gracefully', () async {
      // for this test, we need a new latlngstore because the previous one has already fetched data
      final latLngStore = LatLngStore(mockAssetsService);
      when(mockAssetsService.getCoordinates()).thenAnswer((_) async => {});

      await latLngStore.countryCoordinatesFuture;

      final result = latLngStore.coordinatesForCountry('US');
      expect(result, isNull);
    });
  });

  group('LatLngStore.coordinatesForCity', () {
    test('returns null when location is a country', () {
      final result = latLngStore.coordinatesForCity(unitedStates);
      expect(result, isNull);
    });

    test('returns coordinates when location is a city', () {
      final result = latLngStore.coordinatesForCity(newYork);
      expect(result, newYork.coordinates);
    });
  });
}
