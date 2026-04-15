import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

import 'wiregurad_key_service_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<WireguardDart>(),
  MockSpec<SecureStorageService>(),
  MockSpec<AnalyticsStore>(),
])
void main() {
  group('WireguradKeyService', () {
    late WireguradKeyService wireguradKeyService;
    late MockWireguardDart mockWireguardDart;
    late MockSecureStorageService mockSecureStorageService;
    late MockAnalyticsStore mockAnalyticsStore;

    setUp(() {
      mockWireguardDart = MockWireguardDart();
      mockSecureStorageService = MockSecureStorageService();
      mockAnalyticsStore = MockAnalyticsStore();

      wireguradKeyService = WireguradKeyService(
        wireguardService: mockWireguardDart,
        secureStorageService: mockSecureStorageService,
        analyticsStore: mockAnalyticsStore,
      );
    });

    group('WireguradKeyService', () {
      test('getWireguradKey returns existing key available in storage', () async {
        when(mockSecureStorageService.getWireguardPublicKey()).thenAnswer((_) async => 'publicKey');
        when(
          mockSecureStorageService.getWireguardPrivateKey(),
        ).thenAnswer((_) async => 'privateKey');
        final key = await wireguradKeyService.getWireguradKey();
        expect(key.publicKey, 'publicKey');
        expect(key.privateKey, 'privateKey');
      });

      test('getWireguradKey throws exception', () async {
        when(
          mockSecureStorageService.getWireguardPublicKey(),
        ).thenThrow(Exception('Storage error'));
        when(mockWireguardDart.generateKeyPair()).thenThrow(Exception('Wireguard error'));
        expect(() async => wireguradKeyService.getWireguradKey(), throwsException);
      });

      test('regenerateWireguardKeys generates new keys and saves them', () async {
        when(
          mockWireguardDart.generateKeyPair(),
        ).thenAnswer((_) async => KeyPair('publicKey', 'privateKey'));
        final key = await wireguradKeyService.regenerateWireguardKeys();
        expect(key.publicKey, 'publicKey');
        expect(key.privateKey, 'privateKey');
        verify(
          mockSecureStorageService.saveWireguardPrivateKey(privateKey: 'privateKey'),
        ).called(1);
        verify(mockSecureStorageService.saveWireguardPublicKey(publicKey: 'publicKey')).called(1);
      });

      test('regenerateWireguardKeys throws exception', () async {
        when(mockWireguardDart.generateKeyPair()).thenThrow(Exception('Wireguard error'));
        expect(() async => wireguradKeyService.regenerateWireguardKeys(), throwsException);
      });

      test('getWireguradKey generates new key if no key in storage', () async {
        when(mockSecureStorageService.getWireguardPublicKey()).thenAnswer((_) async => null);
        when(mockSecureStorageService.getWireguardPrivateKey()).thenAnswer((_) async => null);
        when(
          mockWireguardDart.generateKeyPair(),
        ).thenAnswer((_) async => KeyPair('newPublicKey', 'newPrivateKey'));

        final key = await wireguradKeyService.getWireguradKey();
        expect(key.publicKey, 'newPublicKey');
        expect(key.privateKey, 'newPrivateKey');
        verify(
          mockSecureStorageService.saveWireguardPrivateKey(privateKey: 'newPrivateKey'),
        ).called(1);
        verify(
          mockSecureStorageService.saveWireguardPublicKey(publicKey: 'newPublicKey'),
        ).called(1);
      });

      test('getWireguradKey returns null if no key in storage and generation fails', () async {
        when(mockSecureStorageService.getWireguardPublicKey()).thenAnswer((_) async => null);
        when(mockSecureStorageService.getWireguardPrivateKey()).thenAnswer((_) async => null);
        when(mockWireguardDart.generateKeyPair()).thenThrow(Exception('Wireguard error'));

        expect(() async => wireguradKeyService.getWireguradKey(), throwsException);
      });

      test('regenerateWireguardKeys saves new keys', () async {
        when(
          mockWireguardDart.generateKeyPair(),
        ).thenAnswer((_) async => KeyPair('newPublicKey', 'newPrivateKey'));

        final key = await wireguradKeyService.regenerateWireguardKeys();
        expect(key.publicKey, 'newPublicKey');
        expect(key.privateKey, 'newPrivateKey');
        verify(
          mockSecureStorageService.saveWireguardPrivateKey(privateKey: 'newPrivateKey'),
        ).called(1);
        verify(
          mockSecureStorageService.saveWireguardPublicKey(publicKey: 'newPublicKey'),
        ).called(1);
      });
    });
  });
}
