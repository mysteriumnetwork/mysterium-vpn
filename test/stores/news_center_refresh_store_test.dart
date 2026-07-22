import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/stores/stores.dart';

import 'news_center_refresh_store_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NewsCenterStore>(), MockSpec<RemoteConfigStore>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockNewsCenterStore news;
  late MockRemoteConfigStore config;
  late DateTime now;

  setUp(() {
    news = MockNewsCenterStore();
    config = MockRemoteConfigStore();
    now = DateTime.utc(2026, 7, 14, 12);
    when(news.refresh()).thenAnswer((_) async => true);
    when(config.newsCenterEnabled).thenReturn(true);
    when(config.newsCenterRefreshIntervalMinutes).thenReturn(30);
  });

  NewsCenterRefreshStore build() {
    final store = NewsCenterRefreshStore(news, config, clock: () => now);
    addTearDown(store.dispose);
    return store;
  }

  void dispatch(NewsCenterRefreshStore store, AppLifecycleState state) =>
      store.didChangeAppLifecycleState(state);

  test('refreshes when resumed after being backgrounded past the interval', () {
    final store = build();

    dispatch(store, AppLifecycleState.paused);
    now = now.add(const Duration(minutes: 31));
    dispatch(store, AppLifecycleState.resumed);

    verify(news.refresh()).called(1);
  });

  test('does not refresh when backgrounded for less than the interval', () {
    final store = build();

    dispatch(store, AppLifecycleState.paused);
    now = now.add(const Duration(minutes: 5));
    dispatch(store, AppLifecycleState.resumed);

    verifyNever(news.refresh());
  });

  test('does not refresh when the interval is 0 (disabled)', () {
    when(config.newsCenterRefreshIntervalMinutes).thenReturn(0);
    final store = build();

    dispatch(store, AppLifecycleState.paused);
    now = now.add(const Duration(hours: 2));
    dispatch(store, AppLifecycleState.resumed);

    verifyNever(news.refresh());
  });

  test('does not refresh when the feature is disabled', () {
    when(config.newsCenterEnabled).thenReturn(false);
    final store = build();

    dispatch(store, AppLifecycleState.paused);
    now = now.add(const Duration(hours: 2));
    dispatch(store, AppLifecycleState.resumed);

    verifyNever(news.refresh());
  });

  test('does not refresh on resume without a preceding pause', () {
    final store = build();

    dispatch(store, AppLifecycleState.resumed);

    verifyNever(news.refresh());
  });

  test('does not refresh on an inactive -> resumed transition', () {
    final store = build();

    dispatch(store, AppLifecycleState.paused);
    now = now.add(const Duration(hours: 1));
    dispatch(store, AppLifecycleState.inactive);
    dispatch(store, AppLifecycleState.resumed);

    verifyNever(news.refresh());
  });
}
