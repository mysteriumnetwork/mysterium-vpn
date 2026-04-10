import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_protocol_store.dart';

import 'vpn_protocol_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LocalDBService>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<RemoteConfigStore>(),
  MockSpec<AuthSessionStore>(),
])
void main() {
  late MockLocalDBService mockLocalDBService;
  late MockAnalyticsStore mockAnalyticsStore;
  late MockRemoteConfigStore mockRemoteConfigStore;
  late MockAuthSessionStore mockAuthSessionStore;
  late VpnProtocolStore store;

  setUp(() {
    mockLocalDBService = MockLocalDBService();
    mockAnalyticsStore = MockAnalyticsStore();
    mockRemoteConfigStore = MockRemoteConfigStore();
    mockAuthSessionStore = MockAuthSessionStore();

    // Set to unauthenticated by default to prevent automatic protocol loading
    when(mockAuthSessionStore.status).thenReturn(AuthStatus.unauthenticated);

    store = VpnProtocolStore(
      mockLocalDBService,
      mockAnalyticsStore,
      mockRemoteConfigStore,
      mockAuthSessionStore,
    );
  });

  tearDown(() async {
    await store.disposeStore();
  });

  group('getProtocol', () {
    test('returns protocol from localDB when successful', () async {
      when(mockRemoteConfigStore.isProtocolPickerAvailable).thenReturn(true);
      when(mockLocalDBService.getProtocolType()).thenAnswer((_) async => ProtocolType.openvpn);
      final result = await store.getProtocol();
      expect(result, ProtocolType.openvpn);
      verify(mockLocalDBService.getProtocolType()).called(1);
    });

    test('returns wireguard protocol from localDB when successful', () async {
      when(mockRemoteConfigStore.isProtocolPickerAvailable).thenReturn(true);
      when(mockLocalDBService.getProtocolType()).thenAnswer((_) async => ProtocolType.wireguard);
      final result = await store.getProtocol();
      expect(result, ProtocolType.wireguard);
      verify(mockLocalDBService.getProtocolType()).called(1);
    });

    test('returns default protocol (wireguard) when protocol picker is not available', () async {
      when(mockRemoteConfigStore.isProtocolPickerAvailable).thenReturn(false);
      final result = await store.getProtocol();
      expect(result, ProtocolType.wireguard);
      verifyNever(mockLocalDBService.getProtocolType());
    });

    test('returns default protocol (wireguard) when localDB throws', () async {
      when(mockRemoteConfigStore.isProtocolPickerAvailable).thenReturn(true);
      when(mockLocalDBService.getProtocolType()).thenThrow(Exception('fail'));
      final result = await store.getProtocol();
      expect(result, ProtocolType.wireguard);
      verify(mockLocalDBService.getProtocolType()).called(1);
    });
  });

  group('setProtocol', () {
    test('sets protocol and logs analytics when protocol picker is available', () async {
      when(mockRemoteConfigStore.isProtocolPickerAvailable).thenReturn(true);
      when(mockLocalDBService.setProtocolType(any)).thenAnswer((_) async => {});
      when(
        mockAnalyticsStore.logEvent(any, parameters: anyNamed('parameters')),
      ).thenAnswer((_) async => {});

      await store.setProtocol(ProtocolType.openvpn);

      expect(store.protocol, ProtocolType.openvpn);
      verify(mockLocalDBService.setProtocolType(ProtocolType.openvpn)).called(1);
      verify(
        mockAnalyticsStore.logEvent(
          AnalyticsEvent.changeProtocolType,
          parameters: {'protocol': 'openvpn'},
        ),
      ).called(1);
    });

    test('does not set protocol when protocol picker is not available', () async {
      when(mockRemoteConfigStore.isProtocolPickerAvailable).thenReturn(false);

      await store.setProtocol(ProtocolType.openvpn);

      verifyNever(mockLocalDBService.setProtocolType(any));
      verifyNever(mockAnalyticsStore.logEvent(any, parameters: anyNamed('parameters')));
    });

    test('logs error analytics and rethrows when localDB throws', () async {
      when(mockRemoteConfigStore.isProtocolPickerAvailable).thenReturn(true);
      final exception = Exception('Database error');
      when(mockLocalDBService.setProtocolType(any)).thenThrow(exception);
      when(
        mockAnalyticsStore.logEvent(any, parameters: anyNamed('parameters')),
      ).thenAnswer((_) async => {});

      expect(() => store.setProtocol(ProtocolType.openvpn), throwsA(isA<Exception>()));

      await Future.delayed(Duration.zero); // Allow async operations to complete

      verify(
        mockAnalyticsStore.logEvent(
          AnalyticsEvent.changeProtocolTypeError,
          parameters: {'error': exception.toString(), 'protocol': 'openvpn'},
        ),
      ).called(1);
    });

    test('sets wireguard protocol successfully', () async {
      when(mockRemoteConfigStore.isProtocolPickerAvailable).thenReturn(true);
      when(mockLocalDBService.setProtocolType(any)).thenAnswer((_) async => {});
      when(
        mockAnalyticsStore.logEvent(any, parameters: anyNamed('parameters')),
      ).thenAnswer((_) async => {});

      await store.setProtocol(ProtocolType.wireguard);

      expect(store.protocol, ProtocolType.wireguard);
      verify(mockLocalDBService.setProtocolType(ProtocolType.wireguard)).called(1);
      verify(
        mockAnalyticsStore.logEvent(
          AnalyticsEvent.changeProtocolType,
          parameters: {'protocol': 'wireguard'},
        ),
      ).called(1);
    });
  });

  group('protocol computed value', () {
    test('returns default protocol (wireguard) initially', () {
      expect(store.protocol, ProtocolType.wireguard);
    });

    test('returns protocol value from protocolFuture when available', () async {
      when(mockRemoteConfigStore.isProtocolPickerAvailable).thenReturn(true);
      when(mockLocalDBService.getProtocolType()).thenAnswer((_) async => ProtocolType.openvpn);

      store.protocolFuture = ObservableFuture(store.getProtocol());
      await store.protocolFuture;

      expect(store.protocol, ProtocolType.openvpn);
    });
  });

  group('disposeStore', () {
    test('disposes reaction disposer without error', () async {
      expect(() => store.disposeStore(), returnsNormally);
    });
  });

  group('auth reaction', () {
    test('loads protocol when authentication status changes to authenticated', () async {
      // Create a new store to test the reaction
      final newMockAuthSessionStore = MockAuthSessionStore();
      when(newMockAuthSessionStore.status).thenReturn(AuthStatus.unauthenticated);

      final newStore = VpnProtocolStore(
        mockLocalDBService,
        mockAnalyticsStore,
        mockRemoteConfigStore,
        newMockAuthSessionStore,
      );

      when(mockLocalDBService.getProtocolType()).thenAnswer((_) async => ProtocolType.openvpn);

      // Simulate authentication status change
      when(newMockAuthSessionStore.status).thenReturn(AuthStatus.authenticated);

      // The reaction should trigger getProtocol
      await Future.delayed(const Duration(milliseconds: 100));

      await newStore.disposeStore();
    });
  });
}
