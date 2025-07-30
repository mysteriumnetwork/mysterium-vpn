import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/services/data/local/assets_service.dart';
import 'package:mysterium_vpn/services/data/network/nominatim_service.dart';
import 'package:mysterium_vpn/stores/latlng_store.dart';
import 'package:talker/talker.dart';

import 'latlng_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AssetsService>(),
  MockSpec<NominatimService>(),
  MockSpec<Talker>(unsupportedMembers: {#configure}),
])
void main() {
  late MockAssetsService mockAssetsService;
  late MockNominatimService mockNominatimService;
  late LatLngStore latLngStore;
  late MockTalker mockLoggerService;

  setUp(() {
    mockAssetsService = MockAssetsService();
    mockNominatimService = MockNominatimService();
    mockLoggerService = MockTalker();
    latLngStore = LatLngStore(mockAssetsService, mockNominatimService, mockLoggerService);

    when(mockNominatimService.findCoordinatesFor('vilnius')).thenAnswer(
      (_) async => const LatLng(54.6872, 25.2797),
    );
    when(mockNominatimService.findCoordinatesFor('wrongQuery')).thenAnswer(
      (_) async => null,
    );
  });

  group('LatLngStore', () {
    test('returns coordinates for a valid country code', () async {
      const mockData = {'US': LatLng(37.7749, -122.4194)};
      when(mockAssetsService.getCoordinates()).thenAnswer((_) async => mockData);

      await latLngStore.countryCoordinatesFuture;

      final result = latLngStore.coordinatesFor('us');
      expect(result, mockData['US']);
    });

    test('returns null for an invalid country code', () async {
      const mockData = {'US': LatLng(37.7749, -122.4194)};
      when(mockAssetsService.getCoordinates()).thenAnswer((_) async => mockData);

      await latLngStore.countryCoordinatesFuture;

      final result = latLngStore.coordinatesFor('invalid');
      expect(result, isNull);
    });

    test('handles empty coordinates map gracefully', () async {
      when(mockAssetsService.getCoordinates()).thenAnswer((_) async => {});

      await latLngStore.countryCoordinatesFuture;

      final result = latLngStore.coordinatesFor('US');
      expect(result, isNull);
    });

    test('refreshes coordinates for locations', () async {
      when(mockAssetsService.getCoordinates()).thenAnswer((_) async => {});
      await latLngStore.refreshIfNeeded(
        [
          'vilnius',
          'wrongQuery',
        ],
      );

      expect(latLngStore.coordinatesFor('vilnius'), const LatLng(54.6872, 25.2797));
      expect(latLngStore.coordinatesFor('wrongQuery'), isNull);
    });
  });
}
