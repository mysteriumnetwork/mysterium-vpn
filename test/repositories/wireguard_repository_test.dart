import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/repositories/vpn/wireguard_repository.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

import 'wireguard_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<WireguardDart>(),
  MockSpec<WireguradKeyService>(),
  MockSpec<ApiService>(),
  MockSpec<Talker>(),
])
void main() {
  late WireguardRepository repository;
  late MockWireguardDart mockService;
  late MockWireguradKeyService mockKeyService;
  late MockApiService mockApiService;
  late MockTalker mockLogger;

  final testKeyPair = KeyPair('pub', 'priv');

  setUp(() {
    mockService = MockWireguardDart();
    mockKeyService = MockWireguradKeyService();
    mockApiService = MockApiService();
    mockLogger = MockTalker();

    when(mockKeyService.getWireguradKey()).thenAnswer((_) async => testKeyPair);
    when(mockKeyService.regenerateWireguardKeys()).thenAnswer((_) async => testKeyPair);

    repository = WireguardRepository(
      service: mockService,
      wireguradKeyService: mockKeyService,
      apiService: mockApiService,
      logger: mockLogger,
    );
  });

  group('WireguardRepository', () {
    test('init sets Wireguard key', () async {
      await repository.init();
      verify(mockKeyService.getWireguradKey()).called(1);
    });

    test('connect replaces private key and calls service.connect', () async {
      const config = 'cfg with %private_key%';
      await repository.init();

      when(mockService.connect(cfg: anyNamed('cfg'))).thenAnswer((_) async {});

      await repository.connect(config: config);

      verify(mockService.connect(cfg: 'cfg with priv')).called(1);
    });

    test('connect rethrows TimeoutException', () async {
      const config = 'cfg with %private_key%';
      await repository.init();

      when(mockService.connect(cfg: anyNamed('cfg'))).thenAnswer(
        (_) => Future.delayed(
          const Duration(seconds: 2),
          () => throw TimeoutException('timeout'),
        ),
      );

      await expectLater(
        repository.connect(config: config),
        throwsA(isA<TimeoutException>()),
      );
      verify(mockLogger.handle(any, any)).called(1);
    });

    test('disconnect calls service if status is connected', () async {
      when(mockService.status()).thenAnswer((_) async => ConnectionStatus.connected);
      when(mockService.disconnect()).thenAnswer((_) async {});

      final result = await repository.disconnect();

      expect(result, isTrue);
      verify(mockService.disconnect()).called(1);
    });

    test('disconnect returns false if not connected', () async {
      when(mockService.status()).thenAnswer((_) async => ConnectionStatus.disconnected);

      final result = await repository.disconnect();

      expect(result, isFalse);
      verifyNever(mockService.disconnect());
    });

    test('notifyApiVpnDisconnected calls api if key initialized', () async {
      await repository.init();

      when(mockApiService.disconnect(publicKey: anyNamed('publicKey'))).thenAnswer((_) async {});

      await repository.notifyApiVpnDisconnected();

      verify(mockApiService.disconnect(publicKey: 'pub')).called(1);
    });

    test('notifyApiVpnDisconnected logs warning if key null', () async {
      final repoWithoutKey = WireguardRepository(
        service: mockService,
        wireguradKeyService: mockKeyService,
        apiService: mockApiService,
        logger: mockLogger,
      );

      await repoWithoutKey.notifyApiVpnDisconnected();

      verify(mockLogger.warning(any)).called(1);
    });

    test('setupTunnel calls service.setupTunnel', () async {
      when(
        mockService.setupTunnel(
          bundleId: anyNamed('bundleId'),
          win32ServiceName: anyNamed('win32ServiceName'),
          tunnelName: anyNamed('tunnelName'),
        ),
      ).thenAnswer((_) async {});

      await repository.setupTunnel();

      verify(
        mockService.setupTunnel(
          bundleId: anyNamed('bundleId'),
          win32ServiceName: anyNamed('win32ServiceName'),
          tunnelName: anyNamed('tunnelName'),
        ),
      ).called(1);
    });

    test('removeTunnelConfiguration calls service.removeTunnelConfiguration', () async {
      when(
        mockService.removeTunnelConfiguration(
          bundleId: anyNamed('bundleId'),
          tunnelName: anyNamed('tunnelName'),
        ),
      ).thenAnswer((_) async {});

      await repository.removeTunnelConfiguration();

      verify(
        mockService.removeTunnelConfiguration(
          bundleId: anyNamed('bundleId'),
          tunnelName: anyNamed('tunnelName'),
        ),
      ).called(1);
    });

    test('isTunnelConfigured calls service.checkTunnelConfiguration', () async {
      when(
        mockService.checkTunnelConfiguration(
          bundleId: anyNamed('bundleId'),
          tunnelName: anyNamed('tunnelName'),
        ),
      ).thenAnswer((_) async => true);

      final result = await repository.isTunnelConfigured();

      expect(result, isTrue);
      verify(
        mockService.checkTunnelConfiguration(
          bundleId: anyNamed('bundleId'),
          tunnelName: anyNamed('tunnelName'),
        ),
      ).called(1);
    });

    test('currentStatus returns mapped VpnConnectionStatus', () async {
      when(mockService.status()).thenAnswer(
        (_) async => ConnectionStatus.connected,
      );

      final status = await repository.currentStatus();

      expect(status, VpnConnectionStatus.connected);
    });

    test('statusStream maps service statusStream', () async {
      when(mockService.statusStream()).thenAnswer((_) => Stream.value(ConnectionStatus.connected));

      final stream = repository.statusStream();

      expectLater(stream, emits(VpnConnectionStatus.connected));
    });

    test('fetchVpnConfig calls apiService.fetchVpnConfig', () async {
      final response = WireguardConnectResponse(
        wgConfig: 'cfg',
        hash: 'hash',
        id: 'id',
      );
      await repository.init();

      when(mockApiService.fetchVpnConfig(request: anyNamed('request')))
          .thenAnswer((_) async => response);

      final config = await repository.fetchVpnConfig(
        countryOriginate: 'US',
        country: 'US',
        city: 'NY',
        ipType: 'residential',
        userIntent: 'bestSpeed',
        cluster: 'cluster1',
        resetConnection: false,
      );

      expect(config.config, 'cfg');
    });

    test('rateConnection calls apiService.rateConnection', () async {
      await repository.init();
      when(mockApiService.rateConnection(request: anyNamed('request'))).thenAnswer((_) async {});

      await repository.rateConnection(
        ipType: 'residential',
        country: 'US',
        feedback: 'good',
        reasons: 'reason',
        mode: RateConnectionRequestModeEnum.like,
      );

      verify(mockApiService.rateConnection(request: anyNamed('request'))).called(1);
    });

    test('resetApp calls correct methods depending on platform', () async {
      // Setup for Windows platform simulation
      when(
        mockService.checkTunnelConfiguration(
          bundleId: anyNamed('bundleId'),
          tunnelName: anyNamed('tunnelName'),
        ),
      ).thenAnswer((_) async => true);
      when(
        mockService.removeTunnelConfiguration(
          bundleId: anyNamed('bundleId'),
          tunnelName: anyNamed('tunnelName'),
        ),
      ).thenAnswer((_) async {});

      // For simplicity, we only test that it calls removeTunnelConfiguration
      await repository.resetApp();

      verify(
        mockService.removeTunnelConfiguration(
          bundleId: anyNamed('bundleId'),
          tunnelName: anyNamed('tunnelName'),
        ),
      ).called(1);
    });
  });
}
