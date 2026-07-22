import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/services/services.dart' hide Response;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vpn_api/vpn_api.dart';

import 'rest_news_center_service_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Newscenter>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockNewscenter api;

  setUp(() async {
    api = MockNewscenter();
    SharedPreferences.setMockInitialValues({});
    await SharedPreferenceService.instance.init();
  });

  RestNewsCenterService build() => RestNewsCenterService(
    api: api,
    prefs: SharedPreferenceService.instance,
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
      expect(items.first.category, NewscenterCategory.incident);
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
