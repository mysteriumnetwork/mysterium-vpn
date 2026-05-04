import 'package:configcat_client/configcat_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/stores/remote_config/config_cat_store.dart';
import 'package:talker/talker.dart';

import 'config_cat_store_test.mocks.dart';

class _TestConfigCatStore extends ConfigCatStore {
  _TestConfigCatStore(super.client, super.logger);
}

@GenerateNiceMocks([MockSpec<ConfigCatClient>(), MockSpec<Talker>(), MockSpec<RefreshResult>()])
void main() {
  late MockConfigCatClient client;
  late MockTalker logger;
  late MockRefreshResult refreshResult;

  setUp(() {
    client = MockConfigCatClient();
    logger = MockTalker();
    refreshResult = MockRefreshResult();

    when(refreshResult.isSuccess).thenReturn(true);
    when(client.forceRefresh()).thenAnswer((_) async => refreshResult);
    when(client.getAllValues()).thenAnswer((_) async => {'feature_x': true});
  });

  test('configFuture exposes cached values once a user is set', () async {
    final store = _TestConfigCatStore(client, logger);
    await store.setUser(ConfigCatUser(identifier: 'u1'));
    await store.configFuture;

    expect(store.config, {'feature_x': true});
  });

  test('refresh re-fetches values via forceRefresh', () async {
    final store = _TestConfigCatStore(client, logger);
    await store.setUser(ConfigCatUser(identifier: 'u1'));
    await store.configFuture;

    when(client.getAllValues()).thenAnswer((_) async => {'feature_x': false});
    await store.refresh();

    expect(store.config, {'feature_x': false});
    verify(client.forceRefresh()).called(greaterThanOrEqualTo(1));
  });

  test('logs (does not throw) when refresh fails', () async {
    final store = _TestConfigCatStore(client, logger);
    await store.setUser(ConfigCatUser(identifier: 'u1'));
    await store.configFuture;

    when(client.forceRefresh()).thenThrow(Exception('network'));
    await store.refresh();

    verify(logger.handle(any, any)).called(greaterThanOrEqualTo(1));
  });

  test('setUser triggers a refresh when the user changes', () async {
    final store = _TestConfigCatStore(client, logger);
    await store.setUser(ConfigCatUser(identifier: 'u1'));
    await store.configFuture;
    clearInteractions(client);

    await store.setUser(ConfigCatUser(identifier: 'u2'));

    verify(client.setDefaultUser(any)).called(1);
    verify(client.forceRefresh()).called(greaterThanOrEqualTo(1));
  });

  test('setUser does not refresh on the first call (initial setup)', () async {
    final store = _TestConfigCatStore(client, logger);
    clearInteractions(client);

    await store.setUser(ConfigCatUser(identifier: 'u1'));

    verify(client.setDefaultUser(any)).called(1);
    verifyNever(client.forceRefresh());
  });
}
