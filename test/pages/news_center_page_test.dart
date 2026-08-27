import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/pages/news_center_page.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/news_center/news_center_strings.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vpn_api/vpn_api.dart';

import '../support/news_fixtures.dart';
import '../support/test_localizations.dart';
import 'news_center_page_test.mocks.dart';

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

  Future<ProviderContainer> pumpPage(
    WidgetTester tester, {
    Locale locale = testLocale,
    NewsItemOpener? onOpenItem,
    int? deepLinkItemId,
  }) async {
    late ProviderContainer container;
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          newsCenterServicePOD.overrideWithValue(service),
          analyticsStorePOD.overrideWithValue(analytics),
        ],
        child: MaterialApp(
          theme: DesignSystem.lightTheme,
          locale: locale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          home: Builder(
            builder: (context) {
              container = ProviderScope.containerOf(context);
              return NewsCenterPage(
                onOpenItem: onOpenItem ?? (_, _) {},
                deepLinkItemId: deepLinkItemId,
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('shows the page title and back label', (tester) async {
    when(service.getFeed()).thenAnswer((_) async => const []);

    await pumpPage(tester);

    expect(find.text(newsCenterTitleText), findsOneWidget);
    expect(find.text(newsCenterBackText), findsOneWidget);
  });

  testWidgets('forces left-to-right even under an RTL locale', (tester) async {
    when(service.getFeed()).thenAnswer((_) async => const []);

    await pumpPage(tester, locale: const Locale('ar'));

    final context = tester.element(find.text(newsCenterTitleText));
    expect(Directionality.of(context), TextDirection.ltr);
  });

  testWidgets('tapping a card marks it read, opens it, and logs the event', (tester) async {
    when(service.getFeed()).thenAnswer((_) async => [newsItem(1)]);
    NewscenterInboxListResponseItem? opened;

    final container = await pumpPage(tester, onOpenItem: (_, i) => opened = i);

    await tester.tap(find.text('Title 1'));
    await tester.pumpAndSettle();

    expect(opened?.id, 1);
    expect(container.read(newsCenterStorePOD).isRead(1), isTrue);
    verify(analytics.logNewsCenterItemOpened(id: 1, category: NewscenterCategory.news)).called(1);
  });

  testWidgets('constrains the feed to a fixed width on desktop', (tester) async {
    tester.view.physicalSize = const Size(1400, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    when(service.getFeed()).thenAnswer((_) async => const []);

    await pumpPage(tester);

    expect(find.text(newsCenterTitleText), findsOneWidget);
    expect(find.text(newsCenterBackText), findsOneWidget);
    expect(
      find.byWidgetPredicate((w) => w is SizedBox && w.width == NewsCenterPage.desktopContentWidth),
      findsOneWidget,
    );
  });

  testWidgets('deepLinkItemId opens that item once loaded, marking it read', (tester) async {
    when(service.getFeed()).thenAnswer((_) async => [newsItem(1), newsItem(2)]);
    NewscenterInboxListResponseItem? opened;

    final container = await pumpPage(tester, onOpenItem: (_, i) => opened = i, deepLinkItemId: 2);

    expect(opened?.id, 2);
    expect(container.read(newsCenterStorePOD).isRead(2), isTrue);
    verify(analytics.logNewsCenterItemOpened(id: 2, category: NewscenterCategory.news)).called(1);
  });

  testWidgets('an unknown deepLinkItemId opens nothing', (tester) async {
    when(service.getFeed()).thenAnswer((_) async => [newsItem(1)]);
    NewscenterInboxListResponseItem? opened;

    await pumpPage(tester, onOpenItem: (_, i) => opened = i, deepLinkItemId: 999);

    expect(opened, isNull);
    verifyNever(
      analytics.logNewsCenterItemOpened(id: anyNamed('id'), category: anyNamed('category')),
    );
  });

  testWidgets('a changed deepLinkItemId re-opens on a reused page', (tester) async {
    when(service.getFeed()).thenAnswer((_) async => [newsItem(1), newsItem(2)]);
    final opened = <int>[];
    final id = ValueNotifier<int?>(1);
    addTearDown(id.dispose);

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
          // Same widget position/key across rebuilds, so the page state is
          // reused and only `deepLinkItemId` changes (mirrors Beamer reusing the
          // route's page for a new `?id=`).
          home: ValueListenableBuilder<int?>(
            valueListenable: id,
            builder: (_, value, _) => NewsCenterPage(
              onOpenItem: (_, i) => opened.add(i.id.toInt()),
              deepLinkItemId: value,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(opened, [1]);

    id.value = 2;
    await tester.pumpAndSettle();
    expect(opened, [1, 2]);
  });

  testWidgets('a deepLinkItemId change mid-load does not open the stale item', (tester) async {
    // Feed load stays in flight until we complete it, so we can change the id
    // while the first deep-link task is still awaiting.
    final completer = Completer<List<NewscenterInboxListResponseItem>>();
    when(service.getFeed()).thenAnswer((_) => completer.future);
    final opened = <int>[];
    final id = ValueNotifier<int?>(1);
    addTearDown(id.dispose);

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
          home: ValueListenableBuilder<int?>(
            valueListenable: id,
            builder: (_, value, _) => NewsCenterPage(
              onOpenItem: (_, i) => opened.add(i.id.toInt()),
              deepLinkItemId: value,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    // Switch the target id before the feed resolves, then resolve it.
    id.value = 2;
    await tester.pump();
    completer.complete([newsItem(1), newsItem(2)]);
    await tester.pumpAndSettle();

    // Only the current id opened; the stale id-1 task was cancelled.
    expect(opened, [2]);
  });
}
