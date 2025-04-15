import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/services/data/local/assets_service.dart';
import 'package:mysterium_vpn/stores/latlng_store.dart';

import 'latlng_store_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AssetsService>()])
void main() {
  late MockAssetsService mockAssetsService;
  late LatLngStore latLngStore;

  setUp(() {
    mockAssetsService = MockAssetsService();
    latLngStore = LatLngStore(mockAssetsService);
  });

  group('LatLngStore', () {
    test('returns coordinates for a valid country code', () async {
      const mockData = {'US': LatLng(37.7749, -122.4194)};
      when(mockAssetsService.getCoordinates()).thenAnswer((_) async => mockData);

      await latLngStore.coordinatesFuture;

      final result = latLngStore.coordinatesFor('us');
      expect(result, mockData['US']);
    });

    test('returns null for an invalid country code', () async {
      const mockData = {'US': LatLng(37.7749, -122.4194)};
      when(mockAssetsService.getCoordinates()).thenAnswer((_) async => mockData);

      await latLngStore.coordinatesFuture;

      final result = latLngStore.coordinatesFor('invalid');
      expect(result, isNull);
    });

    test('handles empty coordinates map gracefully', () async {
      when(mockAssetsService.getCoordinates()).thenAnswer((_) async => {});

      await latLngStore.coordinatesFuture;

      final result = latLngStore.coordinatesFor('US');
      expect(result, isNull);
    });
  });
}
