import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

import 'news_center_store_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NewsCenterService>(), MockSpec<Talker>()])
void main() {
  late MockNewsCenterService service;
  late MockTalker logger;

  NewscenterInboxListResponseItem item(
    int id, {
    NewscenterCategory category = NewscenterCategory.news,
  }) => NewscenterInboxListResponseItem(
    id: id,
    category: category,
    title: 'Title $id',
    summary: 'Summary $id',
    createdAt: DateTime.utc(2026, 7, 14),
    webViewUrl: 'https://mysterium.network/news-center/$id',
  );

  setUp(() {
    service = MockNewsCenterService();
    logger = MockTalker();
    when(service.readIds()).thenReturn(<int>{});
  });

  NewsCenterStore build() => NewsCenterStore(service, logger);

  test('isEmpty is null before the first load', () {
    expect(build().isEmpty, isNull);
  });

  test('load populates items and isEmpty becomes false', () async {
    when(service.getFeed()).thenAnswer((_) async => [item(1), item(2)]);

    final store = build();
    await store.load();

    expect(store.filteredItems.map((i) => i.id), [1, 2]);
    expect(store.isEmpty, isFalse);
  });

  test('isEmpty is true when a load returns no items', () async {
    when(service.getFeed()).thenAnswer((_) async => <NewscenterInboxListResponseItem>[]);

    final store = build();
    await store.load();

    expect(store.isEmpty, isTrue);
  });

  test('filteredItems filters by the selected category', () async {
    when(service.getFeed()).thenAnswer(
      (_) async => [
        item(1, category: NewscenterCategory.incident),
        item(2),
        item(3, category: NewscenterCategory.offer),
      ],
    );

    final store = build();
    await store.load();

    store.selectedFilter = NewsFilter.incidents;
    expect(store.filteredItems.map((i) => i.id), [1]);

    store.selectedFilter = NewsFilter.news;
    expect(store.filteredItems.map((i) => i.id), [2]);

    store.selectedFilter = NewsFilter.offers;
    expect(store.filteredItems.map((i) => i.id), [3]);

    store.selectedFilter = NewsFilter.all;
    expect(store.filteredItems.map((i) => i.id), [1, 2, 3]);
  });

  test('nonEmptyFilters is empty before load and when the feed is empty', () async {
    final store = build();
    expect(store.nonEmptyFilters, isEmpty);

    when(service.getFeed()).thenAnswer((_) async => <NewscenterInboxListResponseItem>[]);
    await store.load();
    expect(store.nonEmptyFilters, isEmpty);
  });

  test('nonEmptyFilters includes all plus only the categories present', () async {
    when(
      service.getFeed(),
    ).thenAnswer((_) async => [item(1, category: NewscenterCategory.incident), item(2)]);

    final store = build();
    await store.load();

    expect(store.nonEmptyFilters, {NewsFilter.all, NewsFilter.incidents, NewsFilter.news});
  });

  test('derives read state from the persisted read ids', () async {
    when(service.readIds()).thenReturn({2});
    when(service.getFeed()).thenAnswer((_) async => [item(1), item(2), item(3)]);

    final store = build();
    await store.load();

    // Only item 2 is persisted as read, so two of three remain unread.
    expect(store.unreadCount, 2);
    expect(store.isRead(2), isTrue);
    expect(store.isRead(1), isFalse);
  });

  test('markRead flips the item, updates unreadCount, and persists the id', () async {
    when(service.getFeed()).thenAnswer((_) async => [item(1)]);

    final store = build();
    await store.load();
    expect(store.unreadCount, 1);

    store.markRead(1);

    expect(store.unreadCount, 0);
    expect(store.isRead(1), isTrue);
    verify(service.markRead(1)).called(1);
  });

  test('clearRead clears read state in memory and persists the clear', () async {
    when(service.getFeed()).thenAnswer((_) async => [item(1)]);

    final store = build();
    await store.load();
    store.markRead(1);
    expect(store.isRead(1), isTrue);

    await store.clearRead();

    expect(store.isRead(1), isFalse);
    expect(store.unreadCount, 1);
    verify(service.clearRead()).called(1);
  });

  test('a read item stays read across a reload', () async {
    when(service.getFeed()).thenAnswer((_) async => [item(1)]);

    final store = build();
    await store.load();
    store.markRead(1);

    await store.refresh();

    expect(store.isRead(1), isTrue);
    expect(store.unreadCount, 0);
  });

  test('refresh returns true and updates items on success', () async {
    when(service.getFeed()).thenAnswer((_) async => [item(1)]);

    final store = build();

    expect(await store.refresh(), isTrue);
    expect(store.filteredItems.map((i) => i.id), [1]);
  });

  test('a failed refresh returns false and keeps the previously loaded items', () async {
    when(service.getFeed()).thenAnswer((_) async => [item(1)]);

    final store = build();
    await store.load();
    expect(store.filteredItems.map((i) => i.id), [1]);

    when(service.getFeed()).thenThrow(Exception('network'));

    expect(await store.refresh(), isFalse);
    expect(store.filteredItems.map((i) => i.id), [1]);
    expect(store.isEmpty, isFalse);
    expect(store.hasError, isFalse);
  });

  test('hasError is true when the first load fails with no cached data', () async {
    when(service.getFeed()).thenThrow(Exception('network'));

    final store = build();
    await store.load();

    expect(store.hasError, isTrue);
    expect(store.isEmpty, isNull);
  });
}
