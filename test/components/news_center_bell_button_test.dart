import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/components/news_center_bell_button.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vpn_api/vpn_api.dart';

import '../support/test_localizations.dart';
import 'news_center_bell_button_test.mocks.dart';

@GenerateNiceMocks([MockSpec<RemoteConfigStore>(), MockSpec<NewsCenterService>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockRemoteConfigStore config;
  late MockNewsCenterService service;

  setUpAll(() {
    SharedPreferences.setMockInitialValues({});
  });

  setUp(() {
    config = MockRemoteConfigStore();
    service = MockNewsCenterService();
  });

  NewscenterInboxListResponseItem item(int id) => NewscenterInboxListResponseItem(
    id: id,
    category: NewscenterCategory.news,
    title: 'Title $id',
    summary: 'Message $id',
    createdAt: DateTime.now(),
    webViewUrl: 'https://mysterium.network/news/$id',
  );

  Future<void> pumpBell(
    WidgetTester tester, {
    required bool enabled,
    List<NewscenterInboxListResponseItem> feed = const [],
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
    await pumpBell(tester, enabled: false, feed: [item(1)]);

    expect(find.byIcon(UntitledUI.bell_01), findsNothing);
  });

  testWidgets('shows the bell without a badge when every item is read', (tester) async {
    await pumpBell(tester, enabled: true, feed: [item(1)], readIds: {1});

    expect(find.byIcon(UntitledUI.bell_01), findsOneWidget);
    expect(find.byKey(newsCenterUnreadBadgeKey), findsNothing);
  });

  testWidgets('shows the unread badge when there are unread items', (tester) async {
    await pumpBell(tester, enabled: true, feed: [item(1)]);

    expect(find.byIcon(UntitledUI.bell_01), findsOneWidget);
    expect(find.byKey(newsCenterUnreadBadgeKey), findsOneWidget);
  });
}
