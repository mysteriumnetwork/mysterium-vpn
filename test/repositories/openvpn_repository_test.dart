import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/repositories/vpn/openvpn_repository.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:openvpn_dart/openvpn_dart.dart';
import 'package:openvpn_dart/vpn_statistics.dart';
import 'package:openvpn_dart/vpn_status.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

import 'openvpn_repository_test.mocks.dart';

@GenerateNiceMocks([MockSpec<OpenVPNDart>(), MockSpec<ApiService>(), MockSpec<Talker>()])
void main() {
  late MockOpenVPNDart service;
  late MockApiService api;
  late MockTalker logger;
  late OpenVpnRepository repo;

  setUp(() {
    service = MockOpenVPNDart();
    api = MockApiService();
    logger = MockTalker();

    repo = OpenVpnRepository(service: service, apiService: api, logger: logger);
  });

  group('init / setupTunnel', () {
    test('init delegates to OpenVPNDart.initialize', () async {
      when(
        service.initialize(
          providerBundleIdentifier: anyNamed('providerBundleIdentifier'),
          localizedDescription: anyNamed('localizedDescription'),
        ),
      ).thenAnswer((_) async {});

      await repo.init();

      verify(
        service.initialize(
          providerBundleIdentifier: anyNamed('providerBundleIdentifier'),
          localizedDescription: anyNamed('localizedDescription'),
        ),
      ).called(1);
    });

    test('setupTunnel delegates to service and rethrows on error', () async {
      when(service.setupTunnel()).thenAnswer((_) async {});
      await repo.setupTunnel();
      verify(service.setupTunnel()).called(1);

      when(service.setupTunnel()).thenThrow(Exception('boom'));
      await expectLater(repo.setupTunnel(), throwsA(isA<Exception>()));
    });
  });

  group('connect', () {
    test('passes config through and resolves on success', () async {
      when(service.connect(any)).thenAnswer((_) async {});

      await repo.connect(config: 'remote example.com 1194\n');

      verify(service.connect('remote example.com 1194\n')).called(1);
    });

    test('wraps non-timeout errors in VpnConnectException', () async {
      when(service.connect(any)).thenThrow(Exception('connection refused'));

      await expectLater(repo.connect(config: 'cfg'), throwsA(isA<VpnConnectException>()));
    });
  });

  group('disconnect / status', () {
    test('disconnect short-circuits when not connected', () async {
      when(service.getVPNStatus()).thenAnswer((_) async => ConnectionStatus.disconnected);

      final result = await repo.disconnect();

      expect(result, isFalse);
      verifyNever(service.disconnect());
    });

    test('disconnect calls service.disconnect when connected', () async {
      when(service.getVPNStatus()).thenAnswer((_) async => ConnectionStatus.connected);

      final result = await repo.disconnect();

      expect(result, isTrue);
      verify(service.disconnect()).called(1);
    });

    test('currentStatus maps ConnectionStatus → VpnConnectionStatus', () async {
      when(service.getVPNStatus()).thenAnswer((_) async => ConnectionStatus.connected);

      final status = await repo.currentStatus();

      expect(status, VpnConnectionStatus.connected);
    });

    test('isTunnelConfigured delegates to service', () async {
      when(service.checkTunnelConfiguration()).thenAnswer((_) async => true);
      expect(await repo.isTunnelConfigured(), isTrue);
    });

    test('removeTunnelConfiguration delegates and rethrows on error', () async {
      when(service.removeTunnelConfiguration()).thenAnswer((_) async {});
      await repo.removeTunnelConfiguration();

      when(service.removeTunnelConfiguration()).thenThrow(Exception('fail'));
      await expectLater(repo.removeTunnelConfiguration(), throwsA(isA<Exception>()));
    });
  });

  group('fetchVpnConfig', () {
    test('rethrows API errors', () async {
      when(api.fetchOpenVpnConfig(request: anyNamed('request'))).thenThrow(Exception('api'));

      await expectLater(
        repo.fetchVpnConfig(
          countryOriginate: null,
          country: null,
          city: null,
          ipType: null,
          userIntent: null,
          cluster: null,
          resetConnection: null,
          dnsAddress: '1.1.1.1',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('BaseVpnRepository methods (inherited)', () {
    test('rateConnection forwards to apiService', () async {
      when(api.rateConnection(request: anyNamed('request'))).thenAnswer((_) async {});

      await repo.rateConnection(
        ipType: 'residential',
        country: 'US',
        feedback: 'great',
        reasons: 'fast',
        mode: RateConnectionRequestModeEnum.like,
      );

      verify(api.rateConnection(request: anyNamed('request'))).called(1);
    });

    test('rateConnection logs and rethrows on failure', () async {
      when(api.rateConnection(request: anyNamed('request'))).thenThrow(Exception('boom'));

      await expectLater(
        repo.rateConnection(
          ipType: 'residential',
          country: 'US',
          feedback: null,
          reasons: null,
          mode: RateConnectionRequestModeEnum.dislike,
        ),
        throwsA(isA<Exception>()),
      );
      verify(logger.handle(any)).called(1);
    });

    test('notifyApiVpnDisconnected swallows errors', () async {
      when(api.disconnect()).thenThrow(Exception('boom'));

      await expectLater(repo.notifyApiVpnDisconnected(), completes);
      verify(logger.handle(any)).called(1);
    });

    test('disconnectAllDevices delegates to apiService and rethrows on failure', () async {
      when(api.disconnectAllDevices()).thenAnswer((_) async {});
      await repo.disconnectAllDevices();
      verify(api.disconnectAllDevices()).called(1);

      when(api.disconnectAllDevices()).thenThrow(Exception('boom'));
      await expectLater(repo.disconnectAllDevices(), throwsA(isA<Exception>()));
    });

    test('udpBlockedCheck logs success info and rethrows on error', () async {
      when(api.udpBlockedCheck()).thenAnswer((_) async {});
      await repo.udpBlockedCheck();
      verify(logger.info(any)).called(1);

      when(api.udpBlockedCheck()).thenThrow(Exception('boom'));
      await expectLater(repo.udpBlockedCheck(), throwsA(isA<Exception>()));
    });
  });

  group('tunnelStatistics', () {
    test('maps the plugin counters onto TunnelStats', () async {
      when(
        service.tunnelStatistics(),
      ).thenAnswer((_) async => const VPNStatistics(totalDownload: 54321, totalUpload: 12345));

      final stats = await repo.tunnelStatistics();

      expect(stats!.totalDownload, 54321);
      expect(stats.totalUpload, 12345);
      // OpenVPN has no handshake.
      expect(stats.latestHandshake, isNull);
    });

    test('returns null when the plugin has nothing to report', () async {
      when(service.tunnelStatistics()).thenAnswer((_) async => null);

      expect(await repo.tunnelStatistics(), isNull);
    });

    test('rethrows MissingPluginException so the caller can stop polling', () async {
      when(service.tunnelStatistics()).thenThrow(MissingPluginException());

      expect(repo.tunnelStatistics(), throwsA(isA<MissingPluginException>()));
    });

    test('returns null on a plugin failure', () async {
      when(service.tunnelStatistics()).thenThrow(Exception('boom'));

      expect(await repo.tunnelStatistics(), isNull);
    });
  });
}
