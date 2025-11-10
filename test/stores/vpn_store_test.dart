import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/exceptions/unavailable_location_exception.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

@GenerateNiceMocks([
  MockSpec<VpnRepository>(),
  MockSpec<ApiService>(),
  MockSpec<ExternalApiService>(),
  MockSpec<MQTTService>(),
  MockSpec<LocationsStore>(),
  MockSpec<RecentLocationsStore>(),
  MockSpec<LocationsQueryStore>(),
  MockSpec<UnavailableLocationsStore>(),
  MockSpec<UserIntentsStore>(),
  MockSpec<ConnectionsLimitStore>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<RemoteConfigStore>(),
  MockSpec<AuthSessionStore>(),
  MockSpec<RealIPInfoStore>(),
  MockSpec<DNSStore>(),
  MockSpec<RefreshIPStore>(),
  MockSpec<ConnectionDecisionStore>(),
  MockSpec<LocationsService>(),
  MockSpec<Talker>(),
  MockSpec<SubscriptionStore>(),
])
import 'vpn_store_test.mocks.dart';

void main() {
  late VpnStore vpnStore;
  late MockVpnRepository mockVpnRepo;
  late MockApiService mockApi;
  late MockExternalApiService mockExternalApi;
  late MockMQTTService mockMqtt;
  late MockLocationsStore mockLocationsStore;
  late MockRecentLocationsStore mockRecentLocations;
  late MockLocationsQueryStore mockLocationsQuery;
  late MockUnavailableLocationsStore mockUnavailableLocations;
  late MockUserIntentsStore mockUserIntents;
  late MockConnectionsLimitStore mockConnectionsLimit;
  late MockAnalyticsStore mockAnalytics;
  late MockRemoteConfigStore mockRemoteConfig;
  late MockAuthSessionStore mockAuthSession;
  late MockRealIPInfoStore mockRealIPInfo;
  late MockDNSStore mockDns;
  late MockRefreshIPStore mockRefreshIP;
  late MockConnectionDecisionStore mockConnectionDecision;
  late MockLocationsService mockLocationsService;
  late MockTalker mockLogger;
  late MockSubscriptionStore mockSubscriptionStore;

  setUp(() {
    mockVpnRepo = MockVpnRepository();
    mockApi = MockApiService();
    mockExternalApi = MockExternalApiService();
    mockMqtt = MockMQTTService();
    mockLocationsStore = MockLocationsStore();
    mockRecentLocations = MockRecentLocationsStore();
    mockLocationsQuery = MockLocationsQueryStore();
    mockUnavailableLocations = MockUnavailableLocationsStore();
    mockUserIntents = MockUserIntentsStore();
    mockConnectionsLimit = MockConnectionsLimitStore();
    mockAnalytics = MockAnalyticsStore();
    mockRemoteConfig = MockRemoteConfigStore();
    mockAuthSession = MockAuthSessionStore();
    mockRealIPInfo = MockRealIPInfoStore();
    mockDns = MockDNSStore();
    mockRefreshIP = MockRefreshIPStore();
    mockConnectionDecision = MockConnectionDecisionStore();
    mockLocationsService = MockLocationsService();
    mockLogger = MockTalker();
    mockSubscriptionStore = MockSubscriptionStore();

    vpnStore = VpnStore(
      apiService: mockApi,
      externalApiService: mockExternalApi,
      mqtt: mockMqtt,
      locationsStore: mockLocationsStore,
      locationsService: mockLocationsService,
      subscriptionStore: mockSubscriptionStore,
      logger: mockLogger,
      analyticsStore: mockAnalytics,
      remoteConfigStore: mockRemoteConfig,
      authSessionStore: mockAuthSession,
      realIPInfo: mockRealIPInfo,
      dnsStore: mockDns,
      refreshIPStore: mockRefreshIP,
      recentLocationsStore: mockRecentLocations,
      locationsQueryStore: mockLocationsQuery,
      unavailableLocationsStore: mockUnavailableLocations,
      userIntentsStore: mockUserIntents,
      connectionsLimitStore: mockConnectionsLimit,
      vpnRepository: mockVpnRepo,
      connectionDecisionStore: mockConnectionDecision,
    );
  });

  group('VpnStore Tests', () {
    test('Initial state', () {
      expect(vpnStore.isConnected, false);
      expect(vpnStore.isLoading, false);
      expect(vpnStore.vpnStatus, VpnConnectionStatus.disconnected);
      expect(vpnStore.location, null);
    });

    test('setupTunnel calls repository and listens to status', () async {
      when(mockVpnRepo.setupTunnel()).thenAnswer((_) async => Future.value());
      when(mockVpnRepo.currentStatus()).thenAnswer((_) async => VpnConnectionStatus.disconnected);
      when(mockRecentLocations.future).thenAnswer(
        (_) => ObservableFuture.value(<VPNLocation>[]),
      );
      await vpnStore.setupTunnel();

      verify(mockVpnRepo.setupTunnel()).called(1);
      expect(vpnStore.vpnStatus, VpnConnectionStatus.disconnected);
    });

    test('disconnectTunnel clears state', () async {
      when(mockVpnRepo.disconnect()).thenAnswer((_) async => true);
      when(mockVpnRepo.notifyApiVpnDisconnected()).thenAnswer((_) async => Future.value());

      await vpnStore.disconnectTunnel();

      expect(vpnStore.location, null);
      verify(mockVpnRepo.notifyApiVpnDisconnected()).called(1);
    });

    group('fetchVpnConfiguration', () {
      const location = VPNLocation(
        id: 'US',
        ipType: IPType.datacenter,
        translations: {},
        countryCode: 'US',
      );
      const intent = UserIntent.bestSpeed;

      test('returns VpnConfig successfully', () async {
        when(mockRealIPInfo.infoFuture).thenAnswer(
          (_) => ObservableFuture.value(const IPInfo(country: 'US', city: 'NY', ip: '1.1.1.1')),
        );

        when(mockLocationsService.closestRegion(any)).thenAnswer((_) async => null); // no cluster

        const vpnConfig = VpnConfig(id: 'config1', config: 'cfg', exitIp: '2.2.2.2', hash: 'hash');

        when(
          mockVpnRepo.fetchVpnConfig(
            countryOriginate: anyNamed('countryOriginate'),
            country: anyNamed('country'),
            city: anyNamed('city'),
            ipType: anyNamed('ipType'),
            resetConnection: anyNamed('resetConnection'),
            userIntent: anyNamed('userIntent'),
            cluster: anyNamed('cluster'),
          ),
        ).thenAnswer((_) async => vpnConfig);

        final result = await vpnStore.fetchVpnConfiguration(
          location: location,
          intent: intent,
          refreshIP: false,
        );

        expect(result, vpnConfig);
      });

      test(
          'fetchVpnConfiguration throws UnavailableLocationException and disables location on ApiException 2332',
          () async {
        const location = VPNLocation(
          id: 'NY',
          ipType: IPType.datacenter,
          translations: {},
          countryCode: 'US',
        );

        const intent = UserIntent.bestSpeed;

        when(mockRealIPInfo.infoFuture).thenAnswer(
          (_) => ObservableFuture.value(
            const IPInfo(country: 'US', city: 'NY', ip: '1.1.1.1'),
          ),
        );

        when(
          mockVpnRepo.fetchVpnConfig(
            countryOriginate: anyNamed('countryOriginate'),
            country: anyNamed('country'),
            city: anyNamed('city'),
            ipType: anyNamed('ipType'),
            resetConnection: anyNamed('resetConnection'),
            userIntent: anyNamed('userIntent'),
            cluster: anyNamed('cluster'),
          ),
        ).thenAnswer(
          (_) async => throw ApiException(
            RequestOptions(),
            'Location unavailable',
            code: 2332,
            identifier: 'LocationUnavailable',
            endpoint: '/config',
            severity: ExceptionSeverity.low,
          ),
        );

        await expectLater(
          () async => vpnStore.fetchVpnConfiguration(
            location: location,
            intent: intent,
            refreshIP: false,
          ),
          throwsA(isA<UnavailableLocationException>()),
        );

        verify(
          mockUnavailableLocations.toggleAvailability(
            argThat(
              predicate<VPNLocation>(
                (loc) =>
                    loc.id == location.id &&
                    loc.ipType == location.ipType &&
                    loc.countryCode == location.countryCode,
              ),
            ),
            availability: false,
          ),
        ).called(1);
      });

      test('rethrows other ApiException', () async {
        when(mockRealIPInfo.infoFuture).thenAnswer(
          (_) => ObservableFuture.value(const IPInfo(country: 'US', city: 'NY', ip: '1.1.1.1')),
        );

        when(
          mockVpnRepo.fetchVpnConfig(
            countryOriginate: anyNamed('countryOriginate'),
            country: anyNamed('country'),
            city: anyNamed('city'),
            ipType: anyNamed('ipType'),
            resetConnection: anyNamed('resetConnection'),
            userIntent: anyNamed('userIntent'),
            cluster: anyNamed('cluster'),
          ),
        ).thenThrow(
          ApiException(
            RequestOptions(),
            'Some other error',
            code: 1234,
            identifier: 'Some error',
            endpoint: '/config',
            severity: ExceptionSeverity.medium,
          ),
        );

        expect(
          () =>
              vpnStore.fetchVpnConfiguration(location: location, intent: intent, refreshIP: false),
          throwsA(isA<ApiException>()),
        );
      });
    });

    test('manageConnection disconnects when action is disconnect', () async {
      const location = VPNLocation(
        id: 'US',
        ipType: IPType.datacenter,
        translations: {},
        countryCode: 'US',
      );

      when(
        mockConnectionDecision.determineToggleAction(
          currentStatus: anyNamed('currentStatus'),
          currentLocation: anyNamed('currentLocation'),
          requestedLocation: anyNamed('requestedLocation'),
          requestedIntent: anyNamed('requestedIntent'),
          isRefreshIP: anyNamed('isRefreshIP'),
        ),
      ).thenReturn(ConnectionAction.disconnect);

      when(mockVpnRepo.disconnect()).thenAnswer((_) async => true);
      when(mockVpnRepo.notifyApiVpnDisconnected()).thenAnswer((_) async => Future.value());

      await vpnStore.manageConnection(location: location, intent: UserIntent.bestSpeed);

      verify(mockVpnRepo.disconnect()).called(1);
      expect(vpnStore.location, null);
    });
  });
}
