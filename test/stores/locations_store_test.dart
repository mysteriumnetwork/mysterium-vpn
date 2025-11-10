import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/mocks.dart';
import 'package:mysterium_vpn/models/models.dart' hide Response;
import 'package:mysterium_vpn/services/services.dart' hide Response;
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

import 'locations_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Connection>(),
  MockSpec<FilterService>(),
  MockSpec<LocationsService>(),
  MockSpec<Talker>(unsupportedMembers: {#configure}),
  MockSpec<RemoteConfigStore>(),
  MockSpec<LocationsQueryStore>(),
  MockSpec<LocaleStore>(),
  MockSpec<LocalDBService>(),
])
void main() {
  late LocationsStore store;
  late MockConnection mockApiConnection;
  late MockFilterService mockFilterService;
  late MockLocalDBService mockLocalDB;
  late MockLocationsService mockLocationsService;
  late MockTalker mockLogger;
  late MockRemoteConfigStore mockRemoteConfigStore;
  late MockLocationsQueryStore mockQuery;
  late MockLocaleStore mockLocaleStore;

  late List<VPNLocation> mockResidential;
  late List<VPNLocation> mockDatacenter;

  ConnectionLocationCity cityFromLocation(VPNLocation location) => ConnectionLocationCity(
        city: location.id,
        total: location.nodeCount ?? 0,
        translations: location.translations,
        latitude: location.coordinates?.latitude,
        longitude: location.coordinates?.longitude,
      );

  ConnectionLocation countryFromLocation(VPNLocation location) => ConnectionLocation(
        country: location.id,
        total: location.nodeCount ?? 0,
        translations: location.translations,
        cities: location.children?.map(cityFromLocation).toList() ?? [],
      );

  Response<List<ConnectionLocation>> mockResponse(List<VPNLocation> locations) =>
      Response<List<ConnectionLocation>>(
        statusCode: 200,
        data: locations.map(countryFromLocation).toList(),
        requestOptions: RequestOptions(),
      );

  setUp(() async {
    mockApiConnection = MockConnection();
    mockFilterService = MockFilterService();
    mockLocalDB = MockLocalDBService();
    mockLocationsService = MockLocationsService();
    mockLogger = MockTalker();
    mockRemoteConfigStore = MockRemoteConfigStore();
    mockQuery = MockLocationsQueryStore();
    mockLocaleStore = MockLocaleStore();

    mockResidential = const [
      Mocks.locationResidentialUS,
      Mocks.locationResidentialDE,
      Mocks.locationResidentialGB,
      Mocks.locationResidentialNL,
    ];
    mockDatacenter = const [
      Mocks.locationDatacenterUS,
      Mocks.locationDatacenterDE,
      Mocks.locationDatacenterGB,
      Mocks.locationDatacenterNL,
    ];

    when(mockLocaleStore.currentLocale).thenReturn(const Locale('en'));
    when(mockQuery.ipType).thenReturn(IPType.residential);
    when(mockQuery.search).thenReturn('');
    when(mockQuery.searchTrimmed).thenReturn('');
    when(mockRemoteConfigStore.locationsRefreshInterval).thenReturn(const Duration(hours: 1));
    when(mockApiConnection.connectionLocations(ipType: IPType.datacenter.key)).thenAnswer(
      (_) async => mockResponse(mockDatacenter),
    );
    when(mockApiConnection.connectionLocations(ipType: IPType.residential.key)).thenAnswer(
      (_) async => mockResponse(mockResidential),
    );

    when(mockLocalDB.getLocations(IPType.datacenter)).thenAnswer((_) async => VPNLocations());
    when(mockLocalDB.getLocations(IPType.residential)).thenAnswer((_) async => VPNLocations());
    when(mockLocalDB.watchLocations(IPType.datacenter)).thenAnswer(
      (_) => const Stream.empty(),
    );
    when(mockLocalDB.watchLocations(IPType.residential)).thenAnswer(
      (_) => const Stream.empty(),
    );
    when(
      mockFilterService.filterLocations(
        any,
        locale: anyNamed('locale'),
        keyword: anyNamed('keyword'),
        shouldSortList: anyNamed('shouldSortList'),
      ),
    ).thenAnswer((invocation) => invocation.positionalArguments[0] as List<VPNLocation>);

    store = LocationsStore(
      mockApiConnection,
      mockFilterService,
      mockLocalDB,
      mockLocationsService,
      mockLogger,
      mockRemoteConfigStore,
      mockQuery,
      mockLocaleStore,
    );
  });

  group('computed properties', () {
    setUp(() async {
      await store.dcLocationsFuture;
      await store.residentialLocationsFuture;
    });

    test('dcLocationFuture.value and residentialLocationsFuture.value', () async {
      expect(store.dcLocationsFuture.value, VPNLocations(locations: mockDatacenter));
      expect(store.residentialLocationsFuture.value, VPNLocations(locations: mockResidential));
    });
    test('locations(residential)', () {
      when(mockQuery.ipType).thenReturn(IPType.residential);
      expect(store.locations, mockResidential);
    });
    test('locations(datacenter)', () {
      when(mockQuery.ipType).thenReturn(IPType.datacenter);
      expect(store.locations, mockDatacenter);
    });
    test('countryCodes', () {
      final countries = {...mockDatacenter, ...mockResidential}.map((it) => it.countryCode).toSet();
      expect(store.countryCodes, countries);
    });
    test('isEmpty', () {
      expect(store.isEmpty, isFalse);
    });
    test('findById', () async {
      const residential = Mocks.locationResidentialGB;
      expect(await store.findById(residential.id, ipType: IPType.residential), residential);

      const datacenter = Mocks.locationDatacenterDE;
      expect(await store.findById(datacenter.id), datacenter);
    });
    test('findById returns null if not found', () async {
      expect(await store.findById('unknown_city', ipType: IPType.residential), isNull);
      expect(await store.findById('unknown_city'), isNull);
    });
    test('findParent', () async {
      expect(
        store.findParent(
          const VPNLocation(
            id: 'new_york',
            ipType: IPType.residential,
            translations: <String, String>{},
            countryCode: 'US',
          ),
        ),
        Mocks.locationResidentialUS,
      );
    });
    test('findParent returns null if not found', () async {
      expect(
        store.findParent(
          const VPNLocation(
            id: 'unknown_city',
            ipType: IPType.residential,
            translations: <String, String>{},
            countryCode: 'N/A',
          ),
        ),
        isNull,
      );
    });
  });
}
