import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/services/auth/auth_session_store.dart';
import 'package:mysterium_vpn/services/auth/auth_status.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';

import 'refresh_ip_store_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LocalDBService>(),
  MockSpec<Talker>(),
  MockSpec<AuthSessionStore>(),
])
void main() {
  late MockLocalDBService mockLocalDBService;
  late MockTalker mockLogger;
  late MockAuthSessionStore mockAuthSessionStore;
  late RefreshIPStore store;

  setUp(() {
    mockLocalDBService = MockLocalDBService();
    mockLogger = MockTalker();
    mockAuthSessionStore = MockAuthSessionStore();
    when(mockAuthSessionStore.status).thenReturn(AuthStatus.authenticated);

    store = RefreshIPStore(
      mockLocalDBService,
      mockLogger,
      mockAuthSessionStore,
    );
  });

  group('getRefreshIPConnection', () {
    test('returns value from localDB and sets observable', () async {
      when(mockLocalDBService.getRefreshIPConnection()).thenAnswer((_) async => false);
      final result = await store.getRefreshIPConnection();
      expect(result, isFalse);
      expect(store.refreshIPConnection, isFalse);
    });

    test('returns true and logs error when localDB throws', () async {
      when(mockLocalDBService.getRefreshIPConnection()).thenThrow(Exception('fail'));
      final result = await store.getRefreshIPConnection();
      expect(result, isTrue);
      verify(mockLogger.handle(any)).called(1);
    });
  });

  group('toggleRefreshIPWhenConnecting', () {
    test('toggles refreshIPConnection and saves to localDB', () async {
      when(mockLocalDBService.setRefreshIPConnection(refreshIPConnection: false))
          .thenAnswer((_) async => {});
      await store.toggleRefreshIPWhenConnecting();
      expect(store.refreshIPConnection, isTrue);

      await store.toggleRefreshIPWhenConnecting();
      expect(store.refreshIPConnection, isFalse);
    });
  });
}
