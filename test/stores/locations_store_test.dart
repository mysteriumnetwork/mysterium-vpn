import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/services/api/api_service.dart';
import 'package:mysterium_vpn/services/data/filter_service.dart';
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
])
void main() {
  late LocationsStore locationsStore;
  late MockApiService mockApiService;
  late MockFilterService mockFilterService;
  late MockAnalyticsStore mockAnalyticsStore;
  late MockRemoteConfigStore mockRemoteConfigStore;

  late MockSharedPreferenceService mockPrefs;
  late MockLocaleStore mockLocaleStore;
  late List<VPNLocation> mockLocations;

  setUp(() {
    mockApiService = MockApiService();
    mockFilterService = MockFilterService();
    mockAnalyticsStore = MockAnalyticsStore();
    mockRemoteConfigStore = MockRemoteConfigStore();
    mockPrefs = MockSharedPreferenceService();
    mockLocaleStore = MockLocaleStore();

    locationsStore = LocationsStore(
      mockApiService,
      mockFilterService,
      mockAnalyticsStore,
      mockRemoteConfigStore,
      mockPrefs,
      mockLocaleStore,
    );
    mockLocations = const [VPNLocation(code: 'US'), VPNLocation(code: 'DE')];
  });

  group('LocationsStore', () {
    test('returns filtered recent locations', () async {
      when(mockApiService.getRecentLocations()).thenAnswer((_) async => mockLocations);
      when(mockFilterService.filterLocations(mockLocations, keyword: 'us'))
          .thenReturn([const VPNLocation(code: 'US')]);

      locationsStore.setLocationKeyword('US', Duration.zero);
      await Future.delayed(Duration.zero); // ensure the debounce time has passed
      await locationsStore.recentLocationsFuture;

      expect(locationsStore.recentLocations, [const VPNLocation(code: 'US')]);
    });

    test('returns filtered locations', () async {
      when(mockApiService.fetchVPNLocations(IPType.datacenter))
          .thenAnswer((_) async => VPNLocations(locations: mockLocations));
      when(mockFilterService.filterLocations(mockLocations, keyword: 'de'))
          .thenReturn([const VPNLocation(code: 'DE')]);

      locationsStore
        ..setIPType(IPType.datacenter)
        ..setLocationKeyword('de', Duration.zero);

      await Future.delayed(Duration.zero); // ensure the debounce time has passed
      await locationsStore.locationsFuture;

      expect(locationsStore.locations, [const VPNLocation(code: 'DE')]);
    });

    test('returns random location from recent locations', () async {
      when(mockApiService.fetchVPNLocations(IPType.residential))
          .thenAnswer((_) async => VPNLocations(locations: mockLocations));
      when(mockApiService.getRecentLocations()).thenAnswer((_) async => mockLocations);

      await locationsStore.locationsFuture;

      final randomLocation = locationsStore.randomLocation();
      expect(mockLocations.contains(randomLocation), isTrue);
    });

    test('returns null when no locations available for random selection', () async {
      when(mockApiService.fetchVPNLocations(IPType.residential))
          .thenAnswer((_) async => const VPNLocations());
      when(mockApiService.getRecentLocations()).thenAnswer((_) async => []);

      await locationsStore.locationsFuture;

      final randomLocation = locationsStore.randomLocation();
      expect(randomLocation, isNull);
    });

    test('refresh updates locations', () async {
      when(mockFilterService.filterLocations(mockLocations, keyword: '')).thenReturn(mockLocations);
      when(mockApiService.fetchVPNLocations(IPType.residential))
          .thenAnswer((_) async => VPNLocations(locations: mockLocations));

      await locationsStore.refresh();
      await locationsStore.locationsFuture;

      expect(locationsStore.locations, mockLocations);
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
