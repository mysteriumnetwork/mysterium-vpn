import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/news_center/components/news_center_loading_view.dart';
import 'package:mysterium_vpn/views/news_center/news_center_strings.dart';
import 'package:mysterium_vpn/views/news_center/news_center_view.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vpn_api/vpn_api.dart';

import '../../support/test_localizations.dart';
import 'news_center_view_test.mocks.dart';

@GenerateNiceMocks([MockSpec<NewsCenterService>(), MockSpec<AnalyticsStore>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockNewsCenterService service;
  late MockAnalyticsStore analytics;

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  setUp(() {
    service = MockNewsCenterService();
    analytics = MockAnalyticsStore();
  });

  // Recent timestamps keep the card time label on the relative-string path
  // (avoids DateFormat, which needs date symbols not loaded in widget tests).
  NewscenterInboxListResponseItem item(
    int id, {
    NewscenterCategory category = NewscenterCategory.news,
  }) => NewscenterInboxListResponseItem(
    id: id,
    category: category,
    title: 'Title $id',
    summary: 'Message $id',
    createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    webViewUrl: 'https://mysterium.network/news/$id',
  );

  Future<void> pump(
    WidgetTester tester, {
    void Function(NewscenterInboxListResponseItem)? onItemTap,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          newsCenterServicePOD.overrideWithValue(service),
          analyticsStorePOD.overrideWithValue(analytics),
        ],
        child: MaterialApp(
          theme: DesignSystem.lightTheme,
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          home: Scaffold(body: NewsCenterView(onItemTap: onItemTap ?? (_) {})),
        ),
      ),
    );
  }

  testWidgets('shows the shimmer skeleton during the initial load with no cached data', (
    tester,
  ) async {
    final completer = Completer<List<NewscenterInboxListResponseItem>>();
    when(service.getFeed()).thenAnswer((_) => completer.future);

    await pump(tester);
    await tester.pump();

    expect(find.byType(NewsCenterLoadingView), findsOneWidget);

    completer.complete(const []);
    await tester.pumpAndSettle();
  });

  testWidgets('shows the empty state when the feed is empty', (tester) async {
    when(service.getFeed()).thenAnswer((_) async => const []);

    await pump(tester);
    await tester.pumpAndSettle();

    expect(find.text(newsCenterEmptyTitleText), findsOneWidget);
    expect(find.text(newsCenterEmptySubtitleText), findsOneWidget);
  });

  testWidgets('logs a viewed event when the page is entered', (tester) async {
    when(service.getFeed()).thenAnswer((_) async => const []);

    await pump(tester);
    await tester.pumpAndSettle();

    verify(analytics.logNewsCenterViewed()).called(1);
  });

  testWidgets('shows a retry action when the load fails and logs the retry', (tester) async {
    when(service.getFeed()).thenThrow(Exception('network'));

    await pump(tester);
    await tester.pumpAndSettle();

    expect(find.text(newsCenterRetryText), findsOneWidget);

    await tester.tap(find.text(newsCenterRetryText));
    await tester.pumpAndSettle();

    verify(analytics.logNewsCenterRetryClicked()).called(1);
  });

  testWidgets('renders a card per item and filters by the selected tab', (tester) async {
    when(
      service.getFeed(),
    ).thenAnswer((_) async => [item(1, category: NewscenterCategory.incident), item(2)]);

    await pump(tester);
    await tester.pumpAndSettle();

    expect(find.text('Title 1'), findsOneWidget);
    expect(find.text('Title 2'), findsOneWidget);

    await tester.tap(find.text(newsFilterIncidentsText));
    await tester.pumpAndSettle();

    expect(find.text('Title 1'), findsOneWidget);
    expect(find.text('Title 2'), findsNothing);
    verify(analytics.logNewsCenterFilterSelected(NewsFilter.incidents)).called(1);
  });

  testWidgets('disables filter tabs whose category has no items', (tester) async {
    when(
      service.getFeed(),
    ).thenAnswer((_) async => [item(1, category: NewscenterCategory.incident)]);

    await pump(tester);
    await tester.pumpAndSettle();

    NewsTab tab(String label) =>
        tester.widget<NewsTab>(find.byWidgetPredicate((w) => w is NewsTab && w.label == label));

    // Only incidents present → All + Incidents enabled, News + Offers disabled.
    expect(tab(newsFilterAllText).status, isNot(NewsTabStatus.disabled));
    expect(tab(newsFilterIncidentsText).status, isNot(NewsTabStatus.disabled));
    expect(tab(newsFilterNewsText).status, NewsTabStatus.disabled);
    expect(tab(newsFilterOffersText).status, NewsTabStatus.disabled);
  });

  testWidgets('tapping a card invokes onItemTap with the item', (tester) async {
    NewscenterInboxListResponseItem? tapped;
    when(service.getFeed()).thenAnswer((_) async => [item(1)]);

    await pump(tester, onItemTap: (i) => tapped = i);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Title 1'));
    await tester.pumpAndSettle();

    expect(tapped?.id, 1);
  });

  testWidgets('the unread dot clears reactively when an item is marked read', (tester) async {
    when(service.getFeed()).thenAnswer((_) async => [item(1)]);

    await pump(tester);
    await tester.pumpAndSettle();

    final unreadDot = find.byWidgetPredicate(
      (w) =>
          w is Container &&
          w.decoration is BoxDecoration &&
          (w.decoration! as BoxDecoration).color == Palette.unreadIndicator,
    );
    expect(unreadDot, findsOneWidget);

    ProviderScope.containerOf(
      tester.element(find.byType(NewsCenterView)),
    ).read(newsCenterStorePOD).markRead(1);
    await tester.pumpAndSettle();

    expect(unreadDot, findsNothing);
  });
}
