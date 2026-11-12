import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';
import 'package:mysterium_vpn/stores/stores.dart';

import 'vpn_protocol_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ConnectionSettingsRepository>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<RemoteConfigStore>(),
  MockSpec<AuthSessionStore>(),
])
void main() {
  late MockConnectionSettingsRepository mockLocalDBService;
  late MockAnalyticsStore mockAnalyticsStore;
  late MockRemoteConfigStore mockRemoteConfigStore;
  late MockAuthSessionStore mockAuthSessionStore;
  late VpnProtocolStore store;

  setUp(() {
    mockLocalDBService = MockConnectionSettingsRepository();
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

  group('VLESS availability', () {
    setUp(() {
      when(mockRemoteConfigStore.isProtocolPickerAvailable).thenReturn(true);
    });

    test('always offers the default protocol, whatever the gates say', () {
      // availableProtocols feeds the picker's item list while `protocol` feeds
      // its selected value; a gate that could drop the default would render a
      // selection that is not in the list.
      store.testIsAndroid = true;
      when(mockRemoteConfigStore.vlessEnabled).thenReturn(false);

      expect(store.availableProtocols, contains(ProtocolType.wireguard));
    });

    test('is offered on Apple platforms once the flag is on', () {
      store.testIsIOS = true;
      when(mockRemoteConfigStore.vlessEnabled).thenReturn(true);

      expect(store.availableProtocols, contains(ProtocolType.vless));
    });

    test('is hidden when the flag is off', () {
      store.testIsIOS = true;
      when(mockRemoteConfigStore.vlessEnabled).thenReturn(false);

      expect(store.availableProtocols, isNot(contains(ProtocolType.vless)));
      expect(store.availableProtocols, containsAll([ProtocolType.wireguard, ProtocolType.openvpn]));
    });

    test('is hidden on Android even with the flag on', () {
      store.testIsAndroid = true;
      when(mockRemoteConfigStore.vlessEnabled).thenReturn(true);

      expect(store.availableProtocols, isNot(contains(ProtocolType.vless)));
      expect(store.availableProtocols, containsAll([ProtocolType.wireguard, ProtocolType.openvpn]));
    });

    test('is hidden on Windows even with the flag on', () {
      store.testIsWindows = true;
      when(mockRemoteConfigStore.vlessEnabled).thenReturn(true);

      expect(store.availableProtocols, isNot(contains(ProtocolType.vless)));
    });

    test('is offered on macOS once the flag is on', () {
      store.testIsMacOS = true;
      when(mockRemoteConfigStore.vlessEnabled).thenReturn(true);

      expect(store.availableProtocols, contains(ProtocolType.vless));
    });

    test('setProtocol refuses VLESS when it is not available', () async {
      store.testIsIOS = true;
      when(mockRemoteConfigStore.vlessEnabled).thenReturn(false);

      await store.setProtocol(ProtocolType.vless);

      verifyNever(mockLocalDBService.setProtocolType(any));
      expect(store.protocol, ProtocolType.wireguard);
    });

    test('a stored VLESS falls back when the flag is turned off', () async {
      store.testIsIOS = true;
      when(mockRemoteConfigStore.vlessEnabled).thenReturn(false);
      when(mockLocalDBService.protocolType()).thenAnswer((_) async => ProtocolType.vless);

      expect(await store.getProtocol(), ProtocolType.wireguard);
    });

    test('a stored VLESS is kept while the flag is on', () async {
      store.testIsIOS = true;
      when(mockRemoteConfigStore.vlessEnabled).thenReturn(true);
      when(mockLocalDBService.protocolType()).thenAnswer((_) async => ProtocolType.vless);

      expect(await store.getProtocol(), ProtocolType.vless);
    });
  });

  group('getProtocol', () {
    test('returns protocol from localDB when successful', () async {
      when(mockRemoteConfigStore.isProtocolPickerAvailable).thenReturn(true);
      when(mockLocalDBService.protocolType()).thenAnswer((_) async => ProtocolType.openvpn);
      final result = await store.getProtocol();
      expect(result, ProtocolType.openvpn);
      verify(mockLocalDBService.protocolType()).called(1);
    });

    test('returns wireguard protocol from localDB when successful', () async {
      when(mockRemoteConfigStore.isProtocolPickerAvailable).thenReturn(true);
      when(mockLocalDBService.protocolType()).thenAnswer((_) async => ProtocolType.wireguard);
      final result = await store.getProtocol();
      expect(result, ProtocolType.wireguard);
      verify(mockLocalDBService.protocolType()).called(1);
    });

    test('returns default protocol (wireguard) when protocol picker is not available', () async {
      when(mockRemoteConfigStore.isProtocolPickerAvailable).thenReturn(false);
      final result = await store.getProtocol();
      expect(result, ProtocolType.wireguard);
      verifyNever(mockLocalDBService.protocolType());
    });

    test('returns default protocol (wireguard) when localDB throws', () async {
      when(mockRemoteConfigStore.isProtocolPickerAvailable).thenReturn(true);
      when(mockLocalDBService.protocolType()).thenThrow(Exception('fail'));
      final result = await store.getProtocol();
      expect(result, ProtocolType.wireguard);
      verify(mockLocalDBService.protocolType()).called(1);
    });
  });

  group('setProtocol', () {
    test('sets protocol and logs analytics when protocol picker is available', () async {
      when(mockRemoteConfigStore.isProtocolPickerAvailable).thenReturn(true);
      when(mockLocalDBService.setProtocolType(any)).thenAnswer((_) async => {});
      when(mockAnalyticsStore.logEvent(any, parameters: anyNamed('parameters')))
          .thenAnswer((_) async => {});

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
      when(mockAnalyticsStore.logEvent(any, parameters: anyNamed('parameters')))
          .thenAnswer((_) async => {});

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
      when(mockAnalyticsStore.logEvent(any, parameters: anyNamed('parameters')))
          .thenAnswer((_) async => {});

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
      when(mockLocalDBService.protocolType()).thenAnswer((_) async => ProtocolType.openvpn);

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

      when(mockLocalDBService.protocolType()).thenAnswer((_) async => ProtocolType.openvpn);

      // Simulate authentication status change
      when(newMockAuthSessionStore.status).thenReturn(AuthStatus.authenticated);

      // The reaction should trigger getProtocol
      await Future.delayed(const Duration(milliseconds: 100));

      await newStore.disposeStore();
    });
  });
}
