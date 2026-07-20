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

  NewscenterInboxListResponseItem item(int id) => NewscenterInboxListResponseItem(
    id: id,
    category: NewscenterCategory.news,
    title: 'Title $id',
    summary: 'Message $id',
    createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
    webViewUrl: 'https://mysterium.network/news/$id',
  );

  Future<ProviderContainer> pumpPage(
    WidgetTester tester, {
    Locale locale = testLocale,
    NewsItemOpener? onOpenItem,
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
              return NewsCenterPage(onOpenItem: onOpenItem ?? (_, _) {});
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
    when(service.getFeed()).thenAnswer((_) async => [item(1)]);
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
}
