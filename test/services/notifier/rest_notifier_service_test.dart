import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/models.dart' hide Response;
import 'package:mysterium_vpn/services/services.dart' hide Response;
import 'package:talker/talker.dart';

import 'rest_notifier_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late MockDio dio;
  late RestNotifierService service;

  setUp(() {
    dio = MockDio();
    service = RestNotifierService(dio: dio, logger: Talker());
  });

  Response<Object?> ok([int status = 200]) => Response<Object?>(
    requestOptions: RequestOptions(path: '/'),
    statusCode: status,
  );

  DioException badResponse(int status) => DioException(
    requestOptions: RequestOptions(path: '/'),
    type: DioExceptionType.badResponse,
    response: Response<Object?>(
      requestOptions: RequestOptions(path: '/'),
      statusCode: status,
      data: {'error': 'nope'},
    ),
  );

  DioException ofType(DioExceptionType type) => DioException(
    requestOptions: RequestOptions(path: '/'),
    type: type,
  );

  group('registerDevice', () {
    test('posts exactly externalUserId, token and platform', () async {
      when(dio.post<Object?>(any, data: anyNamed('data'))).thenAnswer((_) async => ok());

      await service.registerDevice(
        externalUserId: 'user-1',
        token: 'fcm-token',
        platform: NotifierPlatform.android,
      );

      final captured = verify(
        dio.post<Object?>(captureAny, data: captureAnyNamed('data')),
      ).captured;
      expect(captured[0], '/public/devices');
      expect(captured[1], {
        'externalUserId': 'user-1',
        'token': 'fcm-token',
        'platform': 'android',
      });
    });

    test('sends the platform name the API expects for iOS', () async {
      when(dio.post<Object?>(any, data: anyNamed('data'))).thenAnswer((_) async => ok());

      await service.registerDevice(externalUserId: 'u', token: 't', platform: NotifierPlatform.ios);

      final data = verify(dio.post<Object?>(any, data: captureAnyNamed('data'))).captured.single;
      expect((data as Map)['platform'], 'ios');
    });

    test('every platform serializes to a value the API accepts', () async {
      when(dio.post<Object?>(any, data: anyNamed('data'))).thenAnswer((_) async => ok());
      const accepted = {'ios', 'android', 'windows', 'web'};

      for (final platform in NotifierPlatform.values) {
        await service.registerDevice(externalUserId: 'u', token: 't', platform: platform);
      }

      final sent = verify(dio.post<Object?>(any, data: captureAnyNamed('data'))).captured;
      expect(sent, hasLength(NotifierPlatform.values.length));
      for (final data in sent) {
        expect(accepted, contains((data as Map)['platform']));
      }
    });

    test('registers macOS as ios, because the API has no macos value', () async {
      when(dio.post<Object?>(any, data: anyNamed('data'))).thenAnswer((_) async => ok());

      await service.registerDevice(
        externalUserId: 'u',
        token: 't',
        platform: NotifierPlatform.macos,
      );

      final data = verify(dio.post<Object?>(any, data: captureAnyNamed('data'))).captured.single;
      expect((data as Map)['platform'], 'ios');
    });

    test('401 surfaces an unauthorized failure carrying the status', () async {
      when(dio.post<Object?>(any, data: anyNamed('data'))).thenThrow(badResponse(401));

      await expectLater(
        service.registerDevice(externalUserId: 'u', token: 't', platform: NotifierPlatform.android),
        throwsA(
          isA<NotifierException>()
              .having((e) => e.category, 'category', 'unauthorized')
              .having((e) => e.statusCode, 'statusCode', 401),
        ),
      );
    });

    test('400 surfaces a badRequest failure', () async {
      when(dio.post<Object?>(any, data: anyNamed('data'))).thenThrow(badResponse(400));

      await expectLater(
        service.registerDevice(externalUserId: 'u', token: 't', platform: NotifierPlatform.android),
        throwsA(isA<NotifierException>().having((e) => e.category, 'category', 'bad_request')),
      );
    });

    test('500 surfaces a server failure', () async {
      when(dio.post<Object?>(any, data: anyNamed('data'))).thenThrow(badResponse(503));

      await expectLater(
        service.registerDevice(externalUserId: 'u', token: 't', platform: NotifierPlatform.android),
        throwsA(isA<NotifierException>().having((e) => e.category, 'category', 'server')),
      );
    });

    test('a timeout surfaces a timeout failure with no status', () async {
      when(
        dio.post<Object?>(any, data: anyNamed('data')),
      ).thenThrow(ofType(DioExceptionType.receiveTimeout));

      await expectLater(
        service.registerDevice(externalUserId: 'u', token: 't', platform: NotifierPlatform.android),
        throwsA(
          isA<NotifierException>()
              .having((e) => e.category, 'category', 'timeout')
              .having((e) => e.statusCode, 'statusCode', isNull),
        ),
      );
    });

    test('a connection error surfaces a network failure', () async {
      when(
        dio.post<Object?>(any, data: anyNamed('data')),
      ).thenThrow(ofType(DioExceptionType.connectionError));

      await expectLater(
        service.registerDevice(externalUserId: 'u', token: 't', platform: NotifierPlatform.android),
        throwsA(isA<NotifierException>().having((e) => e.category, 'category', 'network')),
      );
    });

    test('a non-Dio error surfaces an unknown failure rather than escaping', () async {
      when(dio.post<Object?>(any, data: anyNamed('data'))).thenThrow(StateError('boom'));

      await expectLater(
        service.registerDevice(externalUserId: 'u', token: 't', platform: NotifierPlatform.android),
        throwsA(isA<NotifierException>().having((e) => e.category, 'category', 'unknown')),
      );
    });
  });

  group('mergeAttributes', () {
    test('puts to the user path with the attributes wrapper', () async {
      when(dio.put<Object?>(any, data: anyNamed('data'))).thenAnswer((_) async => ok());

      await service.mergeAttributes(
        externalUserId: 'user-1',
        attributes: {'country': 'US', 'subscription_active': true},
      );

      final captured = verify(dio.put<Object?>(captureAny, data: captureAnyNamed('data'))).captured;
      expect(captured[0], '/public/users/user-1/attributes');
      expect(captured[1], {
        'attributes': {'country': 'US', 'subscription_active': true},
      });
    });

    test('URL-encodes an external id containing path-unsafe characters', () async {
      when(dio.put<Object?>(any, data: anyNamed('data'))).thenAnswer((_) async => ok());

      await service.mergeAttributes(externalUserId: 'a/b c', attributes: const {});

      final path = verify(dio.put<Object?>(captureAny, data: anyNamed('data'))).captured.single;
      expect(path, '/public/users/a%2Fb%20c/attributes');
    });

    test('404 surfaces a notFound failure', () async {
      when(dio.put<Object?>(any, data: anyNamed('data'))).thenThrow(badResponse(404));

      await expectLater(
        service.mergeAttributes(externalUserId: 'u', attributes: const {}),
        throwsA(isA<NotifierException>().having((e) => e.category, 'category', 'not_found')),
      );
    });
  });

  group('recordEvent', () {
    test('omits campaignId and journeyStepId when null', () async {
      when(dio.post<Object?>(any, data: anyNamed('data'))).thenAnswer((_) async => ok(201));

      await service.recordEvent(token: 'fcm-token', type: NotifierEventType.delivered);

      final captured = verify(
        dio.post<Object?>(captureAny, data: captureAnyNamed('data')),
      ).captured;
      expect(captured[0], '/public/events');
      expect(captured[1], {'token': 'fcm-token', 'type': 'delivered'});
    });

    test('includes campaignId and journeyStepId when present', () async {
      when(dio.post<Object?>(any, data: anyNamed('data'))).thenAnswer((_) async => ok(201));

      await service.recordEvent(
        token: 'fcm-token',
        type: NotifierEventType.open,
        campaignId: 'campaign-1',
        journeyStepId: 'step-1',
      );

      final data = verify(dio.post<Object?>(any, data: captureAnyNamed('data'))).captured.single;
      expect(data, {
        'token': 'fcm-token',
        'type': 'open',
        'campaignId': 'campaign-1',
        'journeyStepId': 'step-1',
      });
    });
  });
}
