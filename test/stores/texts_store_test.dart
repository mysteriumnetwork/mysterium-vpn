import 'dart:convert';

import 'package:configcat_client/configcat_client.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/stores/remote_config/texts_store.dart';
import 'package:talker/talker.dart';

import 'texts_store_test.mocks.dart';

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
  });

  test('decodes JSON values into a {languageCode: {key: value}} map', () async {
    when(client.getAllValues()).thenAnswer(
      (_) async => {
        'welcome': jsonEncode({'en': 'Hello', 'es': 'Hola'}),
        'bye': jsonEncode({'en': 'Bye'}),
      },
    );

    final store = TextsStore(client, logger);
    await store.setUser(ConfigCatUser(identifier: 'u1'));
    await store.configFuture;

    expect(store.texts['en'], {'welcome': 'Hello', 'bye': 'Bye'});
    expect(store.texts['es'], {'welcome': 'Hola'});
  });

  test('skips entries that are not strings', () async {
    when(client.getAllValues()).thenAnswer(
      (_) async => {
        'welcome': jsonEncode({'en': 'Hi'}),
        'bool_value': true,
      },
    );

    final store = TextsStore(client, logger);
    await store.setUser(ConfigCatUser(identifier: 'u1'));
    await store.configFuture;

    expect(store.texts['en'], {'welcome': 'Hi'});
    expect(store.texts['en']!.containsKey('bool_value'), isFalse);
  });

  test('logs and skips entries with malformed JSON', () async {
    when(client.getAllValues()).thenAnswer(
      (_) async => {
        'good': jsonEncode({'en': 'OK'}),
        'broken': '{not valid json',
      },
    );

    final store = TextsStore(client, logger);
    await store.setUser(ConfigCatUser(identifier: 'u1'));
    await store.configFuture;

    expect(store.texts['en'], {'good': 'OK'});
    verify(
      logger.log(
        'Failed to decode translations',
        exception: anyNamed('exception'),
        stackTrace: anyNamed('stackTrace'),
      ),
    ).called(1);
  });
}
