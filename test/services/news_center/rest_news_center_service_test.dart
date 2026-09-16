import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:vpn_api/vpn_api.dart';

import '../../support/test_prefs.dart';
import 'rest_news_center_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Newscenter>()])
void main() {
  late SharedPreferenceService prefsService;

  TestWidgetsFlutterBinding.ensureInitialized();

  late MockNewscenter api;

  setUp(() async {
    api = MockNewscenter();
    prefsService = await initTestPrefs();
  });

  RestNewsCenterService build() => RestNewsCenterService(
    api: api,
    prefs: prefsService,
    originCountry: () => 'US',
    osType: 'ios',
    appVersion: '2.4.7',
  );

  NewscenterInboxListResponseItem message(
    num id, {
    NewscenterCategory category = NewscenterCategory.news,
  }) => NewscenterInboxListResponseItem(
    id: id,
    title: 'Title $id',
    summary: 'Summary $id',
    category: category,
    webViewUrl: 'https://mysterium.network/news-center/$id',
    createdAt: DateTime.utc(2026, 7, 14),
  );

  void stubInbox(List<NewscenterInboxListResponseItem> messages) {
    when(
      api.inboxList(
        originCountry: anyNamed('originCountry'),
        osType: anyNamed('osType'),
        appVersion: anyNamed('appVersion'),
      ),
    ).thenAnswer(
      (_) async => Response<NewscenterInboxListResponse>(
        requestOptions: RequestOptions(),
        statusCode: 200,
        data: NewscenterInboxListResponse(messages: messages),
      ),
    );
  }

  group('getFeed', () {
    test('returns the inbox messages', () async {
      stubInbox([
        message(1, category: NewscenterCategory.incident),
        message(2, category: NewscenterCategory.offer),
      ]);

      final items = await build().getFeed();

      expect(items.map((i) => i.id), [1, 2]);
      // The API category is mapped to the domain enum at this boundary.
      expect(items.map((i) => i.category), [NewsCategory.incident, NewsCategory.offer]);
      expect(items.first.title, 'Title 1');
      expect(items.first.webViewUrl, 'https://mysterium.network/news-center/1');
    });

    test('passes origin country, os type and app version to the endpoint', () async {
      stubInbox(const []);

      await build().getFeed();

      verify(api.inboxList(originCountry: 'US', osType: 'ios', appVersion: '2.4.7')).called(1);
    });
  });

  group('read state', () {
    test('readIds is empty until items are marked read', () {
      expect(build().readIds(), isEmpty);
    });

    test('markRead persists ids across instances', () async {
      await build().markRead(1);
      await build().markRead(2);

      expect(build().readIds(), {1, 2});
    });

    test('clearRead removes all persisted ids', () async {
      await build().markRead(1);

      await build().clearRead();

      expect(build().readIds(), isEmpty);
    });
  });
}
