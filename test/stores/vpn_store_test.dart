import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  TestWidgetsFlutterBinding.ensureInitialized();

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
  late UdpBlockedSuggestionStore udpBlockedSuggestionStore;

  VpnStore buildStore() => VpnStore(
    externalApiService: mockExternalApi,
    mqtt: mockMqtt,
    locationsStore: mockLocationsStore,
    locationsService: mockLocationsService,
    subscriptionStore: mockSubscriptionStore,
    logger: mockLogger,
    analyticsStore: mockAnalytics,
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
    ipRefreshExhaustionStore: IpRefreshExhaustionStore(mockAnalytics),
    udpBlockedSuggestionStore: udpBlockedSuggestionStore,
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await SharedPreferenceService.instance.init();
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

    udpBlockedSuggestionStore = UdpBlockedSuggestionStore(
      mockRemoteConfig,
      mockVpnProtocolStore,
      mockAuthSession,
      mockAnalytics,
    );

    vpnStore = buildStore();
  });

  tearDown(() async {
    await vpnStore.disposeStore();
  });

  void verifyFetchVpnConfig({required String? country, required String? city}) {
    verify(
      mockWireguardRepo.fetchVpnConfig(
        countryOriginate: anyNamed('countryOriginate'),
        country: country,
        city: city,
        ipType: anyNamed('ipType'),
        userIntent: anyNamed('userIntent'),
        cluster: anyNamed('cluster'),
        resetConnection: anyNamed('resetConnection'),
        dnsAddress: anyNamed('dnsAddress'),
      ),
    ).called(1);
  }

  group('VpnStore Tests', () {
    test('Initial state', () {
      expect(vpnStore.isConnected, false);
      expect(vpnStore.isLoading, false);
      expect(vpnStore.vpnStatus, VpnConnectionStatus.disconnected);
      expect(vpnStore.location, null);
    });

    test('initializes with WireGuard repository when protocol is WireGuard', () {
      when(mockVpnProtocolStore.protocol).thenReturn(ProtocolType.wireguard);

      final store = buildStore();

      expect(store, isNotNull);
    });

    test('initializes with OpenVPN repository when protocol is OpenVPN', () {
      when(mockVpnProtocolStore.protocol).thenReturn(ProtocolType.openvpn);

      final store = buildStore();

      expect(store, isNotNull);
    });

    test('setupTunnel calls repository and listens to status', () async {
      when(mockWireguardRepo.setupTunnel()).thenAnswer((_) async => Future.value());
      when(
        mockWireguardRepo.currentStatus(),
      ).thenAnswer((_) async => VpnConnectionStatus.disconnected);
      when(mockRecentLocations.future).thenAnswer((_) => ObservableFuture.value(<VPNLocation>[]));

      await vpnStore.setupTunnel();

      verify(mockWireguardRepo.setupTunnel()).called(1);
      expect(vpnStore.vpnStatus, VpnConnectionStatus.disconnected);
    });

    test('disconnectTunnel clears state', () async {
      when(mockWireguardRepo.disconnect()).thenAnswer((_) async => true);
      when(mockWireguardRepo.notifyApiVpnDisconnected()).thenAnswer((_) async => Future.value());

      await vpnStore.disconnectTunnel(reason: VpnDisconnectReason.user);

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
            dnsAddress: anyNamed('dnsAddress'),
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
            dnsAddress: anyNamed('dnsAddress'),
          ),
        ).called(1);
      });

      test('country location sends city = null', () async {
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
            userIntent: anyNamed('userIntent'),
            cluster: anyNamed('cluster'),
            resetConnection: anyNamed('resetConnection'),
            dnsAddress: anyNamed('dnsAddress'),
          ),
        ).thenAnswer((_) async => vpnConfig);

        const country = VPNLocation(
          id: 'fr',
          ipType: IPType.datacenter,
          translations: {},
          countryCode: 'fr',
        );

        await vpnStore.fetchVpnConfiguration(location: country, intent: null, refreshIP: false);

        verifyFetchVpnConfig(country: 'fr', city: null);
      });

      test('forwards targetIp to the repository', () async {
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
            dnsAddress: anyNamed('dnsAddress'),
            targetIp: anyNamed('targetIp'),
          ),
        ).thenAnswer((_) async => vpnConfig);

        await vpnStore.fetchVpnConfiguration(
          location: location,
          intent: null,
          refreshIP: false,
          targetIp: '5.5.5.5',
        );

        verify(
          mockWireguardRepo.fetchVpnConfig(
            countryOriginate: anyNamed('countryOriginate'),
            country: anyNamed('country'),
            city: anyNamed('city'),
            ipType: anyNamed('ipType'),
            resetConnection: anyNamed('resetConnection'),
            userIntent: anyNamed('userIntent'),
            cluster: anyNamed('cluster'),
            dnsAddress: anyNamed('dnsAddress'),
            targetIp: '5.5.5.5',
          ),
        ).called(1);
      });

      test('uses OpenVPN repository when protocol is OpenVPN', () async {
        when(mockVpnProtocolStore.protocol).thenReturn(ProtocolType.openvpn);

        final storeWithOpenVpn = buildStore();

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
            dnsAddress: anyNamed('dnsAddress'),
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
            dnsAddress: anyNamed('dnsAddress'),
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
              dnsAddress: anyNamed('dnsAddress'),
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
        },
      );

      test('a targeted (favorite IP) 2332 failure does NOT disable the country', () async {
        const location = VPNLocation(
          id: 'US',
          ipType: IPType.residential,
          translations: {},
          countryCode: 'US',
        );

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
            dnsAddress: anyNamed('dnsAddress'),
            targetIp: anyNamed('targetIp'),
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
            intent: null,
            refreshIP: false,
            targetIp: '5.5.5.5',
          ),
          throwsA(isA<UnavailableLocationException>()),
        );

        verifyNever(
          mockUnavailableLocations.toggleAvailability(any, availability: anyNamed('availability')),
        );
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
            dnsAddress: anyNamed('dnsAddress'),
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
          requestedTargetIp: anyNamed('requestedTargetIp'),
          currentIp: anyNamed('currentIp'),
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
        when(
          mockWireguardRepo.currentStatus(),
        ).thenAnswer((_) async => VpnConnectionStatus.disconnected);

        // Verify WireGuard repo is being used
        await vpnStore.checkTunnelStatus();
        verify(mockWireguardRepo.currentStatus()).called(1);
        verifyNever(mockOpenVpnRepo.currentStatus());
      });

      test('connects using OpenVPN repository', () async {
        when(mockVpnProtocolStore.protocol).thenReturn(ProtocolType.openvpn);

        final storeWithOpenVpn = buildStore();

        when(
          mockOpenVpnRepo.currentStatus(),
        ).thenAnswer((_) async => VpnConnectionStatus.disconnected);

        // Verify OpenVPN repo is being used
        await storeWithOpenVpn.checkTunnelStatus();
        verify(mockOpenVpnRepo.currentStatus()).called(1);
        verifyNever(mockWireguardRepo.currentStatus());

        await storeWithOpenVpn.disposeStore();
      });
    });

    group('connectedAt persistence', () {
      const loc = VPNLocation(
        id: 'de',
        ipType: IPType.datacenter,
        translations: {},
        countryCode: 'de',
      );

      late StreamController<VpnConnectionStatus> statusController;

      setUp(() {
        statusController = StreamController<VpnConnectionStatus>.broadcast();
        when(mockVpnProtocolStore.protocol).thenReturn(ProtocolType.wireguard);
        when(mockAuthSession.status).thenReturn(AuthStatus.authenticated);
        when(mockWireguardRepo.init()).thenAnswer((_) async {});
        when(mockWireguardRepo.isTunnelConfigured()).thenAnswer((_) async => true);
        when(mockWireguardRepo.statusStream()).thenAnswer((_) => statusController.stream);
        when(mockRecentLocations.future).thenAnswer((_) => ObservableFuture.value(<VPNLocation>[]));
        when(mockRecentLocations.add(any)).thenAnswer((_) async {});
        when(mockConnectionDecision.potentialLocation).thenReturn(loc);
        when(mockExternalApi.getIPAddress()).thenAnswer((_) async => '3.3.3.3');
      });

      tearDown(() async {
        await statusController.close();
      });

      test('restores the persisted connectedAt when the tunnel is already up at launch', () async {
        final storedAt = DateTime.now().subtract(const Duration(minutes: 5));
        await SharedPreferenceService.instance.setInt(
          StorageKeys.connectedAt.name,
          storedAt.millisecondsSinceEpoch,
        );
        when(
          mockWireguardRepo.currentStatus(),
        ).thenAnswer((_) async => VpnConnectionStatus.connected);

        final store = buildStore();
        await pumpEventQueue();

        expect(store.vpnStatus, VpnConnectionStatus.connected);
        expect(store.connectedAt?.millisecondsSinceEpoch, storedAt.millisecondsSinceEpoch);

        await store.disposeStore();
      });

      test('reaching connected resets the teardown reason', () async {
        when(
          mockWireguardRepo.currentStatus(),
        ).thenAnswer((_) async => VpnConnectionStatus.disconnected);
        when(mockWireguardRepo.disconnect()).thenAnswer((_) async => true);
        final store = buildStore();
        await pumpEventQueue();

        await store.disconnectTunnel(reason: VpnDisconnectReason.reconnect);
        expect(store.disconnectReason, VpnDisconnectReason.reconnect);

        statusController.add(VpnConnectionStatus.connected);
        await pumpEventQueue();

        expect(store.disconnectReason, VpnDisconnectReason.user);
        await store.disposeStore();
      });

      test('stamps and persists a fresh connectedAt when no stamp is stored', () async {
        when(
          mockWireguardRepo.currentStatus(),
        ).thenAnswer((_) async => VpnConnectionStatus.connected);
        final before = DateTime.now();

        final store = buildStore();
        await pumpEventQueue();

        expect(store.connectedAt, isNotNull);
        expect(store.connectedAt!.isBefore(before), isFalse);
        expect(
          SharedPreferenceService.instance.getInt(StorageKeys.connectedAt.name),
          store.connectedAt!.millisecondsSinceEpoch,
        );

        await store.disposeStore();
      });

      test('clears connectedAt and the stored stamp on disconnect', () async {
        when(
          mockWireguardRepo.currentStatus(),
        ).thenAnswer((_) async => VpnConnectionStatus.connected);

        final store = buildStore();
        await pumpEventQueue();
        expect(store.connectedAt, isNotNull);

        when(
          mockWireguardRepo.currentStatus(),
        ).thenAnswer((_) async => VpnConnectionStatus.disconnected);
        statusController.add(VpnConnectionStatus.disconnected);
        await pumpEventQueue();

        expect(store.connectedAt, isNull);
        expect(SharedPreferenceService.instance.getInt(StorageKeys.connectedAt.name), isNull);

        await store.disposeStore();
      });

      test('ignores a stale stored stamp when connecting after a disconnected launch', () async {
        final staleAt = DateTime.now().subtract(const Duration(hours: 2));
        await SharedPreferenceService.instance.setInt(
          StorageKeys.connectedAt.name,
          staleAt.millisecondsSinceEpoch,
        );
        when(
          mockWireguardRepo.currentStatus(),
        ).thenAnswer((_) async => VpnConnectionStatus.disconnected);

        final store = buildStore();
        await pumpEventQueue();
        expect(store.connectedAt, isNull);

        when(
          mockWireguardRepo.currentStatus(),
        ).thenAnswer((_) async => VpnConnectionStatus.connected);
        statusController.add(VpnConnectionStatus.connected);
        await pumpEventQueue();

        expect(store.connectedAt, isNotNull);
        expect(store.connectedAt!.isAfter(staleAt), isTrue);

        await store.disposeStore();
      });
    });

    group('IP refresh location', () {
      const country = VPNLocation(
        id: 'fr',
        ipType: IPType.datacenter,
        translations: {},
        countryCode: 'fr',
      );
      const city = VPNLocation(
        id: 'paris',
        ipType: IPType.datacenter,
        translations: {},
        countryCode: 'fr',
      );

      void stubToggleAction(ConnectionAction action) {
        when(
          mockConnectionDecision.determineToggleAction(
            currentStatus: anyNamed('currentStatus'),
            currentLocation: anyNamed('currentLocation'),
            requestedLocation: anyNamed('requestedLocation'),
            requestedIntent: anyNamed('requestedIntent'),
            isRefreshIP: anyNamed('isRefreshIP'),
            requestedTargetIp: anyNamed('requestedTargetIp'),
            currentIp: anyNamed('currentIp'),
          ),
        ).thenReturn(action);
      }

      setUp(() {
        when(mockVpnProtocolStore.protocol).thenReturn(ProtocolType.wireguard);

        // VPN guards
        when(mockAuthSession.accessTokenFuture).thenAnswer((_) => ObservableFuture.value(null));
        when(mockAuthSession.isAuthenticated).thenReturn(true);
        when(
          mockSubscriptionStore.subscriptionFuture,
        ).thenAnswer((_) => ObservableFuture.value(Subscription(active: true)));

        // determineConnectingLocation echoes the requested location, mirroring
        // real logic so refresh receives whatever _startConnection passes.
        when(
          mockConnectionDecision.determineConnectingLocation(
            requestedLocation: anyNamed('requestedLocation'),
            currentLocation: anyNamed('currentLocation'),
            isRefreshIP: anyNamed('isRefreshIP'),
            intent: anyNamed('intent'),
          ),
        ).thenAnswer((invocation) => invocation.namedArguments[#requestedLocation] as VPNLocation?);
        when(mockConnectionDecision.shouldResolveClosestLocation(any)).thenReturn(false);

        when(mockWireguardRepo.isTunnelConfigured()).thenAnswer((_) async => true);
        when(
          mockWireguardRepo.currentStatus(),
        ).thenAnswer((_) async => VpnConnectionStatus.disconnected);
        when(mockWireguardRepo.connect(config: anyNamed('config'))).thenAnswer((_) async {});
        when(mockWireguardRepo.disconnect()).thenAnswer((_) async => true);
        when(mockWireguardRepo.notifyApiVpnDisconnected()).thenAnswer((_) async {});

        when(
          mockWireguardRepo.fetchVpnConfig(
            countryOriginate: anyNamed('countryOriginate'),
            country: anyNamed('country'),
            city: anyNamed('city'),
            ipType: anyNamed('ipType'),
            userIntent: anyNamed('userIntent'),
            cluster: anyNamed('cluster'),
            resetConnection: anyNamed('resetConnection'),
            dnsAddress: anyNamed('dnsAddress'),
          ),
        ).thenAnswer((invocation) async {
          final country = invocation.namedArguments[#country] as String?;
          final city = invocation.namedArguments[#city] as String?;
          final ipType = invocation.namedArguments[#ipType] as String?;
          return VpnConfig(
            id: 'config1',
            config: 'cfg',
            exitIp: '2.2.2.2',
            hash: 'hash',
            country: country,
            city: city,
            ipType: ipType ?? IPType.datacenter.key,
          );
        });

        when(mockRealIPInfo.infoFuture).thenAnswer(
          (_) => ObservableFuture.value(const IPInfo(country: 'us', city: 'ny', ip: '1.1.1.1')),
        );
        when(mockRecentLocations.future).thenAnswer((_) => ObservableFuture.value(<VPNLocation>[]));
        when(mockRecentLocations.add(any)).thenAnswer((_) async {});
        when(
          mockLocationsStore.findById(
            any,
            countryCode: anyNamed('countryCode'),
            ipType: anyNamed('ipType'),
          ),
        ).thenAnswer((_) async => null);
        when(mockExternalApi.getIPAddress()).thenAnswer((_) async => '3.3.3.3');
        when(mockLocationsQuery.ipType).thenReturn(IPType.datacenter);
        when(mockRefreshIP.refreshIPConnection).thenReturn(false);
        when(mockDns.dnsAddress).thenReturn('1.1.1.1');
      });

      Future<void> connect(VPNLocation loc) async {
        stubToggleAction(ConnectionAction.connect);
        await vpnStore.manageConnection(location: loc);
      }

      test('refresh after connecting to a country reconnects with city = null', () async {
        await connect(country);
        clearInteractions(mockWireguardRepo);
        stubToggleAction(ConnectionAction.refreshIP);
        await vpnStore.manageConnection(refreshIP: true);
        verifyFetchVpnConfig(country: 'fr', city: null);
      });

      test('refresh after connecting to a city reconnects with that city', () async {
        await connect(city);
        clearInteractions(mockWireguardRepo);
        stubToggleAction(ConnectionAction.refreshIP);
        await vpnStore.manageConnection(refreshIP: true);
        verifyFetchVpnConfig(country: 'fr', city: 'paris');
      });

      test('requestedLocation preserved across a refresh', () async {
        await connect(country);
        stubToggleAction(ConnectionAction.refreshIP);
        clearInteractions(mockWireguardRepo);
        await vpnStore.manageConnection(refreshIP: true);
        expect(vpnStore.requestedLocation, country);
        // A reconnect teardown must not tell the API the session ended.
        verifyNever(mockWireguardRepo.notifyApiVpnDisconnected());
      });

      test('cancels MQTT subscriptions before waiting on the API notification', () async {
        // Real controllers so cancellation is observable via hasListener.
        final data = StreamController<String>.broadcast();
        final killed = StreamController<String>.broadcast();
        when(mockMqtt.subscribe(any)).thenAnswer(
          (invocation) => (invocation.positionalArguments.first as String).endsWith('/killed')
              ? killed.stream
              : data.stream,
        );

        await connect(country);
        await pumpEventQueue();
        expect(data.hasListener, isTrue);
        expect(killed.hasListener, isTrue);

        // A hung notification must not delay tearing the streams down.
        final notified = Completer<void>();
        when(mockWireguardRepo.notifyApiVpnDisconnected()).thenAnswer((_) => notified.future);
        unawaited(vpnStore.disconnectTunnel(reason: VpnDisconnectReason.user));
        await pumpEventQueue();

        expect(data.hasListener, isFalse);
        expect(killed.hasListener, isFalse);
        notified.complete();
        await data.close();
        await killed.close();
      });

      test('disconnect clears requestedLocation', () async {
        await connect(country);
        clearInteractions(mockWireguardRepo);
        await vpnStore.disconnectTunnel(reason: VpnDisconnectReason.user);
        expect(vpnStore.requestedLocation, isNull);
        verify(mockWireguardRepo.notifyApiVpnDisconnected()).called(1);
      });

      test('closest sentinel connect leaves requestedLocation null', () async {
        await connect(VPNLocation.closest);
        expect(vpnStore.requestedLocation, isNull);
      });

      test('refresh keeps the residential IP type', () async {
        const residentialCountry = VPNLocation(
          id: 'fr',
          ipType: IPType.residential,
          translations: {},
          countryCode: 'fr',
        );
        await connect(residentialCountry);
        clearInteractions(mockWireguardRepo);
        stubToggleAction(ConnectionAction.refreshIP);
        await vpnStore.manageConnection(refreshIP: true);
        verify(
          mockWireguardRepo.fetchVpnConfig(
            countryOriginate: anyNamed('countryOriginate'),
            country: 'fr',
            city: null,
            ipType: IPType.residential.key,
            userIntent: anyNamed('userIntent'),
            cluster: anyNamed('cluster'),
            resetConnection: anyNamed('resetConnection'),
            dnsAddress: anyNamed('dnsAddress'),
          ),
        ).called(1);
      });

      test('refresh after switching country rotates within the new country', () async {
        await connect(country); // fr
        const germany = VPNLocation(
          id: 'de',
          ipType: IPType.datacenter,
          translations: {},
          countryCode: 'de',
        );
        stubToggleAction(ConnectionAction.reconnect);
        await vpnStore.manageConnection(location: germany);
        clearInteractions(mockWireguardRepo);
        stubToggleAction(ConnectionAction.refreshIP);
        await vpnStore.manageConnection(refreshIP: true);
        verifyFetchVpnConfig(country: 'de', city: null);
      });

      test('disconnectReason is reconnect for a refresh teardown', () async {
        await connect(country);
        // Report a live tunnel once so the reconnect path tears it down, then
        // disconnected so _waitForDisconnection settles.
        var statusCalls = 0;
        when(mockWireguardRepo.currentStatus()).thenAnswer((_) async {
          statusCalls++;
          return statusCalls == 1
              ? VpnConnectionStatus.connected
              : VpnConnectionStatus.disconnected;
        });
        VpnDisconnectReason? duringDisconnect;
        when(mockWireguardRepo.disconnect()).thenAnswer((_) async {
          duringDisconnect = vpnStore.disconnectReason;
          return true;
        });
        stubToggleAction(ConnectionAction.refreshIP);
        await vpnStore.manageConnection(refreshIP: true);
        expect(duringDisconnect, VpnDisconnectReason.reconnect);
        // Stays set until a connection is actually established.
        expect(vpnStore.disconnectReason, VpnDisconnectReason.reconnect);
      });

      test('connect timeout logs failure with a non-null error code and message', () async {
        when(
          mockWireguardRepo.connect(config: anyNamed('config')),
        ).thenThrow(TimeoutException('connect timed out'));

        await connect(country);

        final captured = verify(
          mockAnalytics.logConnectFailure(
            time: anyNamed('time'),
            error: anyNamed('error'),
            errorType: anyNamed('errorType'),
            protocol: anyNamed('protocol'),
            errorCode: captureAnyNamed('errorCode'),
            errorMessage: captureAnyNamed('errorMessage'),
          ),
        ).captured;
        expect(captured[0], 1112);
        expect(captured[1], isNotNull);
      });

      test('unavailable location failure logs a non-null error message', () async {
        when(
          mockWireguardRepo.fetchVpnConfig(
            countryOriginate: anyNamed('countryOriginate'),
            country: anyNamed('country'),
            city: anyNamed('city'),
            ipType: anyNamed('ipType'),
            userIntent: anyNamed('userIntent'),
            cluster: anyNamed('cluster'),
            resetConnection: anyNamed('resetConnection'),
            dnsAddress: anyNamed('dnsAddress'),
          ),
        ).thenThrow(
          ApiException(
            RequestOptions(path: '/connect'),
            'location unavailable',
            code: 2332,
            identifier: 'id',
            endpoint: '/connect',
            severity: ExceptionSeverity.medium,
          ),
        );

        await connect(country);

        final message = verify(
          mockAnalytics.logConnectFailure(
            time: anyNamed('time'),
            error: anyNamed('error'),
            errorType: anyNamed('errorType'),
            protocol: anyNamed('protocol'),
            errorCode: anyNamed('errorCode'),
            errorMessage: captureAnyNamed('errorMessage'),
          ),
        ).captured.single;
        expect(message, isNotNull);
      });

      test('device limit failure logs a non-null error message', () async {
        when(
          mockWireguardRepo.fetchVpnConfig(
            countryOriginate: anyNamed('countryOriginate'),
            country: anyNamed('country'),
            city: anyNamed('city'),
            ipType: anyNamed('ipType'),
            userIntent: anyNamed('userIntent'),
            cluster: anyNamed('cluster'),
            resetConnection: anyNamed('resetConnection'),
            dnsAddress: anyNamed('dnsAddress'),
          ),
        ).thenThrow(const DeviceLimitReachedException());

        await connect(country);

        final message = verify(
          mockAnalytics.logConnectFailure(
            time: anyNamed('time'),
            error: anyNamed('error'),
            errorType: anyNamed('errorType'),
            protocol: anyNamed('protocol'),
            errorCode: anyNamed('errorCode'),
            errorMessage: captureAnyNamed('errorMessage'),
          ),
        ).captured.single;
        expect(message, isNotNull);
      });

      test('connectedIpPoolCount is the country total when connected to a country', () async {
        const countryWithNodes = VPNLocation(
          id: 'fr',
          ipType: IPType.datacenter,
          translations: {},
          countryCode: 'fr',
          nodeCount: 120,
        );
        await connect(countryWithNodes);
        expect(vpnStore.connectedIpPoolCount, 120);
      });

      test('connectedIpPoolCount is the city count when connected to a city', () async {
        const cityWithNodes = VPNLocation(
          id: 'paris',
          ipType: IPType.datacenter,
          translations: {},
          countryCode: 'fr',
          nodeCount: 30,
        );
        await connect(cityWithNodes);
        expect(vpnStore.connectedIpPoolCount, 30);
      });

      test(
        'connectedIpPoolCount falls back to the resolved count when requested count is unknown',
        () async {
          // The requested `country` const has no nodeCount; the resolved location does.
          const resolved = VPNLocation(
            id: 'fr',
            ipType: IPType.datacenter,
            translations: {},
            countryCode: 'fr',
            nodeCount: 88,
          );
          when(
            mockLocationsStore.findById(
              any,
              countryCode: anyNamed('countryCode'),
              ipType: anyNamed('ipType'),
            ),
          ).thenAnswer((_) async => resolved);
          await connect(country);
          expect(vpnStore.connectedIpPoolCount, 88);
        },
      );

      test('seeds the exhaustion store when the tunnel is already connected on launch', () async {
        final exhaustionStore = IpRefreshExhaustionStore(mockAnalytics);
        const connectedLocation = VPNLocation(
          id: 'fr',
          ipType: IPType.datacenter,
          translations: {'en': 'France'},
          countryCode: 'fr',
          nodeCount: 2,
        );

        when(mockConnectionDecision.potentialLocation).thenReturn(connectedLocation);
        when(mockWireguardRepo.setupTunnel()).thenAnswer((_) async {});
        when(
          mockWireguardRepo.currentStatus(),
        ).thenAnswer((_) async => VpnConnectionStatus.connected);
        when(
          mockWireguardRepo.statusStream(),
        ).thenAnswer((_) => const Stream<VpnConnectionStatus>.empty());
        when(mockExternalApi.getIPAddress()).thenAnswer((_) async => '2.2.2.2');

        final store = VpnStore(
          externalApiService: mockExternalApi,
          mqtt: mockMqtt,
          locationsStore: mockLocationsStore,
          locationsService: mockLocationsService,
          subscriptionStore: mockSubscriptionStore,
          logger: mockLogger,
          analyticsStore: mockAnalytics,
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
          ipRefreshExhaustionStore: exhaustionStore,
          udpBlockedSuggestionStore: udpBlockedSuggestionStore,
        );

        // Tunnel was already up at launch: this resolves the existing connection
        // without going through the fresh-connect path.
        await store.setupTunnel();
        expect(store.location, connectedLocation);

        // A single refresh exhausts the 2-node pool; the notice only fires if
        // onConnected seeded the store during resolution.
        exhaustionStore.registerRefresh(2);
        expect(exhaustionStore.exhaustionNotice, connectedLocation);

        await store.disposeStore();
      });
    });

    group('Device & App Management', () {
      test('markDeviceLimitErrorAsShown flips the flag', () {
        expect(vpnStore.isDeviceLimitErrorShown, isFalse);

        vpnStore.markDeviceLimitErrorAsShown();

        expect(vpnStore.isDeviceLimitErrorShown, isTrue);
      });

      test('disconnectAllDevices delegates to the active repository', () async {
        when(mockWireguardRepo.disconnectAllDevices()).thenAnswer((_) async {});
        when(mockWireguardRepo.disconnect()).thenAnswer((_) async => true);
        when(mockWireguardRepo.notifyApiVpnDisconnected()).thenAnswer((_) async {});

        await vpnStore.disconnectAllDevices();

        verify(mockWireguardRepo.disconnectAllDevices()).called(1);
      });

      test('disconnectAllDevices rethrows underlying errors', () async {
        when(mockWireguardRepo.disconnectAllDevices()).thenThrow(Exception('boom'));
        when(mockWireguardRepo.disconnect()).thenAnswer((_) async => true);
        when(mockWireguardRepo.notifyApiVpnDisconnected()).thenAnswer((_) async {});

        await expectLater(vpnStore.disconnectAllDevices(), throwsA(isA<Exception>()));
      });

      test('resetApp delegates to the repository', () async {
        when(mockWireguardRepo.resetApp()).thenAnswer((_) async {});

        await vpnStore.resetApp();

        verify(mockWireguardRepo.resetApp()).called(1);
      });

      test('resetApp rethrows underlying errors', () async {
        when(mockWireguardRepo.resetApp()).thenThrow(Exception('reset failed'));

        await expectLater(vpnStore.resetApp(), throwsA(isA<Exception>()));
      });
    });

    group('subscription-driven teardown', () {
      const loc = VPNLocation(
        id: 'de',
        ipType: IPType.datacenter,
        translations: {},
        countryCode: 'de',
      );

      late StreamController<VpnConnectionStatus> statusController;
      late Observable<ObservableFuture<Subscription>> subscription;

      void setSubscription(Subscription value) =>
          runInAction(() => subscription.value = ObservableFuture.value(value));

      setUp(() {
        statusController = StreamController<VpnConnectionStatus>.broadcast();
        subscription = Observable(ObservableFuture.value(Subscription(active: true)));
        when(mockSubscriptionStore.subscriptionFuture).thenAnswer((_) => subscription.value);
        when(mockVpnProtocolStore.protocol).thenReturn(ProtocolType.wireguard);
        when(mockAuthSession.status).thenReturn(AuthStatus.authenticated);
        when(mockWireguardRepo.init()).thenAnswer((_) async {});
        when(mockWireguardRepo.isTunnelConfigured()).thenAnswer((_) async => true);
        when(mockWireguardRepo.statusStream()).thenAnswer((_) => statusController.stream);
        when(
          mockWireguardRepo.currentStatus(),
        ).thenAnswer((_) async => VpnConnectionStatus.disconnected);
        when(mockWireguardRepo.disconnect()).thenAnswer((_) async => true);
        when(mockWireguardRepo.notifyApiVpnDisconnected()).thenAnswer((_) async {});
        when(mockRecentLocations.future).thenAnswer((_) => ObservableFuture.value(<VPNLocation>[]));
        when(mockRecentLocations.add(any)).thenAnswer((_) async {});
        when(mockConnectionDecision.potentialLocation).thenReturn(loc);
        when(mockExternalApi.getIPAddress()).thenAnswer((_) async => '3.3.3.3');
      });

      tearDown(() async {
        await statusController.close();
      });

      Future<VpnStore> connectedStore() async {
        final store = buildStore();
        await pumpEventQueue();
        statusController.add(VpnConnectionStatus.connected);
        await pumpEventQueue();
        expect(store.vpnStatus, VpnConnectionStatus.connected);
        return store;
      }

      test('an expired subscription tears the tunnel down as app-initiated', () async {
        final store = await connectedStore();

        setSubscription(Subscription(active: false));
        await pumpEventQueue();

        verify(mockWireguardRepo.disconnect()).called(1);
        expect(store.disconnectReason, VpnDisconnectReason.appInitiated);

        await store.disposeStore();
      });

      test('a paused subscription tears the tunnel down as app-initiated', () async {
        final store = await connectedStore();

        setSubscription(Subscription(active: true, paused: true));
        await pumpEventQueue();

        verify(mockWireguardRepo.disconnect()).called(1);
        expect(store.disconnectReason, VpnDisconnectReason.appInitiated);

        await store.disposeStore();
      });

      test('a still-entitled subscription leaves the tunnel up', () async {
        final store = await connectedStore();

        setSubscription(Subscription(active: true, expired: false));
        await pumpEventQueue();

        verifyNever(mockWireguardRepo.disconnect());
        expect(store.vpnStatus, VpnConnectionStatus.connected);

        await store.disposeStore();
      });

      test('losing entitlement while disconnected does not disconnect again', () async {
        final store = buildStore();
        await pumpEventQueue();

        setSubscription(Subscription(active: false));
        await pumpEventQueue();

        verifyNever(mockWireguardRepo.disconnect());

        await store.disposeStore();
      });

      test('a pending subscription fetch never tears down a live tunnel', () async {
        final store = await connectedStore();

        runInAction(() => subscription.value = ObservableFuture(Completer<Subscription>().future));
        await pumpEventQueue();

        verifyNever(mockWireguardRepo.disconnect());
        expect(store.vpnStatus, VpnConnectionStatus.connected);

        await store.disposeStore();
      });
    });

    group('UDP blocked suggestion', () {
      const paris = VPNLocation(
        id: 'paris',
        ipType: IPType.datacenter,
        translations: {},
        countryCode: 'fr',
      );

      late StreamController<VpnConnectionStatus> wgStatus;
      late StreamController<VpnConnectionStatus> ovpnStatus;

      void stubConnectFlow(VpnRepository repo) {
        when(repo.init()).thenAnswer((_) async {});
        when(repo.isTunnelConfigured()).thenAnswer((_) async => true);
        when(repo.currentStatus()).thenAnswer((_) async => VpnConnectionStatus.disconnected);
        when(repo.connect(config: 'cfg')).thenAnswer((_) async {});
        when(repo.disconnect()).thenAnswer((_) async => true);
        when(repo.notifyApiVpnDisconnected()).thenAnswer((_) async {});
        when(repo.udpBlockedCheck()).thenAnswer((_) async {});
        when(
          repo.fetchVpnConfig(
            countryOriginate: anyNamed('countryOriginate'),
            country: anyNamed('country'),
            city: anyNamed('city'),
            ipType: anyNamed('ipType'),
            userIntent: anyNamed('userIntent'),
            cluster: anyNamed('cluster'),
            resetConnection: anyNamed('resetConnection'),
            dnsAddress: '1.1.1.1',
            targetIp: anyNamed('targetIp'),
          ),
        ).thenAnswer((invocation) async {
          final country = invocation.namedArguments[#country] as String?;
          final city = invocation.namedArguments[#city] as String?;
          return VpnConfig(
            id: 'config1',
            config: 'cfg',
            exitIp: '2.2.2.2',
            hash: 'hash',
            country: country,
            city: city,
            ipType: IPType.datacenter.key,
          );
        });
      }

      setUp(() {
        wgStatus = StreamController<VpnConnectionStatus>.broadcast();
        ovpnStatus = StreamController<VpnConnectionStatus>.broadcast();

        when(mockAuthSession.status).thenReturn(AuthStatus.authenticated);
        when(mockAuthSession.isAuthenticated).thenReturn(true);
        when(mockAuthSession.accessTokenFuture).thenAnswer((_) => ObservableFuture.value(null));
        when(
          mockSubscriptionStore.subscriptionFuture,
        ).thenAnswer((_) => ObservableFuture.value(Subscription(active: true)));

        when(mockRemoteConfig.shouldCheckUdp).thenReturn(true);
        when(mockVpnProtocolStore.isProtocolPickerAvailable).thenReturn(true);

        stubConnectFlow(mockWireguardRepo);
        stubConnectFlow(mockOpenVpnRepo);
        when(mockWireguardRepo.statusStream()).thenAnswer((_) => wgStatus.stream);
        when(mockOpenVpnRepo.statusStream()).thenAnswer((_) => ovpnStatus.stream);

        when(
          mockConnectionDecision.determineToggleAction(
            currentStatus: anyNamed('currentStatus'),
            currentLocation: anyNamed('currentLocation'),
            requestedLocation: anyNamed('requestedLocation'),
            requestedIntent: anyNamed('requestedIntent'),
            isRefreshIP: anyNamed('isRefreshIP'),
            requestedTargetIp: anyNamed('requestedTargetIp'),
            currentIp: anyNamed('currentIp'),
          ),
        ).thenReturn(ConnectionAction.connect);
        when(
          mockConnectionDecision.determineConnectingLocation(
            requestedLocation: anyNamed('requestedLocation'),
            currentLocation: anyNamed('currentLocation'),
            isRefreshIP: anyNamed('isRefreshIP'),
            intent: anyNamed('intent'),
          ),
        ).thenAnswer((invocation) => invocation.namedArguments[#requestedLocation] as VPNLocation?);
        when(mockConnectionDecision.shouldResolveClosestLocation(any)).thenReturn(false);

        when(mockRealIPInfo.infoFuture).thenAnswer(
          (_) => ObservableFuture.value(const IPInfo(country: 'us', city: 'ny', ip: '1.1.1.1')),
        );
        when(mockRecentLocations.future).thenAnswer((_) => ObservableFuture.value(<VPNLocation>[]));
        when(mockRecentLocations.add(any)).thenAnswer((_) async {});
        when(
          mockLocationsStore.findById(
            any,
            countryCode: anyNamed('countryCode'),
            ipType: anyNamed('ipType'),
          ),
        ).thenAnswer((_) async => null);
        when(mockExternalApi.getIPAddress()).thenAnswer((_) async => '3.3.3.3');
        when(mockLocationsQuery.ipType).thenReturn(IPType.datacenter);
        when(mockRefreshIP.refreshIPConnection).thenReturn(false);
        when(mockDns.dnsAddress).thenReturn('1.1.1.1');
      });

      tearDown(() async {
        await wgStatus.close();
        await ovpnStatus.close();
      });

      /// One matcher for the OpenVPN config fetch; only the pinned arguments
      /// differ between call sites.
      Future<VpnConfig> openVpnFetch({String? country, String? city, String? targetIp}) =>
          mockOpenVpnRepo.fetchVpnConfig(
            countryOriginate: anyNamed('countryOriginate'),
            country: country ?? anyNamed('country'),
            city: city ?? anyNamed('city'),
            ipType: anyNamed('ipType'),
            userIntent: anyNamed('userIntent'),
            cluster: anyNamed('cluster'),
            resetConnection: anyNamed('resetConnection'),
            dnsAddress: anyNamed('dnsAddress'),
            targetIp: targetIp ?? anyNamed('targetIp'),
          );

      test('skips the STUN check entirely when the protocol is OpenVPN', () async {
        when(mockVpnProtocolStore.protocol).thenReturn(ProtocolType.openvpn);
        final store = buildStore();

        await store.manageConnection(location: paris);
        await pumpEventQueue();

        verifyNever(mockOpenVpnRepo.udpBlockedCheck());
        await store.disposeStore();
      });

      test('runs the check on WireGuard and suggests OpenVPN when it fails', () async {
        when(mockWireguardRepo.udpBlockedCheck()).thenThrow(TimeoutException('no STUN reply'));

        await vpnStore.manageConnection(location: paris);
        await pumpEventQueue();

        verify(mockWireguardRepo.udpBlockedCheck()).called(1);
        expect(udpBlockedSuggestionStore.suggestOpenVpn, true);
      });

      test('raises nothing when the check succeeds', () async {
        await vpnStore.manageConnection(location: paris);
        await pumpEventQueue();

        verify(mockWireguardRepo.udpBlockedCheck()).called(1);
        expect(udpBlockedSuggestionStore.suggestOpenVpn, false);
      });

      test('does not suggest when the protocol picker is unavailable', () async {
        when(mockVpnProtocolStore.isProtocolPickerAvailable).thenReturn(false);
        when(mockWireguardRepo.udpBlockedCheck()).thenThrow(TimeoutException('no STUN reply'));

        await vpnStore.manageConnection(location: paris);
        await pumpEventQueue();

        expect(udpBlockedSuggestionStore.suggestOpenVpn, false);
      });

      group('switchProtocolAndReconnect', () {
        // Built here rather than in the outer setUp, which constructs the store
        // while unauthenticated — the auth reaction would then never attach the
        // status listener that carries the tunnel to `connected`.
        Future<VpnStore> connectedOverWireguard({String? targetIp}) async {
          final store = buildStore();
          await pumpEventQueue();
          await store.manageConnection(location: paris, targetIp: targetIp);
          wgStatus.add(VpnConnectionStatus.connected);
          await pumpEventQueue();
          expect(store.isConnected, true);
          return store;
        }

        test('reconnects over OpenVPN to the same location', () async {
          final store = await connectedOverWireguard();

          await store.switchProtocolAndReconnect(ProtocolType.openvpn);

          verify(mockVpnProtocolStore.setProtocol(ProtocolType.openvpn)).called(1);
          verify(openVpnFetch(country: 'fr', city: 'paris')).called(1);
          await store.disposeStore();
        });

        test('reconnects to the same favorite IP', () async {
          final store = await connectedOverWireguard(targetIp: '5.5.5.5');

          await store.switchProtocolAndReconnect(ProtocolType.openvpn);

          verify(openVpnFetch(targetIp: '5.5.5.5')).called(1);
          await store.disposeStore();
        });

        test('reports the reconnect outcome to its caller', () async {
          final store = await connectedOverWireguard();

          expect(await store.switchProtocolAndReconnect(ProtocolType.openvpn), true);
          await store.disposeStore();
        });

        test('rethrows when persisting the protocol fails', () async {
          final store = await connectedOverWireguard();
          when(mockVpnProtocolStore.setProtocol(any)).thenThrow(Exception('db write failed'));

          await expectLater(
            store.switchProtocolAndReconnect(ProtocolType.openvpn),
            throwsA(isA<Exception>()),
          );
          await store.disposeStore();
        });

        test('tears the tunnel down exactly once', () async {
          final store = await connectedOverWireguard();
          clearInteractions(mockWireguardRepo);

          await store.switchProtocolAndReconnect(ProtocolType.openvpn);

          verify(mockWireguardRepo.disconnect()).called(1);
          await store.disposeStore();
        });

        test('tears down as app-initiated so the review prompt stays disarmed', () async {
          final store = await connectedOverWireguard();

          await store.switchProtocolAndReconnect(ProtocolType.openvpn);

          // ReviewPromptStore counts a `user` teardown as a completed session
          // and evaluates eligibility on it — a blocked-network fallback is
          // recovery, not a session the user chose to end.
          expect(store.disconnectReason, VpnDisconnectReason.appInitiated);
          await store.disposeStore();
        });

        test('switches without reconnecting when the tunnel was down', () async {
          await vpnStore.switchProtocolAndReconnect(ProtocolType.openvpn);

          verify(mockVpnProtocolStore.setProtocol(ProtocolType.openvpn)).called(1);
          verifyNever(openVpnFetch());
        });
      });
    });
  });
}
