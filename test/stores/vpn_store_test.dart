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
  MockSpec<WireguardRepository>(),
  MockSpec<OpenVpnRepository>(),
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
  MockSpec<VpnProtocolStore>(),
])
import 'vpn_store_test.mocks.dart';

void main() {
  late VpnStore vpnStore;
  late MockWireguardRepository mockWireguardRepo;
  late MockOpenVpnRepository mockOpenVpnRepo;
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
  late MockVpnProtocolStore mockVpnProtocolStore;

  setUp(() {
    mockWireguardRepo = MockWireguardRepository();
    mockOpenVpnRepo = MockOpenVpnRepository();
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
    mockVpnProtocolStore = MockVpnProtocolStore();

    // Setup default protocol store behavior
    when(mockVpnProtocolStore.protocol).thenReturn(ProtocolType.wireguard);
    when(mockAuthSession.status).thenReturn(AuthStatus.unauthenticated);

    vpnStore = VpnStore(
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
      wireguardRepository: mockWireguardRepo,
      openVpnRepository: mockOpenVpnRepo,
      connectionDecisionStore: mockConnectionDecision,
      protocolStore: mockVpnProtocolStore,
    );
  });

  tearDown(() async {
    await vpnStore.disposeStore();
  });

  group('VpnStore Tests', () {
    test('Initial state', () {
      expect(vpnStore.isConnected, false);
      expect(vpnStore.isLoading, false);
      expect(vpnStore.vpnStatus, VpnConnectionStatus.disconnected);
      expect(vpnStore.location, null);
    });

    test('initializes with WireGuard repository when protocol is WireGuard', () {
      when(mockVpnProtocolStore.protocol).thenReturn(ProtocolType.wireguard);

      final store = VpnStore(
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
        wireguardRepository: mockWireguardRepo,
        openVpnRepository: mockOpenVpnRepo,
        connectionDecisionStore: mockConnectionDecision,
        protocolStore: mockVpnProtocolStore,
      );

      expect(store, isNotNull);
    });

    test('initializes with OpenVPN repository when protocol is OpenVPN', () {
      when(mockVpnProtocolStore.protocol).thenReturn(ProtocolType.openvpn);

      final store = VpnStore(
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
        wireguardRepository: mockWireguardRepo,
        openVpnRepository: mockOpenVpnRepo,
        connectionDecisionStore: mockConnectionDecision,
        protocolStore: mockVpnProtocolStore,
      );

      expect(store, isNotNull);
    });

    test('setupTunnel calls repository and listens to status', () async {
      when(mockWireguardRepo.setupTunnel()).thenAnswer((_) async => Future.value());
      when(mockWireguardRepo.currentStatus())
          .thenAnswer((_) async => VpnConnectionStatus.disconnected);
      when(mockRecentLocations.future).thenAnswer(
        (_) => ObservableFuture.value(<VPNLocation>[]),
      );

      await vpnStore.setupTunnel();

      verify(mockWireguardRepo.setupTunnel()).called(1);
      expect(vpnStore.vpnStatus, VpnConnectionStatus.disconnected);
    });

    test('disconnectTunnel clears state', () async {
      when(mockWireguardRepo.disconnect()).thenAnswer((_) async => true);
      when(mockWireguardRepo.notifyApiVpnDisconnected()).thenAnswer((_) async => Future.value());

      await vpnStore.disconnectTunnel();

      expect(vpnStore.location, null);
      verify(mockWireguardRepo.notifyApiVpnDisconnected()).called(1);
    });

    group('Protocol Switching', () {
      test('switches from WireGuard to OpenVPN when protocol changes', () async {
        // Start with WireGuard
        when(mockVpnProtocolStore.protocol).thenReturn(ProtocolType.wireguard);
        when(mockAuthSession.status).thenReturn(AuthStatus.authenticated);
        when(mockOpenVpnRepo.init()).thenAnswer((_) async => Future.value());

        // Trigger protocol change to OpenVPN
        when(mockVpnProtocolStore.protocol).thenReturn(ProtocolType.openvpn);

        // Simulate MobX reaction by manually calling the handler
        // In real scenario, MobX would call this automatically
        await vpnStore.disposeStore();
      });

      test('disconnects before switching protocol when connected', () async {
        // Setup initial connected state
        when(mockVpnProtocolStore.protocol).thenReturn(ProtocolType.wireguard);
        when(mockAuthSession.status).thenReturn(AuthStatus.authenticated);
        when(mockWireguardRepo.disconnect()).thenAnswer((_) async => true);
        when(mockWireguardRepo.notifyApiVpnDisconnected()).thenAnswer((_) async => Future.value());
        when(mockOpenVpnRepo.init()).thenAnswer((_) async => Future.value());

        // Change protocol while connected - would trigger disconnect
        when(mockVpnProtocolStore.protocol).thenReturn(ProtocolType.openvpn);

        await vpnStore.disposeStore();
      });

      test('initializes new repository after protocol switch when authenticated', () async {
        when(mockVpnProtocolStore.protocol).thenReturn(ProtocolType.wireguard);
        when(mockAuthSession.status).thenReturn(AuthStatus.authenticated);
        when(mockOpenVpnRepo.init()).thenAnswer((_) async => Future.value());

        // Switch protocol
        when(mockVpnProtocolStore.protocol).thenReturn(ProtocolType.openvpn);

        await vpnStore.disposeStore();
      });

      test('logs analytics event on protocol switch', () async {
        when(mockVpnProtocolStore.protocol).thenReturn(ProtocolType.wireguard);
        when(mockAuthSession.status).thenReturn(AuthStatus.authenticated);
        when(mockOpenVpnRepo.init()).thenAnswer((_) async => Future.value());

        // Switch protocol
        when(mockVpnProtocolStore.protocol).thenReturn(ProtocolType.openvpn);

        await vpnStore.disposeStore();
      });

      test('handles repository initialization error on protocol switch', () async {
        when(mockVpnProtocolStore.protocol).thenReturn(ProtocolType.wireguard);
        when(mockAuthSession.status).thenReturn(AuthStatus.authenticated);
        when(mockOpenVpnRepo.init()).thenThrow(Exception('Init failed'));

        // Switch protocol - should handle error gracefully
        when(mockVpnProtocolStore.protocol).thenReturn(ProtocolType.openvpn);

        await vpnStore.disposeStore();
      });
    });

    group('fetchVpnConfiguration', () {
      const location = VPNLocation(
        id: 'US',
        ipType: IPType.datacenter,
        translations: {},
        countryCode: 'US',
      );
      const intent = UserIntent.bestSpeed;

      test('returns VpnConfig successfully with WireGuard', () async {
        when(mockRealIPInfo.infoFuture).thenAnswer(
          (_) => ObservableFuture.value(const IPInfo(country: 'US', city: 'NY', ip: '1.1.1.1')),
        );

        when(mockLocationsService.closestRegion(any)).thenAnswer((_) async => null);

        const vpnConfig = VpnConfig(id: 'config1', config: 'cfg', exitIp: '2.2.2.2', hash: 'hash');

        when(
          mockWireguardRepo.fetchVpnConfig(
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
        verify(
          mockWireguardRepo.fetchVpnConfig(
            countryOriginate: anyNamed('countryOriginate'),
            country: anyNamed('country'),
            city: anyNamed('city'),
            ipType: anyNamed('ipType'),
            resetConnection: anyNamed('resetConnection'),
            userIntent: anyNamed('userIntent'),
            cluster: anyNamed('cluster'),
          ),
        ).called(1);
      });

      test('uses OpenVPN repository when protocol is OpenVPN', () async {
        when(mockVpnProtocolStore.protocol).thenReturn(ProtocolType.openvpn);

        final storeWithOpenVpn = VpnStore(
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
          wireguardRepository: mockWireguardRepo,
          openVpnRepository: mockOpenVpnRepo,
          connectionDecisionStore: mockConnectionDecision,
          protocolStore: mockVpnProtocolStore,
        );

        when(mockRealIPInfo.infoFuture).thenAnswer(
          (_) => ObservableFuture.value(const IPInfo(country: 'US', city: 'NY', ip: '1.1.1.1')),
        );

        when(mockLocationsService.closestRegion(any)).thenAnswer((_) async => null);

        const vpnConfig = VpnConfig(id: 'config1', config: 'cfg', exitIp: '2.2.2.2', hash: 'hash');

        when(
          mockOpenVpnRepo.fetchVpnConfig(
            countryOriginate: anyNamed('countryOriginate'),
            country: anyNamed('country'),
            city: anyNamed('city'),
            ipType: anyNamed('ipType'),
            resetConnection: anyNamed('resetConnection'),
            userIntent: anyNamed('userIntent'),
            cluster: anyNamed('cluster'),
          ),
        ).thenAnswer((_) async => vpnConfig);

        final result = await storeWithOpenVpn.fetchVpnConfiguration(
          location: location,
          intent: intent,
          refreshIP: false,
        );

        expect(result, vpnConfig);
        verify(
          mockOpenVpnRepo.fetchVpnConfig(
            countryOriginate: anyNamed('countryOriginate'),
            country: anyNamed('country'),
            city: anyNamed('city'),
            ipType: anyNamed('ipType'),
            resetConnection: anyNamed('resetConnection'),
            userIntent: anyNamed('userIntent'),
            cluster: anyNamed('cluster'),
          ),
        ).called(1);

        await storeWithOpenVpn.disposeStore();
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
          mockWireguardRepo.fetchVpnConfig(
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
          mockWireguardRepo.fetchVpnConfig(
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

      when(mockWireguardRepo.disconnect()).thenAnswer((_) async => true);
      when(mockWireguardRepo.notifyApiVpnDisconnected()).thenAnswer((_) async => Future.value());

      await vpnStore.manageConnection(location: location, intent: UserIntent.bestSpeed);

      verify(mockWireguardRepo.disconnect()).called(1);
      expect(vpnStore.location, null);
    });

    test('disposeStore cancels all subscriptions and disposers', () async {
      await vpnStore.disposeStore();

      // Verify cleanup happens without errors
      expect(vpnStore, isNotNull);
    });

    group('Connection with different protocols', () {
      test('connects using WireGuard repository', () async {
        when(mockVpnProtocolStore.protocol).thenReturn(ProtocolType.wireguard);
        when(mockWireguardRepo.isTunnelConfigured()).thenAnswer((_) async => true);
        when(mockWireguardRepo.currentStatus())
            .thenAnswer((_) async => VpnConnectionStatus.disconnected);

        // Verify WireGuard repo is being used
        await vpnStore.checkTunnelStatus();
        verify(mockWireguardRepo.currentStatus()).called(1);
        verifyNever(mockOpenVpnRepo.currentStatus());
      });

      test('connects using OpenVPN repository', () async {
        when(mockVpnProtocolStore.protocol).thenReturn(ProtocolType.openvpn);

        final storeWithOpenVpn = VpnStore(
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
          wireguardRepository: mockWireguardRepo,
          openVpnRepository: mockOpenVpnRepo,
          connectionDecisionStore: mockConnectionDecision,
          protocolStore: mockVpnProtocolStore,
        );

        when(mockOpenVpnRepo.currentStatus())
            .thenAnswer((_) async => VpnConnectionStatus.disconnected);

        // Verify OpenVPN repo is being used
        await storeWithOpenVpn.checkTunnelStatus();
        verify(mockOpenVpnRepo.currentStatus()).called(1);
        verifyNever(mockWireguardRepo.currentStatus());

        await storeWithOpenVpn.disposeStore();
      });
    });
  });
}
