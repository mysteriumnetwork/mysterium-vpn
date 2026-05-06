import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/models/response.dart';
import 'package:mysterium_vpn/services/services.dart' hide Response;
import 'package:talker/talker.dart';

import 'rest_external_api_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NetworkService>(), MockSpec<Talker>()])
void main() {
  late MockNetworkService network;
  late MockTalker logger;
  late RestExternalApiService service;

  setUp(() {
    network = MockNetworkService();
    logger = MockTalker();
    service = RestExternalApiService(network, logger);
  });

  Response response(int code, Object? data) => Response(statusCode: code, data: data ?? const {});

  group('getIPInfo', () {
    test('returns parsed IPInfo from primary endpoint on 200', () async {
      when(
        network.fetch(any),
      ).thenAnswer((_) async => response(200, {'ip': '1.2.3.4', 'country': 'US', 'city': 'NYC'}));

      final info = await service.getIPInfo();

      expect(info, isNotNull);
      expect(info!.country, 'US');
      verify(network.fetch(kFetchIP)).called(1);
    });

    test('falls back to secondary endpoint when primary fails', () async {
      when(network.fetch(kFetchIP)).thenThrow(Exception('boom'));
      when(network.fetch(kFetchIPFallback)).thenAnswer(
        (_) async => response(200, {'ip': '5.6.7.8', 'country': 'DE', 'city': 'Berlin'}),
      );

      final info = await service.getIPInfo();

      expect(info!.country, 'DE');
      verify(network.fetch(kFetchIPFallback)).called(1);
    });

    test('returns null when both endpoints fail', () async {
      when(network.fetch(any)).thenThrow(Exception('boom'));

      final info = await service.getIPInfo();

      expect(info, isNull);
    });

    test('returns null when status code is not 200', () async {
      when(network.fetch(any)).thenAnswer((_) async => response(500, null));

      final info = await service.getIPInfo();

      expect(info, isNull);
    });
  });

  group('getIPAddress', () {
    test('returns the body string on success', () async {
      when(network.fetch(kFetchIPAddress)).thenAnswer((_) async => response(200, '9.9.9.9'));

      expect(await service.getIPAddress(), '9.9.9.9');
    });

    test('returns null on non-200 status', () async {
      when(network.fetch(kFetchIPAddress)).thenAnswer((_) async => response(404, null));

      expect(await service.getIPAddress(), isNull);
    });

    test('returns null when fetch throws', () async {
      when(network.fetch(kFetchIPAddress)).thenThrow(Exception('network'));

      expect(await service.getIPAddress(), isNull);
    });
  });
}
