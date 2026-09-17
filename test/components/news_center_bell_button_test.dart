import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/components/news_center_bell_button.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../support/news_fixtures.dart';
import '../support/test_localizations.dart';
import 'news_center_bell_button_test.mocks.dart';

@GenerateNiceMocks([MockSpec<RemoteConfigStore>(), MockSpec<NewsCenterRepository>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockRemoteConfigStore config;
  late MockNewsCenterRepository service;

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  setUp(() {
    config = MockRemoteConfigStore();
    service = MockNewsCenterRepository();
  });

  Future<void> pumpBell(
    WidgetTester tester, {
    required bool enabled,
    List<NewsItem> feed = const [],
    Set<int> readIds = const {},
  }) async {
    when(config.newsCenterEnabled).thenReturn(enabled);
    when(service.getFeed()).thenAnswer((_) async => feed);
    when(service.readIds()).thenReturn(readIds);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          remoteConfigStorePOD.overrideWithValue(config),
          newsCenterServicePOD.overrideWithValue(service),
        ],
        child: MaterialApp(
          theme: DesignSystem.lightTheme,
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          home: const Scaffold(body: NewsCenterBellButton()),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('renders nothing when the feature flag is off', (tester) async {
    await pumpBell(tester, enabled: false, feed: [newsItem(1)]);

    expect(find.byIcon(UntitledUI.bell_01), findsNothing);
  });

  testWidgets('shows the bell without a badge when every item is read', (tester) async {
    await pumpBell(tester, enabled: true, feed: [newsItem(1)], readIds: {1});

    expect(find.byIcon(UntitledUI.bell_01), findsOneWidget);
    expect(find.byKey(newsCenterUnreadBadgeKey), findsNothing);
  });

  testWidgets('shows the unread badge when there are unread items', (tester) async {
    await pumpBell(tester, enabled: true, feed: [newsItem(1)]);

    expect(find.byIcon(UntitledUI.bell_01), findsOneWidget);
    expect(find.byKey(newsCenterUnreadBadgeKey), findsOneWidget);
  });
}
