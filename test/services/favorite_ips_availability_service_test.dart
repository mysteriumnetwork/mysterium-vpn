import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/services/services.dart' hide Response;

import 'favorite_ips_availability_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  group('parseIpsAvailability', () {
    const requested = ['1.1.1.1', '2.2.2.2'];

    test('parses a map of ip to bool under an "ips" key', () {
      final result = parseIpsAvailability({
        'ips': {'1.1.1.1': true, '2.2.2.2': false},
      }, requested);

      expect(result, {'1.1.1.1': true, '2.2.2.2': false});
    });

    test('parses a top-level map of ip to bool', () {
      final result = parseIpsAvailability({'1.1.1.1': false, '2.2.2.2': true}, requested);

      expect(result, {'1.1.1.1': false, '2.2.2.2': true});
    });

    test('a list of ips is treated as the available set', () {
      final result = parseIpsAvailability({
        'ips': ['1.1.1.1'],
      }, requested);

      expect(result, {'1.1.1.1': true, '2.2.2.2': false});
    });

    test('parses a list of ip/available objects', () {
      final result = parseIpsAvailability({
        'ips': [
          {'ip': '1.1.1.1', 'available': false},
          {'ip': '2.2.2.2', 'available': true},
        ],
      }, requested);

      expect(result, {'1.1.1.1': false, '2.2.2.2': true});
    });

    test('unrecognized body treats every requested ip as available', () {
      expect(parseIpsAvailability('garbage', requested), {'1.1.1.1': true, '2.2.2.2': true});
      expect(parseIpsAvailability(null, requested), {'1.1.1.1': true, '2.2.2.2': true});
    });
  });

  group('RestFavoriteIpsAvailabilityService', () {
    test('posts the ips and returns the parsed availability', () async {
      final dio = MockDio();
      when(dio.post<Object>(any, data: anyNamed('data'))).thenAnswer(
        (_) async => Response<Object>(
          requestOptions: RequestOptions(path: '/connection/ips-availability'),
          statusCode: 200,
          data: {
            'ips': {'1.1.1.1': true},
          },
        ),
      );

      final service = RestFavoriteIpsAvailabilityService(dio);
      final result = await service.checkAvailability(['1.1.1.1']);

      expect(result, {'1.1.1.1': true});
      final captured = verify(
        dio.post<Object>('/connection/ips-availability', data: captureAnyNamed('data')),
      ).captured.single;
      expect(captured, {
        'ips': ['1.1.1.1'],
      });
    });
  });
}
