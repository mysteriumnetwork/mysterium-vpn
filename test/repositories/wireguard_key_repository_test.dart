import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/repositories/vpn/wireguard_key_repository.dart';
import 'package:mysterium_vpn/services/data/storage.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

import 'wireguard_key_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<WireguardDart>(),
  MockSpec<SecureStorageService>(),
  MockSpec<AnalyticsStore>(),
])
void main() {
  group('WireguardKeyRepository', () {
    late WireguardKeyRepository wireguardKeyRepository;
    late MockWireguardDart mockWireguardDart;
    late MockSecureStorageService mockSecureStorageService;
    late MockAnalyticsStore mockAnalyticsStore;

    setUp(() {
      mockWireguardDart = MockWireguardDart();
      mockSecureStorageService = MockSecureStorageService();
      mockAnalyticsStore = MockAnalyticsStore();

      wireguardKeyRepository = WireguardKeyRepository(
        wireguardService: mockWireguardDart,
        secureStorageService: mockSecureStorageService,
        analyticsLogger: mockAnalyticsStore.logEvent,
      );
    });

    group('WireguardKeyRepository', () {
      test('getWireguardKey returns existing key available in storage', () async {
        when(mockSecureStorageService.getWireguardPublicKey()).thenAnswer((_) async => 'publicKey');
        when(
          mockSecureStorageService.getWireguardPrivateKey(),
        ).thenAnswer((_) async => 'privateKey');
        final key = await wireguardKeyRepository.getWireguardKey();
        expect(key.publicKey, 'publicKey');
        expect(key.privateKey, 'privateKey');
      });

      test('getWireguardKey throws exception', () async {
        when(
          mockSecureStorageService.getWireguardPublicKey(),
        ).thenThrow(Exception('Storage error'));
        when(mockWireguardDart.generateKeyPair()).thenThrow(Exception('Wireguard error'));
        expect(() async => wireguardKeyRepository.getWireguardKey(), throwsException);
      });

      test('regenerateWireguardKeys generates new keys and saves them', () async {
        when(
          mockWireguardDart.generateKeyPair(),
        ).thenAnswer((_) async => KeyPair('publicKey', 'privateKey'));
        final key = await wireguardKeyRepository.regenerateWireguardKeys();
        expect(key.publicKey, 'publicKey');
        expect(key.privateKey, 'privateKey');
        verify(
          mockSecureStorageService.saveWireguardPrivateKey(privateKey: 'privateKey'),
        ).called(1);
        verify(mockSecureStorageService.saveWireguardPublicKey(publicKey: 'publicKey')).called(1);
      });

      test('regenerateWireguardKeys throws exception', () async {
        when(mockWireguardDart.generateKeyPair()).thenThrow(Exception('Wireguard error'));
        expect(() async => wireguardKeyRepository.regenerateWireguardKeys(), throwsException);
      });

      test('getWireguardKey generates new key if no key in storage', () async {
        when(mockSecureStorageService.getWireguardPublicKey()).thenAnswer((_) async => null);
        when(mockSecureStorageService.getWireguardPrivateKey()).thenAnswer((_) async => null);
        when(
          mockWireguardDart.generateKeyPair(),
        ).thenAnswer((_) async => KeyPair('newPublicKey', 'newPrivateKey'));

        final key = await wireguardKeyRepository.getWireguardKey();
        expect(key.publicKey, 'newPublicKey');
        expect(key.privateKey, 'newPrivateKey');
        verify(
          mockSecureStorageService.saveWireguardPrivateKey(privateKey: 'newPrivateKey'),
        ).called(1);
        verify(
          mockSecureStorageService.saveWireguardPublicKey(publicKey: 'newPublicKey'),
        ).called(1);
      });

      test('getWireguardKey returns null if no key in storage and generation fails', () async {
        when(mockSecureStorageService.getWireguardPublicKey()).thenAnswer((_) async => null);
        when(mockSecureStorageService.getWireguardPrivateKey()).thenAnswer((_) async => null);
        when(mockWireguardDart.generateKeyPair()).thenThrow(Exception('Wireguard error'));

        expect(() async => wireguardKeyRepository.getWireguardKey(), throwsException);
      });

      test('regenerateWireguardKeys saves new keys', () async {
        when(
          mockWireguardDart.generateKeyPair(),
        ).thenAnswer((_) async => KeyPair('newPublicKey', 'newPrivateKey'));

        final key = await wireguardKeyRepository.regenerateWireguardKeys();
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
