import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/mocks.dart';
import 'package:mysterium_vpn/models/flavor_config.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/services/data/filter_service.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/services/data/local/shared_preferences_service.dart';
import 'package:mysterium_vpn/services/location/ping.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/locale_store.dart';
import 'package:mysterium_vpn/stores/locations_store.dart';
import 'package:mysterium_vpn/stores/remote_config/remote_config_store.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

import 'locations_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Connection>(),
  MockSpec<FilterService>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<RemoteConfigStore>(),
  MockSpec<SharedPreferenceService>(),
  MockSpec<LocaleStore>(),
  MockSpec<LocalDBService>(),
  MockSpec<Ping>(),
  MockSpec<FlavorConfig>(),
])
void main() {
  late LocationsStore locationsStore;
  late MockConnection mockApiConnection;
  late MockFilterService mockFilterService;
  late MockAnalyticsStore mockAnalyticsStore;
  late MockRemoteConfigStore mockRemoteConfigStore;
  late MockSharedPreferenceService mockPrefs;
  late MockLocalDBService mockLocalDB;
  late MockLocaleStore mockLocaleStore;
  late MockPing mockPing;
  late MockFlavorConfig mockFlavorConfig;

  late List<VPNLocation> mockResidential;
  late List<VPNLocation> mockDatacenter;

  void mockConnectionConfig(String expectedIPType, ConnectionConfigResponse data) {
    when(mockApiConnection.connectionConfig(ipType: expectedIPType)).thenAnswer(
      (_) async => Response(requestOptions: RequestOptions(), data: data),
    );

    when(mockApiConnection.connectionLocations(ipType: expectedIPType)).thenAnswer(
      (_) async {
        final countries = {...data.countries, ...data.topCountries};
        return Response(
          requestOptions: RequestOptions(),
          data: [
            for (final country in countries)
              ConnectionLocation(
                country: country,
                total: 5,
                cities: [],
                translations: {'en': country},
              ),
          ],
        );
      },
    );
  }

  setUp(() async {
    mockApiConnection = MockConnection();
    mockFilterService = MockFilterService();
    mockAnalyticsStore = MockAnalyticsStore();
    mockRemoteConfigStore = MockRemoteConfigStore();
    mockPrefs = MockSharedPreferenceService();
    mockLocalDB = MockLocalDBService();
    mockLocaleStore = MockLocaleStore();
    mockPing = MockPing();
    mockFlavorConfig = MockFlavorConfig();

    when(mockFlavorConfig.isDev).thenReturn(true);

    mockResidential = const [
      Mocks.locationResidentialUS,
      Mocks.locationResidentialDE,
    ];
    mockDatacenter = const [
      Mocks.locationDatacenterUS,
      Mocks.locationDatacenterDE,
    ];

    when(mockLocaleStore.currentLocale).thenAnswer((_) => const Locale('en'));

    when(mockLocalDB.getLocations(IPType.residential)).thenAnswer(
      (_) => VPNLocations(locations: mockResidential),
    );
    when(mockLocalDB.getLocations(IPType.datacenter)).thenAnswer(
      (_) => VPNLocations(locations: mockDatacenter),
    );
    when(mockLocalDB.getLocations(null)).thenAnswer((_) => null);

    when(mockRemoteConfigStore.configFuture).thenAnswer((_) => ObservableFuture.value({}));
    when(mockRemoteConfigStore.locationsRefreshInterval).thenReturn(Duration.zero);
    when(mockLocalDB.getRecentLocations()).thenAnswer((_) async => const <VPNLocation>[]);

    // Add stubs for fetchVPNLocations
    mockConnectionConfig('', ConnectionConfigResponse(countries: ['US'], topCountries: ['DE']));
    mockConnectionConfig(
      'residential',
      ConnectionConfigResponse(countries: ['US'], topCountries: ['DE']),
    );
    mockConnectionConfig(
      'hosting',
      ConnectionConfigResponse(countries: ['US'], topCountries: ['DE']),
    );

    when(mockPing.latencyMedian()).thenAnswer((_) async => Duration.zero);

    await mockRemoteConfigStore.configFuture;

    locationsStore = LocationsStore(
      mockApiConnection,
      mockFilterService,
      mockAnalyticsStore,
      mockRemoteConfigStore,
      mockPrefs,
      mockLocalDB,
      Talker(),
      mockLocaleStore,
      mockPing,
      mockFlavorConfig,
    );
  });

  group('LocationsStore', () {
    test('returns filtered recent locations', () async {
      when(mockLocalDB.getRecentLocations()).thenAnswer((_) async => mockResidential);
      when(mockLocalDB.getLocations(IPType.residential)).thenReturn(
        VPNLocations(locations: mockResidential),
      );
      when(
        mockFilterService.filterRecentLocations(
          mockResidential,
          availableLocations: {...mockResidential},
          keyword: 'un',
          locale: 'en',
        ),
      ).thenReturn([Mocks.locationResidentialUS]);

      await locationsStore.residentialLocationsFuture;
      await locationsStore.recentLocationsFuture;

      locationsStore.setLocationKeyword('un', Duration.zero);
      await Future.delayed(Duration.zero); // ensure the debounce time has passed

      expect(locationsStore.recentLocations, [Mocks.locationResidentialUS]);
    });

    test('returns filtered locations', () async {
      await locationsStore.locationsFuture;

      when(
        mockFilterService.filterLocations(
          mockResidential,
          keyword: 'de',
          locale: 'en',
        ),
      ).thenReturn([Mocks.locationResidentialDE]);

      locationsStore.setLocationKeyword('de', Duration.zero);

      await Future.delayed(Duration.zero); // ensure the debounce time has passed

      expect(locationsStore.locations, [Mocks.locationResidentialDE]);
    });

    test('returns random location from recent locations', () async {
      when(mockLocalDB.getRecentLocations()).thenAnswer((_) async => mockResidential);
      when(
        mockFilterService.filterRecentLocations(
          mockResidential,
          keyword: '',
          availableLocations: {...mockResidential},
          locale: 'en',
        ),
      ).thenReturn(mockResidential);

      final recentLocations = await locationsStore.recentLocationsFuture;

      final randomLocation = locationsStore.randomLocation;
      expect(recentLocations.contains(randomLocation), isTrue);
    });

    test('returns closest location when no locations available for random selection', () async {
      final newStore = LocationsStore(
        mockApiConnection,
        mockFilterService,
        mockAnalyticsStore,
        mockRemoteConfigStore,
        mockPrefs,
        mockLocalDB,
        Talker(),
        mockLocaleStore,
        mockPing,
        mockFlavorConfig,
      );
      mockConnectionConfig(
        'residential',
        ConnectionConfigResponse(countries: ['DE'], topCountries: ['US']),
      );
      when(mockLocalDB.getRecentLocations()).thenAnswer((_) async => const <VPNLocation>[]);
      await newStore.recentLocationsFuture;
      await newStore.refresh(IPType.residential);
      final randomLocation = newStore.randomLocation;
      expect(
        randomLocation,
        const VPNLocation(
          ipType: IPType.closest,
          countryCode: '',
          id: '',
          translations: {'en': ''},
        ),
      );
    });

    test('returns null when no locations available for random selection', () async {
      final locationsStore = LocationsStore(
        mockApiConnection,
        mockFilterService,
        mockAnalyticsStore,
        mockRemoteConfigStore,
        mockPrefs,
        mockLocalDB,
        Talker(),
        mockLocaleStore,
        mockPing,
        mockFlavorConfig,
      );
      when(mockLocalDB.getLocations(IPType.residential)).thenAnswer((_) => VPNLocations());
      mockConnectionConfig(
        'residential',
        ConnectionConfigResponse(countries: [], topCountries: []),
      );
      when(mockLocalDB.getRecentLocations()).thenAnswer((_) async => const <VPNLocation>[]);
      await locationsStore.refresh(IPType.residential);
      final randomLocation = locationsStore.randomLocation;
      expect(randomLocation, isNull);
    });

    test('refresh updates locations', () async {
      when(
        mockFilterService.filterLocations(
          mockResidential,
          keyword: '',
          locale: 'en',
        ),
      ).thenReturn(mockResidential);

      await locationsStore.refresh();
      await locationsStore.locationsFuture;

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
