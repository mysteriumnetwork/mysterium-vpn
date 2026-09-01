import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/settings/push_notifications_settings.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../../support/test_localizations.dart';
import 'push_notifications_settings_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<PushNotificationsStore>(),
  MockSpec<AuthSessionStore>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<ThemeStore>(),
])
void main() {
  late MockPushNotificationsStore pushNotificationsStore;
  late MockAuthSessionStore authSessionStore;
  late MockAnalyticsStore analyticsStore;
  late MockThemeStore themeStore;

  setUp(() {
    pushNotificationsStore = MockPushNotificationsStore();
    authSessionStore = MockAuthSessionStore();
    analyticsStore = MockAnalyticsStore();
    themeStore = MockThemeStore();

    when(themeStore.isDarkMode).thenReturn(false);
    when(authSessionStore.status).thenReturn(AuthStatus.authenticated);
    when(pushNotificationsStore.supportsPushNotifications).thenReturn(true);
    when(pushNotificationsStore.pushNotificationsPermissionGranted).thenReturn(false);
    when(pushNotificationsStore.updatePushNotificationsPermissions()).thenAnswer((_) async {});
  });

  Widget harness() => ProviderScope(
    overrides: [
      pushNotificationsStorePOD.overrideWithValue(pushNotificationsStore),
      authSessionStorePOD.overrideWithValue(authSessionStore),
      analyticsStorePOD.overrideWithValue(analyticsStore),
      themeStorePOD.overrideWithValue(themeStore),
    ],
    child: MaterialApp(
      theme: DesignSystem.lightTheme,
      locale: testLocale,
      localizationsDelegates: testLocalizationsDelegates,
      supportedLocales: testSupportedLocales,
      home: const Scaffold(body: PushNotificationsSetting(position: SettingsCardPosition.single)),
    ),
  );

  /// The card branches on screen width, so drive both sizes explicitly rather
  /// than relying on the default test surface.
  Future<void> pumpAt(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();
  }

  group('the open-system-settings affordance', () {
    // The trailing switch is read-only, so this link is the only way to act on
    // the setting. A wide layout (desktop, macOS) must not drop it.
    testWidgets('renders on a narrow layout', (tester) async {
      await pumpAt(tester, const Size(400, 900));

      expect(find.text(S.current.openSystemSettingsBtn), findsOneWidget);
    });

    testWidgets('renders on a wide layout', (tester) async {
      await pumpAt(tester, const Size(1200, 900));

      expect(find.text(S.current.openSystemSettingsBtn), findsOneWidget);
    });

    testWidgets('a wide layout keeps the description alongside it', (tester) async {
      await pumpAt(tester, const Size(1200, 900));

      expect(find.text(S.current.pushNotificationsSettingDesc), findsOneWidget);
      expect(find.text(S.current.openSystemSettingsBtn), findsOneWidget);
    });

    testWidgets('tapping it asks the store to open system settings', (tester) async {
      await pumpAt(tester, const Size(1200, 900));

      await tester.tap(find.text(S.current.openSystemSettingsBtn));
      await tester.pumpAndSettle();

      verify(pushNotificationsStore.updatePushNotificationsPermissions()).called(1);
    });
  });

  group('visibility', () {
    testWidgets('hidden on a platform without push support', (tester) async {
      when(pushNotificationsStore.supportsPushNotifications).thenReturn(false);

      await pumpAt(tester, const Size(1200, 900));

      expect(find.byType(SettingsCard), findsNothing);
    });

    testWidgets('hidden when the user is not authenticated', (tester) async {
      when(authSessionStore.status).thenReturn(AuthStatus.unauthenticated);

      await pumpAt(tester, const Size(1200, 900));

      expect(find.byType(SettingsCard), findsNothing);
    });
  });
}
