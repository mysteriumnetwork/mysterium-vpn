import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';

import 'recent_locations_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LocalDBService>(),
  MockSpec<FilterService>(),
  MockSpec<LocationsQueryStore>(),
  MockSpec<RemoteConfigStore>(),
  MockSpec<LocationsStore>(),
  MockSpec<LocaleStore>(),
])
void main() {
  late MockLocalDBService mockDB;
  late MockFilterService mockFilter;
  late MockLocationsQueryStore mockQuery;
  late MockRemoteConfigStore mockConfig;
  late MockLocationsStore mockLocations;
  late MockLocaleStore mockLocale;
  late RecentLocationsStore store;
  late List<VPNLocation> dcLocations;
  late List<VPNLocation> residentialLocations;

  setUp(() {
    mockDB = MockLocalDBService();
    mockFilter = MockFilterService();
    mockQuery = MockLocationsQueryStore();
    mockConfig = MockRemoteConfigStore();
    mockLocations = MockLocationsStore();
    mockLocale = MockLocaleStore();

    when(mockConfig.recentLocationsLimit).thenReturn(5);
    when(mockLocale.currentLocale).thenReturn(const Locale('en'));

    store = RecentLocationsStore(
      mockDB,
      mockFilter,
      mockQuery,
      mockConfig,
      mockLocations,
      mockLocale,
    );

    dcLocations = [
      Mocks.locationDatacenterDE,
      Mocks.locationDatacenterGB,
      Mocks.locationDatacenterUS,
      Mocks.locationDatacenterNL,
    ];

    residentialLocations = [
      Mocks.locationResidentialGB,
      Mocks.locationResidentialUS,
      Mocks.locationResidentialDE,
      Mocks.locationResidentialNL,
    ];

    when(
      mockLocations.dcLocationsFuture,
    ).thenAnswer((_) => ObservableFuture.value(VPNLocations(locations: dcLocations)));
    when(
      mockLocations.residentialLocationsFuture,
    ).thenAnswer((_) => ObservableFuture.value(VPNLocations(locations: residentialLocations)));
    when(mockQuery.searchTrimmed).thenReturn('');
  });

  group('value', () {
    test('returns empty list when future value is null', () {
      when(mockDB.getRecentLocations()).thenAnswer((_) async => []);
      when(
        mockLocations.dcLocationsFuture,
      ).thenAnswer((_) => ObservableFuture<VPNLocations>.error(''));
      when(
        mockLocations.residentialLocationsFuture,
      ).thenAnswer((_) => ObservableFuture<VPNLocations>.error(''));

      expect(store.value, isEmpty);
    });

    test('returns empty list when future value is empty', () {
      when(mockDB.getRecentLocations()).thenAnswer((_) async => []);
      when(
        mockLocations.dcLocationsFuture,
      ).thenAnswer((_) => ObservableFuture<VPNLocations>.error(''));
      when(
        mockLocations.residentialLocationsFuture,
      ).thenAnswer((_) => ObservableFuture<VPNLocations>.error(''));

      expect(store.value, isEmpty);
    });

    test('returns filtered and limited locations', () async {
      final recentLocations = [...residentialLocations, ...dcLocations];

      when(mockDB.getRecentLocations()).thenAnswer((_) async => recentLocations);
      when(
        mockFilter.filterLocations(any, keyword: anyNamed('keyword'), locale: anyNamed('locale')),
      ).thenReturn(recentLocations);

      await store.future;

      expect(store.future.value, recentLocations);
      expect(store.value.length, mockConfig.recentLocationsLimit);
    });

    test('returns intersected locations', () async {
      final recentLocations = [
        Mocks.locationDatacenterDE,
        Mocks.locationDatacenterGB,
        Mocks.locationDatacenterUS,
      ];

      final availableDCLocations = [Mocks.locationDatacenterGB, Mocks.locationDatacenterUS];

      final availableResidentialLocations = [
        Mocks.locationResidentialGB,
        Mocks.locationResidentialUS,
      ];

      when(mockDB.getRecentLocations()).thenAnswer((_) async => recentLocations);
      when(
        mockLocations.dcLocationsFuture,
      ).thenAnswer((_) => ObservableFuture.value(VPNLocations(locations: availableDCLocations)));
      when(mockLocations.residentialLocationsFuture).thenAnswer(
        (_) => ObservableFuture.value(VPNLocations(locations: availableResidentialLocations)),
      );

      when(
        mockFilter.filterLocations(any, keyword: anyNamed('keyword'), locale: anyNamed('locale')),
      ).thenReturn(recentLocations);

      await store.future;

      expect(store.value, contains(Mocks.locationDatacenterGB));
      expect(store.value, contains(Mocks.locationDatacenterUS));
    });
  });

  group('add', () {
    test('does not add location when closest is set', () async {
      when(mockDB.getRecentLocations()).thenAnswer((_) async => []);

      await store.add(VPNLocation.closest);

      verifyNever(mockDB.setRecentLocations(any));
    });

    test('does not add location when already in recents', () async {
      final recentLocations = [Mocks.locationDatacenterDE, Mocks.locationDatacenterGB];

      when(mockDB.getRecentLocations()).thenAnswer((_) async => recentLocations);

      await store.add(Mocks.locationDatacenterDE);

      final captured = verify(mockDB.setRecentLocations(captureAny)).captured.single;
      expect(captured, equals(recentLocations));
    });

    test('adds location to the start of the list', () async {
      final recentLocations = [Mocks.locationDatacenterDE, Mocks.locationDatacenterGB];

      when(mockDB.getRecentLocations()).thenAnswer((_) async => recentLocations);

      await store.add(Mocks.locationDatacenterUS);

      final captured = verify(mockDB.setRecentLocations(captureAny)).captured.single;
      expect(captured, equals([Mocks.locationDatacenterUS, ...recentLocations]));
    });
  });
}
