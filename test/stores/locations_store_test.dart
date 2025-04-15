import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/data/filter_service.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/services/data/local/shared_preferences_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/locale_store.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';

import 'locations_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ApiService>(),
  MockSpec<FilterService>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<RemoteConfigStore>(),
  MockSpec<SharedPreferenceService>(),
  MockSpec<LocaleStore>(),
  MockSpec<LocalDBService>(),
])
void main() {
  late LocationsStore locationsStore;
  late MockApiService mockApiService;
  late MockFilterService mockFilterService;
  late MockAnalyticsStore mockAnalyticsStore;
  late MockRemoteConfigStore mockRemoteConfigStore;

  late MockSharedPreferenceService mockPrefs;
  late MockLocalDBService mockLocalDB;
  late MockLocaleStore mockLocaleStore;
  late List<VPNLocation> mockResidential;
  late List<VPNLocation> mockDatacenter;

  setUp(() async {
    mockApiService = MockApiService();
    mockFilterService = MockFilterService();
    mockAnalyticsStore = MockAnalyticsStore();
    mockRemoteConfigStore = MockRemoteConfigStore();
    mockPrefs = MockSharedPreferenceService();
    mockLocalDB = MockLocalDBService();
    mockLocaleStore = MockLocaleStore();

    mockResidential = const [
      VPNLocation(code: 'US'),
      VPNLocation(code: 'DE'),
    ];
    mockDatacenter = const [
      VPNLocation(code: 'US', ipType: IPType.datacenter),
      VPNLocation(code: 'DE', ipType: IPType.datacenter),
    ];

    when(mockLocalDB.getLocations(IPType.residential)).thenAnswer((_) => null);
    when(mockLocalDB.getLocations(IPType.datacenter)).thenAnswer((_) => null);
    when(mockLocalDB.getLocations(null)).thenAnswer((_) => null);

    when(mockRemoteConfigStore.configFuture).thenAnswer((_) => ObservableFuture.value({}));
    when(mockRemoteConfigStore.locationsRefreshInterval).thenReturn(Duration.zero);
    when(mockLocalDB.getRecentLocations()).thenAnswer((_) async => const <VPNLocation>[]);

    // Add stubs for fetchVPNLocations
    when(mockApiService.fetchVPNLocations()).thenAnswer(
      (_) async => VPNLocations(locations: mockResidential),
    );
    when(mockApiService.fetchVPNLocations(IPType.residential)).thenAnswer(
      (_) async => VPNLocations(locations: mockResidential),
    );
    when(mockApiService.fetchVPNLocations(IPType.datacenter)).thenAnswer(
      (_) async => VPNLocations(locations: mockDatacenter),
    );

    await mockRemoteConfigStore.configFuture;

    locationsStore = LocationsStore(
      mockApiService,
      mockFilterService,
      mockAnalyticsStore,
      mockRemoteConfigStore,
      mockPrefs,
      mockLocalDB,
      mockLocaleStore,
    );
  });

  group('LocationsStore', () {
    test('returns filtered recent locations', () async {
      when(mockLocalDB.getRecentLocations()).thenAnswer((_) async => mockResidential);
      when(
        mockFilterService.filterLocations(
          mockResidential,
          keyword: 'us',
          shouldSortList: false,
        ),
      ).thenReturn([const VPNLocation(code: 'US')]);

      locationsStore.setLocationKeyword('US', Duration.zero);
      await Future.delayed(Duration.zero); // ensure the debounce time has passed
      await locationsStore.recentLocationsFuture;

      expect(locationsStore.recentLocations, [const VPNLocation(code: 'US')]);
    });

    test('returns filtered locations', () async {
      await locationsStore.locationsStream.first;

      when(mockFilterService.filterLocations(mockResidential, keyword: 'de'))
          .thenReturn([const VPNLocation(code: 'DE')]);

      locationsStore.setLocationKeyword('de', Duration.zero);

      await Future.delayed(Duration.zero); // ensure the debounce time has passed

      expect(locationsStore.locations, [const VPNLocation(code: 'DE')]);
    });

    test('returns random location from recent locations', () async {
      when(mockLocalDB.getRecentLocations()).thenAnswer((_) async => mockResidential);

      await locationsStore.locationsStream.first;
      final recentLocations = await locationsStore.recentLocationsFuture;

      final randomLocation = locationsStore.randomLocation();
      expect(recentLocations.contains(randomLocation), isTrue);
    });

    test('returns null when no locations available for random selection', () async {
      final locationsStore = LocationsStore(
        mockApiService,
        mockFilterService,
        mockAnalyticsStore,
        mockRemoteConfigStore,
        mockPrefs,
        mockLocalDB,
        mockLocaleStore,
      );
      when(mockApiService.fetchVPNLocations(IPType.residential)).thenAnswer(
        (_) async => VPNLocations(),
      );
      when(mockLocalDB.getRecentLocations()).thenAnswer((_) async => const <VPNLocation>[]);

      await locationsStore.dcLocationsStream.first;
      await locationsStore.residentialLocationsStream.first;
      await locationsStore.recentLocationsFuture;

      final randomLocation = locationsStore.randomLocation(IPType.residential);

      expect(randomLocation, isNull);
    });

    test('refresh updates locations', () async {
      when(mockFilterService.filterLocations(mockResidential, keyword: ''))
          .thenReturn(mockResidential);

      await locationsStore.refresh();
      await locationsStore.locationsStream.first;

      expect(locationsStore.locations, mockResidential);
    });

    test('setLocationKeyword updates search keyword', () async {
      locationsStore.setLocationKeyword('test', Duration.zero);
      await Future.delayed(Duration.zero); // ensure the debounce time has passed

      expect(locationsStore.searchKeyword, 'test');
    });

    test('setIPType updates IP type', () async {
      await locationsStore.setIPType(IPType.datacenter);
      expect(locationsStore.ipType, IPType.datacenter);
    });
  });
}
