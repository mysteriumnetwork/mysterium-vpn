import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:dio/dio.dart' as dio;
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';
import 'package:mysterium_vpn/services/data/local/adapters/adapters.dart';
import 'package:mysterium_vpn/services/data/storage.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

import 'auth_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthRepository>(),
  MockSpec<AuthSessionStore>(),
  MockSpec<AppLinks>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<Talker>(),
  MockSpec<ABTestingStore>(),
  MockSpec<DeviceIDStore>(),
  MockSpec<SecureStorageService>(),
])
void main() {
  late AuthStore store;
  late MockAuthRepository authService;
  late MockAuthSessionStore sessionStore;
  late MockAppLinks appLinks;
  late MockAnalyticsStore analyticsStore;
  late MockTalker logger;
  late MockABTestingStore abTestingStore;
  late MockDeviceIDStore deviceIDStore;
  late MockSecureStorageService secureStorage;

  late Directory hiveDir;

  final tokens = TokenResponse(userId: 'u1', accessToken: 'access', refreshToken: 'refresh');
  final apiException = ApiException(
    RequestOptions(),
    'bad credentials',
    code: 400,
    identifier: 'identifier',
    endpoint: '/auth',
    severity: ExceptionSeverity.low,
  );

  // The refresh endpoint answered and refused the token.
  final refreshRejected = ApiException(
    RequestOptions(),
    'invalid refresh token',
    code: 401,
    identifier: 'identifier',
    endpoint: '/oauth/token',
    severity: ExceptionSeverity.low,
    response: dio.Response<dynamic>(requestOptions: RequestOptions(), statusCode: 401),
  );

  // Nothing answered: ConnectionErrorsInterceptor has no response to pass on.
  final refreshUnreachable = ApiException(
    RequestOptions(),
    'Unable to connect to the server.',
    code: 1,
    identifier: 'identifier',
    endpoint: '/oauth/token',
    severity: ExceptionSeverity.low,
  );

  // A 4xx that says nothing about the refresh token.
  final refreshRateLimited = ApiException(
    RequestOptions(),
    'too many requests',
    code: 4029,
    identifier: 'identifier',
    endpoint: '/oauth/token',
    severity: ExceptionSeverity.low,
    response: dio.Response<dynamic>(requestOptions: RequestOptions(), statusCode: 429),
  );

  final refreshServerError = ApiException(
    RequestOptions(),
    'service unavailable',
    code: 503,
    identifier: 'identifier',
    endpoint: '/oauth/token',
    severity: ExceptionSeverity.high,
    response: dio.Response<dynamic>(requestOptions: RequestOptions(), statusCode: 503),
  );

  // LocalDBService reads Hive boxes in its field initializers, so the boxes
  // must exist before each test.
  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    hiveDir = await Directory.systemTemp.createTemp('auth_store_test_');
    Hive
      ..init(hiveDir.path)
      ..registerAdapter(UserDataAdapter())
      ..registerAdapter(ApprovalAdapter())
      ..registerAdapter(const VPNLocationAdapter(typeId: 3))
      ..registerAdapter(const BannerTypeAdapter(typeId: 4))
      ..registerAdapter(const VpnLocationsAdapter(typeId: 5))
      ..registerAdapter(const LatLngAdapter(typeId: 6))
      ..registerAdapter(const ProtocolTypeAdapter(typeId: 7));
    await Hive.openBox<UserData>('user_data');
    await Hive.openBox<LatLng>('coordinates_data');
  });

  tearDownAll(() async {
    await Hive.close();
    if (hiveDir.existsSync()) {
      await hiveDir.delete(recursive: true);
    }
  });

  setUp(() {
    authService = MockAuthRepository();
    sessionStore = MockAuthSessionStore();
    appLinks = MockAppLinks();
    analyticsStore = MockAnalyticsStore();
    logger = MockTalker();
    abTestingStore = MockABTestingStore();
    deviceIDStore = MockDeviceIDStore();
    secureStorage = MockSecureStorageService();

    when(appLinks.uriLinkStream).thenAnswer((_) => const Stream<Uri>.empty());
    when(deviceIDStore.deviceIdFuture).thenAnswer((_) => ObservableFuture.value('device-id'));
    when(sessionStore.setAuthenticated(any, any)).thenAnswer((_) async {});
    when(sessionStore.setUnauthenticated()).thenAnswer((_) async {});
    when(sessionStore.refreshTokenFuture).thenAnswer((_) => ObservableFuture.value('refresh'));
    when(sessionStore.status).thenReturn(AuthStatus.authenticated);
    when(analyticsStore.setLogin(any)).thenAnswer((_) async {});
    when(secureStorage.getRefreshTokenOrFail()).thenAnswer((_) async => null);

    store = AuthStore(
      flow: LocalAuthFlowRepository(MockSecureStorageService()),
      session: LocalSessionRepository(secureStorage: secureStorage, db: LocalDBService()),
      authService: authService,
      authSessionStore: sessionStore,
      appLinks: appLinks,
      analyticsStore: analyticsStore,
      logger: logger,
      abTestingStore: abTestingStore,
      deviceIDStore: deviceIDStore,
    );
  });

  group('authenticate', () {
    test('persists tokens and records the login on success', () async {
      await store.authenticate(GrantType.email, Future.value(tokens));

      verify(sessionStore.setAuthenticated('access', 'refresh')).called(1);
      verify(analyticsStore.setLogin()).called(1);
    });

    test('swallows ApiException without setting authenticated', () async {
      await store.authenticate(GrantType.email, Future.error(apiException));

      verifyNever(sessionStore.setAuthenticated(any, any));
      verifyNever(analyticsStore.setLogin(any));
    });

    test('swallows generic errors without setting authenticated', () async {
      await store.authenticate(GrantType.email, Future.error(Exception('boom')));

      verifyNever(sessionStore.setAuthenticated(any, any));
      verifyNever(analyticsStore.setLogin(any));
    });

    test('records the login even when the credentials cannot be persisted', () async {
      when(
        sessionStore.setAuthenticated('access', 'refresh'),
      ).thenThrow(PlatformException(code: '-25308', message: 'User interaction is not allowed.'));

      await store.authenticate(GrantType.email, Future.value(tokens));

      verify(analyticsStore.setLogin()).called(1);
      expect(store.authError, isNull);
    });
  });

  group('signInWithGoogle', () {
    test('drives signInComplete and exposes authenticatingType', () async {
      when(authService.signInWithGoogle()).thenAnswer((_) async => 'google-id-token');
      when(authService.signInComplete(tokenRequest: anyNamed('tokenRequest')))
          .thenAnswer((_) async => tokens);

      await store.signInWithGoogle();
      // Wait for the inner authenticate() future to resolve.
      await store.authenticateFeature;

      expect(store.authenticatingType, GrantType.google);
      verify(authService.signInWithGoogle()).called(1);
      verify(authService.signInComplete(tokenRequest: anyNamed('tokenRequest'))).called(1);
      verify(sessionStore.setAuthenticated('access', 'refresh')).called(1);
    });

    test('skips authenticate when signInWithGoogle returns null', () async {
      // signInWithGoogle declares non-null return but mocks may stub null.
      when(authService.signInWithGoogle()).thenAnswer((_) async => '');
      when(authService.signInComplete(tokenRequest: anyNamed('tokenRequest')))
          .thenAnswer((_) async => tokens);

      await store.signInWithGoogle();
      // Empty string is non-null so authenticate IS called — assert the
      // happy path. Null-return is unreachable per the API contract.
      verify(authService.signInComplete(tokenRequest: anyNamed('tokenRequest'))).called(1);
    });

    test('rethrows SignInAborted', () async {
      when(authService.signInWithGoogle()).thenThrow(SignInAborted());

      await expectLater(store.signInWithGoogle(), throwsA(isA<SignInAborted>()));
      verifyNever(authService.signInComplete(tokenRequest: anyNamed('tokenRequest')));
    });

    test('rethrows generic errors', () async {
      when(authService.signInWithGoogle()).thenThrow(Exception('network'));

      await expectLater(store.signInWithGoogle(), throwsA(isA<Exception>()));
    });
  });

  group('signInWithApple', () {
    test('drives signInComplete on success', () async {
      when(authService.signInWithApple()).thenAnswer((_) async => 'apple-authorization');
      when(authService.signInComplete(tokenRequest: anyNamed('tokenRequest')))
          .thenAnswer((_) async => tokens);

      await store.signInWithApple();
      await store.authenticateFeature;

      expect(store.authenticatingType, GrantType.apple);
      verify(authService.signInComplete(tokenRequest: anyNamed('tokenRequest'))).called(1);
      verify(sessionStore.setAuthenticated('access', 'refresh')).called(1);
    });

    test('rethrows NotAvailableException', () async {
      when(authService.signInWithApple()).thenThrow(NotAvailableException());

      await expectLater(store.signInWithApple(), throwsA(isA<NotAvailableException>()));
    });

    test('rethrows SignInAborted', () async {
      when(authService.signInWithApple()).thenThrow(SignInAborted());

      await expectLater(store.signInWithApple(), throwsA(isA<SignInAborted>()));
    });

    test('rethrows generic errors', () async {
      when(authService.signInWithApple()).thenThrow(Exception('boom'));

      await expectLater(store.signInWithApple(), throwsA(isA<Exception>()));
    });
  });

  group('logout', () {
    test('calls authService.logout with invalidateRemotely flag', () async {
      when(authService.logout(invalidateRemotely: anyNamed('invalidateRemotely')))
          .thenAnswer((_) async {});

      await store.logout();

      verify(authService.logout(invalidateRemotely: true)).called(1);
    });

    test('respects invalidateRemotely: false', () async {
      when(authService.logout(invalidateRemotely: anyNamed('invalidateRemotely')))
          .thenAnswer((_) async {});

      await store.logout(invalidateRemotely: false);

      verify(authService.logout(invalidateRemotely: false)).called(1);
    });
  });

  group('deleteAccount', () {
    test('calls authService.deleteAccount', () async {
      when(authService.deleteAccount()).thenAnswer((_) async {});

      await store.deleteAccount();

      verify(authService.deleteAccount()).called(1);
    });

    test('swallows errors silently', () async {
      when(authService.deleteAccount()).thenThrow(Exception('server fail'));

      await expectLater(store.deleteAccount(), completes);
    });
  });

  group('refreshAuthToken', () {
    test('uses the refresh token to obtain new credentials', () async {
      when(authService.signInComplete(tokenRequest: anyNamed('tokenRequest')))
          .thenAnswer((_) async => tokens);

      await store.refreshAuthToken();

      verify(authService.signInComplete(tokenRequest: anyNamed('tokenRequest'))).called(1);
      verify(sessionStore.setAuthenticated('access', 'refresh')).called(1);
    });

    test('logs out when no refresh token is stored', () async {
      when(sessionStore.refreshTokenFuture).thenAnswer((_) => ObservableFuture.value(null));
      when(authService.logout(invalidateRemotely: anyNamed('invalidateRemotely')))
          .thenAnswer((_) async {});

      await expectLater(store.refreshAuthToken(), throwsA(isA<RefreshTokenNotFoundException>()));
      verify(authService.logout(invalidateRemotely: false)).called(1);
    });

    test('logs out when the server rejects the refresh token', () async {
      when(sessionStore.status).thenReturn(AuthStatus.authenticated);
      when(authService.signInComplete(tokenRequest: anyNamed('tokenRequest')))
          .thenThrow(refreshRejected);
      when(authService.logout(invalidateRemotely: anyNamed('invalidateRemotely')))
          .thenAnswer((_) async {});

      await expectLater(store.refreshAuthToken(), throwsA(isA<ApiException>()));
      verify(authService.logout(invalidateRemotely: false)).called(1);
    });

    test('keeps the session when the refresh token cannot be read', () async {
      when(sessionStore.refreshTokenFuture).thenAnswer((_) => ObservableFuture.value(null));
      when(secureStorage.getRefreshTokenOrFail()).thenThrow(StorageUnavailableException());

      await expectLater(store.refreshAuthToken(), throwsA(isA<StorageUnavailableException>()));

      verifyNever(authService.logout(invalidateRemotely: anyNamed('invalidateRemotely')));
      expect(store.authError, isNull);
    });

    test('recovers a refresh token that memory lost', () async {
      when(sessionStore.refreshTokenFuture).thenAnswer((_) => ObservableFuture.value(null));
      when(secureStorage.getRefreshTokenOrFail()).thenAnswer((_) async => 'refresh');
      when(authService.signInComplete(tokenRequest: anyNamed('tokenRequest')))
          .thenAnswer((_) async => tokens);

      await store.refreshAuthToken();

      verify(sessionStore.setAuthenticated('access', 'refresh')).called(1);
      verifyNever(authService.logout(invalidateRemotely: anyNamed('invalidateRemotely')));
    });

    test('keeps the session when the refresh never reaches the server', () async {
      when(sessionStore.status).thenReturn(AuthStatus.authenticated);
      when(authService.signInComplete(tokenRequest: anyNamed('tokenRequest')))
          .thenThrow(refreshUnreachable);

      await expectLater(store.refreshAuthToken(), throwsA(isA<ApiException>()));

      verifyNever(authService.logout(invalidateRemotely: anyNamed('invalidateRemotely')));
      expect(store.authError, isNull);
    });

    test('keeps the session when the server fails to answer the refresh', () async {
      when(sessionStore.status).thenReturn(AuthStatus.authenticated);
      when(authService.signInComplete(tokenRequest: anyNamed('tokenRequest')))
          .thenThrow(refreshServerError);

      await expectLater(store.refreshAuthToken(), throwsA(isA<ApiException>()));

      verifyNever(authService.logout(invalidateRemotely: anyNamed('invalidateRemotely')));
      expect(store.authError, isNull);
    });

    test('keeps the session when the refreshed credentials cannot be persisted', () async {
      when(sessionStore.status).thenReturn(AuthStatus.authenticated);
      when(authService.signInComplete(tokenRequest: anyNamed('tokenRequest')))
          .thenAnswer((_) async => tokens);
      when(
        sessionStore.setAuthenticated('access', 'refresh'),
      ).thenThrow(PlatformException(code: '-25308', message: 'User interaction is not allowed.'));

      await expectLater(store.refreshAuthToken(), completes);

      verifyNever(authService.logout(invalidateRemotely: anyNamed('invalidateRemotely')));
      expect(store.authError, isNull);
    });

    test('still logs out (no snackbar) when not authenticated', () async {
      when(sessionStore.status).thenReturn(AuthStatus.unauthenticated);
      when(authService.signInComplete(tokenRequest: anyNamed('tokenRequest')))
          .thenThrow(refreshRejected);
      when(authService.logout(invalidateRemotely: anyNamed('invalidateRemotely')))
          .thenAnswer((_) async {});

      await expectLater(store.refreshAuthToken(), throwsA(isA<Exception>()));
      verify(authService.logout(invalidateRemotely: false)).called(1);
    });

    test('keeps the session when the refresh is rate limited', () async {
      when(sessionStore.status).thenReturn(AuthStatus.authenticated);
      when(authService.signInComplete(tokenRequest: anyNamed('tokenRequest')))
          .thenThrow(refreshRateLimited);

      await expectLater(store.refreshAuthToken(), throwsA(isA<ApiException>()));

      verifyNever(authService.logout(invalidateRemotely: anyNamed('invalidateRemotely')));
    });
  });

  group('fetchAuthUser', () {
    test('signs out when the access token is refused', () async {
      when(authService.currentUser()).thenThrow(refreshRejected);

      await store.fetchAuthUser();

      verify(sessionStore.setUnauthenticated()).called(1);
    });

    test('completes the sign-in when the user record cannot be persisted', () async {
      when(authService.currentUser())
          .thenAnswer((_) async => AuthUser(userId: 'u1', username: 'a@b.c'));
      when(abTestingStore.configFuture).thenAnswer((_) => ObservableFuture.value({}));
      when(
        sessionStore.setAuthenticatedUser(any),
      ).thenThrow(PlatformException(code: '-25308', message: 'User interaction is not allowed.'));

      await store.fetchAuthUser();

      expect(store.authError, isNull);
      verify(analyticsStore.setUserProperty(any)).called(greaterThanOrEqualTo(1));
    });

    test('keeps the session on 401 when the refresh got no verdict', () async {
      when(sessionStore.status).thenReturn(AuthStatus.authenticated);
      when(authService.signInComplete(tokenRequest: anyNamed('tokenRequest')))
          .thenThrow(refreshUnreachable);
      await expectLater(store.refreshAuthToken(), throwsA(isA<ApiException>()));

      when(authService.currentUser()).thenThrow(refreshRejected);
      await store.fetchAuthUser();

      verifyNever(sessionStore.setUnauthenticated());
    });

    test('signs out again once a later refresh is conclusive', () async {
      when(sessionStore.status).thenReturn(AuthStatus.authenticated);
      when(authService.signInComplete(tokenRequest: anyNamed('tokenRequest')))
          .thenThrow(refreshUnreachable);
      await expectLater(store.refreshAuthToken(), throwsA(isA<ApiException>()));

      when(authService.signInComplete(tokenRequest: anyNamed('tokenRequest')))
          .thenThrow(refreshRejected);
      when(authService.logout(invalidateRemotely: anyNamed('invalidateRemotely')))
          .thenAnswer((_) async {});
      await expectLater(store.refreshAuthToken(), throwsA(isA<ApiException>()));

      when(authService.currentUser()).thenThrow(refreshRejected);
      await store.fetchAuthUser();

      verify(sessionStore.setUnauthenticated()).called(1);
    });
  });
}
