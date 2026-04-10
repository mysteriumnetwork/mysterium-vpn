import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/core/enums/auth_status.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/subscription_config_store.dart';
import 'package:mysterium_vpn/stores/subscription_features_store.dart';
import 'package:talker/talker.dart';

import 'dns_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LocalDBService>(),
  MockSpec<RemoteConfigStore>(),
  MockSpec<Talker>(),
  MockSpec<AuthSessionStore>(),
  MockSpec<SubscriptionStore>(),
  MockSpec<SubscriptionConfigStore>(),
  MockSpec<SubscriptionFeaturesStore>(),
])
void main() {
  late MockLocalDBService mockLocalDBService;
  late MockRemoteConfigStore mockRemoteConfigStore;
  late MockTalker mockLogger;
  late MockAuthSessionStore mockAuthSessionStore;
  late MockSubscriptionFeaturesStore mockSubscriptionFeaturesStore;
  late DNSStore store;

  setUp(() {
    mockLocalDBService = MockLocalDBService();
    mockRemoteConfigStore = MockRemoteConfigStore();
    mockLogger = MockTalker();
    mockAuthSessionStore = MockAuthSessionStore();
    mockSubscriptionFeaturesStore = MockSubscriptionFeaturesStore();

    when(mockAuthSessionStore.status).thenReturn(AuthStatus.authenticated);

    store = DNSStore(
      mockLocalDBService,
      mockRemoteConfigStore,
      mockLogger,
      mockAuthSessionStore,
      mockSubscriptionFeaturesStore,
    );
  });

  group('getMalwareBlockerContent', () {
    test('returns true when localDB returns true', () async {
      when(mockLocalDBService.getMalwareContentBlocker()).thenAnswer((_) async => true);
      final result = await store.getMalwareContentBlocker();
      expect(result, isTrue);
      expect(store.malwareContentBlocker, isTrue);
    });

    test('returns false and logs error when localDB throws', () async {
      when(mockLocalDBService.getMalwareContentBlocker()).thenThrow(Exception('fail'));
      final result = await store.getMalwareContentBlocker();
      expect(result, isFalse);
      verify(mockLogger.handle(any)).called(1);
    });
  });

  group('getNotSafeContentBlocker', () {
    test('returns true when localDB returns true', () async {
      when(mockLocalDBService.getNotSafeContentBlocker()).thenAnswer((_) async => true);
      final result = await store.getNotSafeContentBlocker();
      expect(result, isTrue);
      expect(store.notSafeContentBlocker, isTrue);
    });

    test('returns false and logs error when localDB throws', () async {
      when(mockLocalDBService.getNotSafeContentBlocker()).thenThrow(Exception('fail'));
      final result = await store.getNotSafeContentBlocker();
      expect(result, isFalse);
      verify(mockLogger.handle(any)).called(1);
    });
  });

  group('toggleMalwareBlocker', () {
    test('toggles malware blocker and saves to localDB', () async {
      // Initial value is false, toggling will set to true
      when(mockLocalDBService.setMalwareContentBlocker(value: true)).thenAnswer((_) async => {});
      await store.toggleMalwareBlocker();
      expect(store.malwareContentBlocker, isTrue);
      verify(mockLocalDBService.setMalwareContentBlocker(value: true)).called(1);

      // Toggling again will set to false
      when(mockLocalDBService.setMalwareContentBlocker(value: false)).thenAnswer((_) async => {});
      await store.toggleMalwareBlocker();
      expect(store.malwareContentBlocker, isFalse);
      verify(mockLocalDBService.setMalwareContentBlocker(value: false)).called(1);
    });
  });

  group('toggleNotSafeContentBlocker', () {
    test('toggles not safe content blocker and saves to localDB', () async {
      // Initial value is false, toggling will set to true
      when(mockLocalDBService.setNotSafeContentBlocker(value: true)).thenAnswer((_) async => {});
      when(mockLocalDBService.setMalwareContentBlocker(value: true)).thenAnswer((_) async => {});
      await store.toggleNotSafeContentBlocker();
      expect(store.notSafeContentBlocker, isTrue);
      verify(mockLocalDBService.setNotSafeContentBlocker(value: true)).called(1);
      verify(mockLocalDBService.setMalwareContentBlocker(value: true)).called(1);

      // Toggling again will set to false
      when(mockLocalDBService.setNotSafeContentBlocker(value: false)).thenAnswer((_) async => {});
      await store.toggleNotSafeContentBlocker();
      expect(store.notSafeContentBlocker, isFalse);
      verify(mockLocalDBService.setNotSafeContentBlocker(value: false)).called(1);
    });
  });

  group('dnsAddress', () {
    test(
      'returns notSafeContentBlockerDnsAddress if not safe content blocker is enabled',
      () async {
        when(mockSubscriptionFeaturesStore.malwareBlockingAllowed).thenReturn(true);
        when(mockRemoteConfigStore.hideNotSafeContentBlocker).thenReturn(false);
        when(mockRemoteConfigStore.notSafeContentBlockerDnsAddress).thenReturn('1.1.1.3');
        when(mockLocalDBService.getNotSafeContentBlocker()).thenAnswer((_) async => true);
        await store.getNotSafeContentBlocker();
        expect(store.dnsAddress, '1.1.1.3');
      },
    );

    test('returns malwareBlockerDnsAddress if malware blocker is enabled', () async {
      when(mockSubscriptionFeaturesStore.malwareBlockingAllowed).thenReturn(true);
      when(mockRemoteConfigStore.hideNotSafeContentBlocker).thenReturn(true);
      when(mockRemoteConfigStore.hideMalwareBlocker).thenReturn(false);
      when(mockRemoteConfigStore.malwareBlockerDnsAddress).thenReturn('8.8.8.8');
      when(mockLocalDBService.getMalwareContentBlocker()).thenAnswer((_) async => true);
      await store.getMalwareContentBlocker();
      expect(store.dnsAddress, '8.8.8.8');
    });

    test('returns default DNS address if no blockers are enabled', () {
      when(mockRemoteConfigStore.hideNotSafeContentBlocker).thenReturn(true);
      when(mockRemoteConfigStore.hideMalwareBlocker).thenReturn(true);
      // Both blockers are false by default
      expect(store.dnsAddress, '1.1.1.1');
    });
  });
}
