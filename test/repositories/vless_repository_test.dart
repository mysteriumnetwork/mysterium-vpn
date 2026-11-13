import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/repositories/vpn/vless_repository.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:talker/talker.dart';
import 'package:vless_dart/vless_dart.dart';
import 'package:vless_dart/vpn_statistics.dart';
import 'package:vless_dart/vpn_status.dart';
import 'package:vpn_api/vpn_api.dart';

import 'vless_repository_test.mocks.dart';

const _vlessUri =
    'vless://f7422437-7044-4599-8165-5f7ae7311fc4@supervpn-testnet-01.mysterium.network:443'
    '?encryption=none&path=%2Fvless&security=tls&type=ws#Mysterium%20VLESS';

VlessConnectResponse _response() => VlessConnectResponse(
  id: 'dbd27c12280b05845f4dbfe4d44f54b7',
  vlessUri: _vlessUri,
  hash: '686f5d222b713faff520157b7d8a248771c61ba411405ad94b665a5467b31f2e',
  sessionId: '32a637cd-8b3c-42c3-9bdd-0e0f2473ed01',
  exitIp: '152.44.56.95',
  ipType: 'residential',
  country: 'US',
  city: 'georgia',
);

@GenerateNiceMocks([MockSpec<VlessDart>(), MockSpec<ApiService>(), MockSpec<Talker>()])
void main() {
  late MockVlessDart service;
  late MockApiService api;
  late MockTalker logger;
  late VlessRepository repo;

  setUp(() {
    service = MockVlessDart();
    api = MockApiService();
    logger = MockTalker();
    repo = VlessRepository(service: service, apiService: api, logger: logger);
  });

  group('fetchVpnConfig', () {
    test('maps the response onto VpnConfig, carrying the raw URI', () async {
      when(api.fetchVlessConfig(request: anyNamed('request'))).thenAnswer((_) async => _response());

      final config = await repo.fetchVpnConfig(
        countryOriginate: null,
        country: 'US',
        city: 'georgia',
        ipType: 'residential',
        userIntent: null,
        cluster: null,
        resetConnection: false,
        dnsAddress: '1.1.1.1',
      );

      expect(config.config, _vlessUri);
      expect(config.type, 'vless');
      expect(config.id, 'dbd27c12280b05845f4dbfe4d44f54b7');
      expect(config.exitIp, '152.44.56.95');
      expect(config.ipType, 'residential');
    });

    test('forwards the request fields the API expects', () async {
      when(api.fetchVlessConfig(request: anyNamed('request'))).thenAnswer((_) async => _response());

      await repo.fetchVpnConfig(
        countryOriginate: 'DE',
        country: 'US',
        city: 'georgia',
        ipType: 'residential',
        userIntent: 'streaming',
        cluster: 'eu',
        resetConnection: true,
        dnsAddress: '9.9.9.9',
        targetIp: '152.44.56.95',
      );

      final request =
          verify(api.fetchVlessConfig(request: captureAnyNamed('request'))).captured.single
              as VlessConnectRequest;
      expect(request.countryOriginate, 'DE');
      expect(request.country, 'US');
      expect(request.city, 'georgia');
      expect(request.ipType, 'residential');
      expect(request.userIntent, 'streaming');
      expect(request.cluster, 'eu');
      expect(request.resetConnection, true);
      expect(request.dns, '9.9.9.9');
      expect(request.targetIp, '152.44.56.95');
      expect(request.osType, Platform.operatingSystem);
    });

    test('rethrows API failures', () async {
      when(api.fetchVlessConfig(request: anyNamed('request'))).thenThrow(Exception('boom'));

      await expectLater(
        repo.fetchVpnConfig(
          countryOriginate: null,
          country: null,
          city: null,
          ipType: null,
          userIntent: null,
          cluster: null,
          resetConnection: false,
          dnsAddress: '1.1.1.1',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('init / setupTunnel', () {
    test('init delegates to VlessDart.initialize', () async {
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
    test('passes the raw vless URI straight through', () async {
      when(service.connect(any)).thenAnswer((_) async {});

      await repo.connect(config: _vlessUri);

      verify(service.connect(_vlessUri)).called(1);
    });

    test('carries the selected resolver into the plugin', () async {
      // The vless:// URI has no DNS field and the response carries none, so
      // this is the only path by which the content blockers reach the tunnel.
      await repo.connect(config: _vlessUri, dnsAddress: '1.1.1.3');

      verify(service.connect(_vlessUri, dnsAddress: '1.1.1.3')).called(1);
    });

    test('leaves the plugin on its defaults when no resolver is selected', () async {
      await repo.connect(config: _vlessUri);

      verify(service.connect(_vlessUri)).called(1);
    });

    test('wraps non-timeout errors in VpnConnectException', () async {
      when(service.connect(any)).thenThrow(Exception('handshake failed'));

      await expectLater(repo.connect(config: _vlessUri), throwsA(isA<VpnConnectException>()));
    });
  });

  group('disconnect / status', () {
    test('disconnect short-circuits when not connected', () async {
      when(service.getVPNStatus()).thenAnswer((_) async => ConnectionStatus.disconnected);

      expect(await repo.disconnect(), isFalse);
      verifyNever(service.disconnect());
    });

    test('disconnect stops a tunnel that is still connecting', () async {
      // A protocol switch or a revoked subscription tears down mid-connect; the
      // native profile keeps starting unless the stop reaches it.
      when(service.getVPNStatus()).thenAnswer((_) async => ConnectionStatus.connecting);

      expect(await repo.disconnect(), isTrue);
      verify(service.disconnect()).called(1);
    });

    test('disconnect stops a connect the platform has not acknowledged yet', () async {
      // The plugin spends the start of every connect saving preferences, and
      // reports `disconnected` throughout; only it can cancel that.
      final started = Completer<void>();
      final release = Completer<void>();
      when(service.getVPNStatus()).thenAnswer((_) async => ConnectionStatus.disconnected);
      when(service.connect(any, dnsAddress: anyNamed('dnsAddress'))).thenAnswer((_) {
        started.complete();
        return release.future;
      });

      final connecting = repo.connect(config: _vlessUri);
      await started.future;

      expect(await repo.disconnect(), isTrue);
      verify(service.disconnect()).called(1);

      release.completeError(Exception('Failed to connect VPN: Connect cancelled'));
      await expectLater(connecting, throwsA(isA<OperationCancelledException>()));
    });

    test('a connect that fails on its own is still a connection error', () async {
      // Only a teardown turns a failure into a cancellation; this one has none.
      when(service.getVPNStatus()).thenAnswer((_) async => ConnectionStatus.disconnected);
      when(service.connect(any)).thenThrow(Exception('handshake failed'));

      await expectLater(repo.connect(config: _vlessUri), throwsA(isA<VpnConnectException>()));
      expect(await repo.disconnect(), isFalse);
    });

    test('disconnect calls service.disconnect when connected', () async {
      when(service.getVPNStatus()).thenAnswer((_) async => ConnectionStatus.connected);

      expect(await repo.disconnect(), isTrue);
      verify(service.disconnect()).called(1);
    });

    test('currentStatus maps ConnectionStatus to VpnConnectionStatus', () async {
      when(service.getVPNStatus()).thenAnswer((_) async => ConnectionStatus.connected);

      expect(await repo.currentStatus(), VpnConnectionStatus.connected);
    });

    test('statusStream maps every plugin status onto the app enum', () async {
      // The two enums are declared in different repos. A name added on one side
      // and not the other falls through to `unknown`, which the UI reads as a
      // dead tunnel, so pin the whole mapping rather than one value.
      when(service.statusStream()).thenAnswer((_) => Stream.fromIterable(ConnectionStatus.values));

      expect(await repo.statusStream().toList(), <VpnConnectionStatus>[
        VpnConnectionStatus.connecting,
        VpnConnectionStatus.connected,
        VpnConnectionStatus.disconnecting,
        VpnConnectionStatus.disconnected,
        VpnConnectionStatus.unknown,
      ]);
    });

    test('isTunnelConfigured collapses concurrent calls onto one', () async {
      final check = Completer<bool>();
      when(service.checkTunnelConfiguration()).thenAnswer((_) => check.future);

      final first = repo.isTunnelConfigured();
      final second = repo.isTunnelConfigured();
      check.complete(true);

      expect(await Future.wait([first, second]), [true, true]);
      verify(service.checkTunnelConfiguration()).called(1);
    });

    test('removeTunnelConfiguration delegates and rethrows on error', () async {
      when(service.removeTunnelConfiguration()).thenAnswer((_) async {});
      await repo.removeTunnelConfiguration();

      when(service.removeTunnelConfiguration()).thenThrow(Exception('fail'));
      await expectLater(repo.removeTunnelConfiguration(), throwsA(isA<Exception>()));
    });
  });

  group('tunnelStatistics', () {
    test('maps the plugin counters onto TunnelStats', () async {
      when(service.tunnelStatistics())
          .thenAnswer((_) async => const VPNStatistics(totalDownload: 54321, totalUpload: 12345));

      final stats = await repo.tunnelStatistics();

      expect(stats!.totalDownload, 54321);
      expect(stats.totalUpload, 12345);
      // VLESS has no handshake.
      expect(stats.latestHandshake, isNull);
    });

    test('warns when the footprint nears the iOS extension limit', () async {
      when(service.tunnelStatistics()).thenAnswer(
        (_) async =>
            const VPNStatistics(totalDownload: 1, totalUpload: 1, footprintBytes: 45 * 1024 * 1024),
      );

      await repo.tunnelStatistics();

      verify(logger.warning(argThat(contains('45.0 MB')))).called(1);
    });

    test('stays quiet at a healthy footprint', () async {
      when(service.tunnelStatistics()).thenAnswer(
        (_) async =>
            const VPNStatistics(totalDownload: 1, totalUpload: 1, footprintBytes: 20 * 1024 * 1024),
      );

      await repo.tunnelStatistics();

      verifyNever(logger.warning(any));
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
