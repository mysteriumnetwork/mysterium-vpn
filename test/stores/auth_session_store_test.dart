import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:latlong2/latlong.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/auth_status.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/data/local/adapters/adapters.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';

import 'auth_session_store_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SecureStorageService>(), MockSpec<RemoteConfigStore>()])
void main() {
  late MockSecureStorageService storage;
  late MockRemoteConfigStore remoteConfig;
  late Directory hiveDir;

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    hiveDir = await Directory.systemTemp.createTemp('auth_session_store_test_');
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
    storage = MockSecureStorageService();
    remoteConfig = MockRemoteConfigStore();

    when(storage.getAccessToken()).thenAnswer((_) async => null);
    when(storage.getRefreshToken()).thenAnswer((_) async => null);
    when(storage.getUserId()).thenAnswer((_) async => null);
    when(storage.getUsername()).thenAnswer((_) async => null);
    when(storage.saveAccessToken(any)).thenAnswer((_) async {});
    when(storage.saveRefreshToken(any)).thenAnswer((_) async {});
    when(storage.saveUserId(userId: anyNamed('userId'))).thenAnswer((_) async {});
    when(storage.saveUsername(username: anyNamed('username'))).thenAnswer((_) async {});
    when(storage.removeAccessToken()).thenAnswer((_) async {});
    when(storage.removeRefreshToken()).thenAnswer((_) async {});
    when(storage.removeUserId()).thenAnswer((_) async {});
    when(storage.removeUsername()).thenAnswer((_) async {});
    when(remoteConfig.browseUnauthenticated).thenReturn(false);
  });

  AuthSessionStore newStore() =>
      AuthSessionStore(secureStorage: storage, remoteConfigStore: remoteConfig);

  group('initStore', () {
    test('marks unauthenticated when no access token is stored', () async {
      final store = newStore();
      await store.initStore();

      expect(store.status, AuthStatus.unauthenticated);
      expect(store.isAuthenticated, isFalse);
    });

    test('marks authenticated when access token is present', () async {
      when(storage.getAccessToken()).thenAnswer((_) async => 'token');
      final store = newStore();
      await store.initStore();

      expect(store.status, AuthStatus.authenticated);
      expect(store.isAuthenticated, isTrue);
    });

    test('rehydrates user from stored userId/username', () async {
      when(storage.getUserId()).thenAnswer((_) async => 'u1');
      when(storage.getUsername()).thenAnswer((_) async => 'u@e.com');

      final store = newStore();
      await store.initStore();

      expect(store.user, isNotNull);
      expect(store.user!.userId, 'u1');
      expect(store.user!.username, 'u@e.com');
    });
  });

  group('setAuthenticated', () {
    test('persists tokens and flips status', () async {
      final store = newStore();
      await store.initStore();

      await store.setAuthenticated('access', 'refresh');

      expect(store.status, AuthStatus.authenticated);
      expect(store.accessToken, 'access');
      expect(store.refreshToken, 'refresh');
      verify(storage.saveAccessToken('access')).called(1);
      verify(storage.saveRefreshToken('refresh')).called(1);
    });
  });

  group('setUnauthenticated', () {
    test('clears tokens and user, removes from storage', () async {
      when(storage.getAccessToken()).thenAnswer((_) async => 'token');
      final store = newStore();
      await store.initStore();

      await store.setUnauthenticated();

      expect(store.status, AuthStatus.unauthenticated);
      expect(store.accessToken, isNull);
      expect(store.refreshToken, isNull);
      verify(storage.removeAccessToken()).called(1);
      verify(storage.removeRefreshToken()).called(1);
      verify(storage.removeUserId()).called(1);
      verify(storage.removeUsername()).called(1);
    });
  });

  group('canBrowseApp', () {
    test('false when unauthenticated and authShown false', () async {
      final store = newStore();
      await store.initStore();

      expect(store.canBrowseApp, isFalse);
    });

    test('true when authenticated', () async {
      when(storage.getAccessToken()).thenAnswer((_) async => 'token');
      final store = newStore();
      await store.initStore();

      expect(store.canBrowseApp, isTrue);
    });

    test('true when authShown is set and remote config allows browsing', () async {
      when(remoteConfig.browseUnauthenticated).thenReturn(true);
      final store = newStore();
      await store.initStore();
      store.authShown = true;

      expect(store.canBrowseApp, isTrue);
    });
  });

  group('invalidateAccessToken', () {
    test('writes invalid token and re-reads it from storage', () async {
      when(storage.getAccessToken()).thenAnswer((_) async => 'token');
      final store = newStore();
      await store.initStore();
      // Subsequent read should reflect the just-saved invalid value.
      when(storage.getAccessToken()).thenAnswer((_) async => 'invalid');

      await store.invalidateAccessToken();

      verify(storage.saveAccessToken('invalid')).called(1);
      expect(store.accessToken, 'invalid');
    });
  });
}
