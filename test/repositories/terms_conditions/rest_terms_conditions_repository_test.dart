import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/models/terms_conditions.dart';
import 'package:mysterium_vpn/repositories/terms_conditions/rest_terms_conditions.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

import 'rest_terms_conditions_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<VpnApi>(),
  MockSpec<Authentication>(),
  MockSpec<Terms>(),
  MockSpec<Talker>(unsupportedMembers: {#configure}),
])
void main() {
  late MockVpnApi api;
  late MockAuthentication authentication;
  late MockTerms terms;
  late MockTalker logger;

  setUp(() {
    api = MockVpnApi();
    authentication = MockAuthentication();
    terms = MockTerms();
    logger = MockTalker();
    when(api.getAuthentication()).thenReturn(authentication);
    when(api.getTerms()).thenReturn(terms);
  });

  RestTermsConditionsRepository build() => RestTermsConditionsRepository(api: api, logger: logger);

  Response<T> response<T>(T? data, {int statusCode = 200}) =>
      Response<T>(requestOptions: RequestOptions(), statusCode: statusCode, data: data);

  group('checkUserAcceptedVersion', () {
    test('returns the accepted version from the auth check', () async {
      when(authentication.checkAuth()).thenAnswer(
        (_) async => response(AuthCheckResponse(username: 'user', userId: '1', termsVersion: '2')),
      );

      expect(await build().checkUserAcceptedVersion(), '2');
      verifyNever(logger.warning(any, any, any));
    });

    test('returns null when the user has not accepted a version', () async {
      when(
        authentication.checkAuth(),
      ).thenAnswer((_) async => response(AuthCheckResponse(username: 'user', userId: '1')));

      expect(await build().checkUserAcceptedVersion(), isNull);
    });

    test('returns null when the auth check has no body', () async {
      when(authentication.checkAuth()).thenAnswer((_) async => response<AuthCheckResponse>(null));

      expect(await build().checkUserAcceptedVersion(), isNull);
    });

    test('logs and rethrows when the auth check throws', () async {
      final error = Exception('offline');
      when(authentication.checkAuth()).thenThrow(error);

      await expectLater(build().checkUserAcceptedVersion(), throwsA(same(error)));
      verify(logger.warning(any, error, any)).called(1);
    });
  });

  group('getLatestVersion', () {
    test('maps the content and version', () async {
      when(terms.terms(theme: anyNamed('theme'))).thenAnswer(
        (_) async => response(NewscenterTermsResponse(content: '<p>terms</p>', version: '3')),
      );

      expect(
        await build().getLatestVersion('dark'),
        const TermsAndConditions(content: '<p>terms</p>', version: '3'),
      );
      verify(terms.terms(theme: 'dark')).called(1);
    });

    test('returns null when the content or version is empty', () async {
      when(
        terms.terms(theme: anyNamed('theme')),
      ).thenAnswer((_) async => response(NewscenterTermsResponse(content: '', version: '3')));

      expect(await build().getLatestVersion('light'), isNull);

      when(terms.terms(theme: anyNamed('theme'))).thenAnswer(
        (_) async => response(NewscenterTermsResponse(content: '<p>terms</p>', version: '')),
      );

      expect(await build().getLatestVersion('light'), isNull);
    });

    test('returns null when the terms body is missing', () async {
      when(
        terms.terms(theme: anyNamed('theme')),
      ).thenAnswer((_) async => response<NewscenterTermsResponse>(null));

      expect(await build().getLatestVersion('light'), isNull);
    });

    test('logs and rethrows when the terms call throws', () async {
      final error = Exception('offline');
      when(terms.terms(theme: anyNamed('theme'))).thenThrow(error);

      await expectLater(build().getLatestVersion('light'), throwsA(same(error)));
      verify(logger.warning(any, error, any)).called(1);
    });
  });

  group('acceptVersion', () {
    test('sends the version and completes', () async {
      when(
        terms.acceptTerms(authTermsRequest: anyNamed('authTermsRequest')),
      ).thenAnswer((_) async => response(AuthTermsResponse(version: '2')));

      await build().acceptVersion(acceptedVersion: '2');

      final request =
          verify(
                terms.acceptTerms(authTermsRequest: captureAnyNamed('authTermsRequest')),
              ).captured.single
              as AuthTermsRequest;
      expect(request.version, '2');
      verifyNever(logger.warning(any, any, any));
    });

    test('logs and rethrows when the accept call throws', () async {
      final error = Exception('offline');
      when(terms.acceptTerms(authTermsRequest: anyNamed('authTermsRequest'))).thenThrow(error);

      await expectLater(build().acceptVersion(acceptedVersion: '2'), throwsA(same(error)));
      verify(logger.warning(any, error, any)).called(1);
    });
  });
}
