import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/models/models.dart' hide Response;
import 'package:mysterium_vpn/repositories/repositories.dart';
import 'package:mysterium_vpn/services/data/storage.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

import 'rest_auth_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<VpnApi>(),
  MockSpec<Authentication>(),
  MockSpec<NetworkService>(),
  MockSpec<AuthSessionGateway>(),
  MockSpec<SecureStorageService>(),
  MockSpec<LocalDBService>(),
])
void main() {
  late MockVpnApi api;
  late MockAuthentication auth;

  setUp(() {
    api = MockVpnApi();
    auth = MockAuthentication();
    when(api.getAuthentication()).thenReturn(auth);
  });

  RestAuthRepository build({Future<Uri> Function(Uri)? resolveWebUrl}) => RestAuthRepository(
    api: api,
    networkService: MockNetworkService(),
    authSession: MockAuthSessionGateway(),
    logger: Talker(settings: TalkerSettings(useConsoleLogs: false)),
    securedStorage: MockSecureStorageService(),
    localDb: MockLocalDBService(),
    resolveWebUrl: resolveWebUrl,
  );

  Response<MagicLinkResponse> ok(String code) => Response<MagicLinkResponse>(
    requestOptions: RequestOptions(),
    statusCode: 200,
    data: MagicLinkResponse(code: code),
  );

  ApiException rejected(int status) => ApiException(
    RequestOptions(),
    'rejected',
    code: status,
    identifier: 'magic_link',
    endpoint: '/magic-link',
    severity: ExceptionSeverity.medium,
    response: Response<Object?>(requestOptions: RequestOptions(), statusCode: status),
  );

  List<String?> sentOrigins() =>
      verify(auth.requestMagicLink(magicLinkRequest: captureAnyNamed('magicLinkRequest'))).captured
          .map((request) => (request as MagicLinkRequest).preferredOrigin)
          .toList();

  final pkce = PkcePair.generate();

  test('sends the resolved origin when discovery moved the web app', () async {
    final fallback = Uri.https('unblocked-app.mysteriumvpn.com');
    when(auth.requestMagicLink(magicLinkRequest: anyNamed('magicLinkRequest')))
        .thenAnswer((_) async => ok('code'));

    final code = await build(resolveWebUrl: (_) async => fallback)
        .signInWithEmail(email: 'user@example.com', pkcePair: pkce);

    expect(code, 'code');
    expect(sentOrigins(), [fallback.origin]);
  });

  test('omits the origin when it is the one the backend already defaults to', () async {
    when(auth.requestMagicLink(magicLinkRequest: anyNamed('magicLinkRequest')))
        .thenAnswer((_) async => ok('code'));

    await build(resolveWebUrl: (_) async => Env.webAppUri)
        .signInWithEmail(email: 'user@example.com', pkcePair: pkce);

    // A user who is not blocked must send exactly what they sent before.
    expect(sentOrigins(), [null]);
  });

  test('omits the origin when no resolver is wired', () async {
    when(auth.requestMagicLink(magicLinkRequest: anyNamed('magicLinkRequest')))
        .thenAnswer((_) async => ok('code'));

    await build().signInWithEmail(email: 'user@example.com', pkcePair: pkce);

    expect(sentOrigins(), [null]);
  });

  test('retries without the origin when the backend will not accept it', () async {
    for (final status in [400, 422]) {
      api = MockVpnApi();
      auth = MockAuthentication();
      when(api.getAuthentication()).thenReturn(auth);
      var attempt = 0;
      when(auth.requestMagicLink(magicLinkRequest: anyNamed('magicLinkRequest')))
          .thenAnswer((_) async {
            attempt++;
            if (attempt == 1) {
              throw rejected(status);
            }
            return ok('code');
          });

      final code = await build(
        resolveWebUrl: (_) async => Uri.https('unblocked-app.mysteriumvpn.com'),
      ).signInWithEmail(email: 'user@example.com', pkcePair: pkce);

      // A link to the default domain beats no link at all.
      expect(code, 'code', reason: 'status $status should have been retried');
      expect(sentOrigins(), ['https://unblocked-app.mysteriumvpn.com', null]);
    }
  });

  test('a rejection that is not about the origin is not retried', () async {
    when(auth.requestMagicLink(magicLinkRequest: anyNamed('magicLinkRequest')))
        .thenThrow(rejected(500));

    await expectLater(
      build(resolveWebUrl: (_) async => Uri.https('unblocked-app.mysteriumvpn.com'))
          .signInWithEmail(email: 'user@example.com', pkcePair: pkce),
      throwsA(isA<ApiException>()),
    );
    expect(sentOrigins().length, 1);
  });

  test('a failing resolver still sends the request', () async {
    when(auth.requestMagicLink(magicLinkRequest: anyNamed('magicLinkRequest')))
        .thenAnswer((_) async => ok('code'));

    final code = await build(resolveWebUrl: (_) async => throw Exception('offline'))
        .signInWithEmail(email: 'user@example.com', pkcePair: pkce);

    expect(code, 'code');
    expect(sentOrigins(), [null]);
  });
}
