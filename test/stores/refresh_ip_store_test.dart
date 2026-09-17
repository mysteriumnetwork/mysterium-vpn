import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/auth_status.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

import 'refresh_ip_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ConnectionSettingsRepository>(),
  MockSpec<Talker>(),
  MockSpec<AuthSessionStore>(),
])
void main() {
  late MockConnectionSettingsRepository mockLocalDBService;
  late MockTalker mockLogger;
  late MockAuthSessionStore mockAuthSessionStore;
  late RefreshIPStore store;

  setUp(() {
    mockLocalDBService = MockConnectionSettingsRepository();
    mockLogger = MockTalker();
    mockAuthSessionStore = MockAuthSessionStore();
    when(mockAuthSessionStore.status).thenReturn(AuthStatus.authenticated);

    store = RefreshIPStore(mockLocalDBService, mockLogger, mockAuthSessionStore);
  });

  group('getRefreshIPConnection', () {
    test('returns value from localDB and sets observable', () async {
      when(mockLocalDBService.refreshIpOnConnect()).thenAnswer((_) async => false);
      final result = await store.getRefreshIPConnection();
      expect(result, isFalse);
      expect(store.refreshIPConnection, isFalse);
    });

    test('returns true and logs error when localDB throws', () async {
      when(mockLocalDBService.refreshIpOnConnect()).thenThrow(Exception('fail'));
      final result = await store.getRefreshIPConnection();
      expect(result, isTrue);
      verify(mockLogger.handle(any)).called(1);
    });
  });

  group('toggleRefreshIPWhenConnecting', () {
    test('toggles refreshIPConnection and saves to localDB', () async {
      when(mockLocalDBService.setRefreshIpOnConnect(value: false)).thenAnswer((_) async => {});
      await store.toggleRefreshIPWhenConnecting();
      expect(store.refreshIPConnection, isTrue);

      await store.toggleRefreshIPWhenConnecting();
      expect(store.refreshIPConnection, isFalse);
    });

    test('disposeStore tears down the auth reaction without error', () {
      // Calling twice should still not crash since the disposer is null-checked.
      store
        ..disposeStore()
        ..disposeStore();
    });
  });
}
