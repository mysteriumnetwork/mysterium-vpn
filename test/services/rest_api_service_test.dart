import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/services/api/rest_api_service.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

import 'rest_api_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<VpnApi>(),
  MockSpec<Connection>(),
  MockSpec<EmailMarketing>(),
  MockSpec<Talker>(),
])
void main() {
  late MockVpnApi api;
  late MockConnection connection;
  late MockEmailMarketing email;
  late MockTalker logger;
  late RestApiService service;

  setUp(() {
    api = MockVpnApi();
    connection = MockConnection();
    email = MockEmailMarketing();
    logger = MockTalker();

    when(api.getConnection()).thenReturn(connection);
    when(api.getEmailMarketing()).thenReturn(email);

    service = RestApiService(api: api, logger: logger);
  });

  Response<T> response<T>(int code, T data) =>
      Response<T>(requestOptions: RequestOptions(), statusCode: code, data: data);

  WireguardConnectRequest wgRequest() =>
      WireguardConnectRequest(publicKey: 'pub', country: 'US', city: 'NYC');

  group('fetchVpnConfig', () {
    test('returns response data on success', () async {
      final wgResponse = WireguardConnectResponse(id: 'i', wgConfig: 'cfg', hash: 'h');
      when(
        connection.connect(wireguardConnectRequest: anyNamed('wireguardConnectRequest')),
      ).thenAnswer((_) async => response(200, wgResponse));

      final result = await service.fetchVpnConfig(request: wgRequest());

      expect(result, wgResponse);
    });
  });

  group('disconnect / disconnectAllDevices', () {
    test('disconnect delegates and logs', () async {
      when(connection.disconnect()).thenAnswer((_) async => response(200, null));
      await service.disconnect();
      verify(connection.disconnect()).called(1);
    });

    test('disconnect logs and rethrows on failure', () async {
      when(connection.disconnect()).thenThrow(Exception('boom'));
      await expectLater(service.disconnect(), throwsA(isA<Exception>()));
      verify(logger.handle(any, any)).called(1);
    });

    test('disconnectAllDevices delegates and logs', () async {
      when(connection.disconnectAll()).thenAnswer((_) async => response(200, null));
      await service.disconnectAllDevices();
      verify(connection.disconnectAll()).called(1);
    });

    test('disconnectAllDevices rethrows on failure', () async {
      when(connection.disconnectAll()).thenThrow(Exception('boom'));
      await expectLater(service.disconnectAllDevices(), throwsA(isA<Exception>()));
    });
  });

  group('rateConnection', () {
    test('delegates to Connection.rateConnection', () async {
      when(
        connection.rateConnection(rateConnectionRequest: anyNamed('rateConnectionRequest')),
      ).thenAnswer((_) async => response(200, null));

      await service.rateConnection(
        request: RateConnectionRequest(
          mode: RateConnectionRequestModeEnum.like,
          country: 'US',
          ipType: 'residential',
        ),
      );

      verify(
        connection.rateConnection(rateConnectionRequest: anyNamed('rateConnectionRequest')),
      ).called(1);
    });

    test('rethrows on failure', () async {
      when(
        connection.rateConnection(rateConnectionRequest: anyNamed('rateConnectionRequest')),
      ).thenThrow(Exception('boom'));

      await expectLater(
        service.rateConnection(
          request: RateConnectionRequest(
            mode: RateConnectionRequestModeEnum.dislike,
            country: 'US',
            ipType: 'residential',
          ),
        ),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('marketing contact', () {
    test('createMarketingContact delegates with country', () async {
      when(
        email.createContactRequest(createContactRequest: anyNamed('createContactRequest')),
      ).thenAnswer((_) async => response(200, null));

      await service.createMarketingContact(country: 'US');

      verify(
        email.createContactRequest(createContactRequest: anyNamed('createContactRequest')),
      ).called(1);
    });

    test('getMarketingContactStatus returns false when consent is null', () async {
      when(
        email.contactStatusRequest(),
      ).thenAnswer((_) async => response(200, ContactStatusResponse(status: 'ok')));

      expect(await service.getMarketingContactStatus(), isFalse);
    });

    test('getMarketingContactStatus returns the consent flag', () async {
      when(
        email.contactStatusRequest(),
      ).thenAnswer((_) async => response(200, ContactStatusResponse(status: 'ok', consent: true)));

      expect(await service.getMarketingContactStatus(), isTrue);
    });

    test('updateMarketingContact delegates with consent flag', () async {
      when(
        email.updateContactRequest(updateContactRequest: anyNamed('updateContactRequest')),
      ).thenAnswer((_) async => response(200, null));

      await service.updateMarketingContact(consent: true);

      verify(
        email.updateContactRequest(updateContactRequest: anyNamed('updateContactRequest')),
      ).called(1);
    });
  });

  group('fetchUserIntents', () {
    test('returns parsed UserIntent set, filtering out unknown values', () async {
      when(
        connection.userIntents(),
      ).thenAnswer((_) async => response(200, ['streaming', 'mystery_value']));

      final intents = await service.fetchUserIntents();

      expect(intents.length, 1);
    });
  });

  group('fetchOpenVpnConfig', () {
    test('returns response data on success', () async {
      final ovpn = OpenVpnConnectResponse(id: 'i', ovpnConfig: 'c', hash: 'h');
      when(
        connection.connectOpenvpn(openVpnConnectRequest: anyNamed('openVpnConnectRequest')),
      ).thenAnswer((_) async => response(200, ovpn));

      final result = await service.fetchOpenVpnConfig(
        request: OpenVpnConnectRequest(osType: 'macos'),
      );

      expect(result, ovpn);
    });
  });
}
