import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/models.dart' hide Response;
import 'package:mysterium_vpn/repositories/repositories.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

import 'rest_locations_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Connection>(),
  MockSpec<LocalDBService>(),
  MockSpec<Talker>(unsupportedMembers: {#configure}),
  MockSpec<AuthSessionGateway>(),
])
void main() {
  late MockConnection connection;
  late MockLocalDBService db;
  late MockTalker logger;
  late MockAuthSessionGateway session;

  RestLocationsRepository build() =>
      RestLocationsRepository(connection: connection, db: db, logger: logger, session: session);

  ConnectionLocation country(String code) => ConnectionLocation(
    country: code,
    total: 3,
    translations: const {'en': 'Name'},
    cities: const [],
  );

  Response<List<ConnectionLocation>> ok(List<ConnectionLocation> data) =>
      Response<List<ConnectionLocation>>(
        requestOptions: RequestOptions(),
        statusCode: 200,
        data: data,
      );

  setUp(() {
    connection = MockConnection();
    db = MockLocalDBService();
    logger = MockTalker();
    session = MockAuthSessionGateway();
    when(session.isAuthenticated).thenReturn(true);
    when(db.setLocations(any, type: anyNamed('type'))).thenAnswer((_) async {});
  });

  group('fetch', () {
    test('maps the API response to VPNLocations and caches it', () async {
      when(
        connection.connectionLocations(ipType: IPType.datacenter.key),
      ).thenAnswer((_) async => ok([country('US'), country('DE')]));

      final result = await build().fetch(IPType.datacenter);

      expect(result.locations.map((it) => it.id), ['US', 'DE']);
      expect(result.locations.every((it) => it.ipType == IPType.datacenter), isTrue);
      verify(db.setLocations(any, type: IPType.datacenter)).called(1);
    });

    test('sends no ipType filter for IPType.closest', () async {
      when(connection.connectionLocations()).thenAnswer((_) async => ok([country('US')]));

      await build().fetch(IPType.closest);

      verify(connection.connectionLocations()).called(1);
    });

    test('throws and leaves the cache untouched when the payload is null', () async {
      when(connection.connectionLocations(ipType: anyNamed('ipType'))).thenAnswer(
        (_) async =>
            Response<List<ConnectionLocation>>(requestOptions: RequestOptions(), statusCode: 200),
      );

      await expectLater(build().fetch(IPType.datacenter), throwsA(isA<Exception>()));
      verifyNever(db.setLocations(any, type: anyNamed('type')));
    });

    test('rethrows an ApiException without logging it as a failure', () async {
      when(connection.connectionLocations(ipType: anyNamed('ipType'))).thenThrow(
        ApiException(
          RequestOptions(),
          'boom',
          code: 500,
          identifier: 'identifier',
          endpoint: '/connection/locations',
          severity: ExceptionSeverity.low,
        ),
      );

      await expectLater(build().fetch(IPType.datacenter), throwsA(isA<ApiException>()));
      verifyNever(logger.handle(any));
      verifyNever(db.setLocations(any, type: anyNamed('type')));
    });

    group('unauthenticated responses are not cached', () {
      test('when signed out before the request', () async {
        when(session.isAuthenticated).thenReturn(false);
        when(
          connection.connectionLocations(ipType: anyNamed('ipType')),
        ).thenAnswer((_) async => ok([country('US')]));

        final result = await build().fetch(IPType.datacenter);

        expect(result.locations, isNotEmpty, reason: 'caller still gets the data');
        verifyNever(db.setLocations(any, type: anyNamed('type')));
      });

      test('when a logout races a request already in flight', () async {
        // Authenticated when the request starts, signed out by the time it
        // lands — the post-request check is what catches this.
        var calls = 0;
        when(session.isAuthenticated).thenAnswer((_) => calls++ == 0);
        when(
          connection.connectionLocations(ipType: anyNamed('ipType')),
        ).thenAnswer((_) async => ok([country('US')]));

        await build().fetch(IPType.datacenter);

        verifyNever(db.setLocations(any, type: anyNamed('type')));
      });
    });
  });

  group('watch', () {
    test('emits the cached value first, then live updates', () async {
      // Only a non-empty cache is emitted synchronously.
      final cached = VPNLocations(locations: [Mocks.locationDatacenterUS]);
      when(db.getLocations(IPType.datacenter)).thenAnswer((_) async => cached);
      when(
        db.watchLocations(IPType.datacenter),
      ).thenAnswer((_) => Stream<VPNLocations?>.fromIterable([VPNLocations()]));

      final emitted = await build().watch(IPType.datacenter).take(2).toList();

      expect(emitted, hasLength(2));
    });

    test('skips the synchronous emit when the cache is empty', () async {
      when(db.getLocations(IPType.datacenter)).thenAnswer((_) async => null);
      when(
        db.watchLocations(IPType.datacenter),
      ).thenAnswer((_) => const Stream<VPNLocations?>.empty());

      expect(await build().watch(IPType.datacenter).toList(), isEmpty);
    });
  });

  test('clear empties both IP types', () async {
    await build().clear();

    verify(db.setLocations(any, type: IPType.residential)).called(1);
    verify(db.setLocations(any, type: IPType.datacenter)).called(1);
  });
}
