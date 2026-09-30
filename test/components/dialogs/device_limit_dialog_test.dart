import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/components/dialogs/dialogs.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../support/test_localizations.dart';
import 'device_limit_dialog_test.mocks.dart';

class _StubUrlLauncher extends UrlLauncherPlatform with MockPlatformInterfaceMixin {
  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async => true;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async => true;
}

@GenerateNiceMocks([MockSpec<AnalyticsStore>(), MockSpec<AuthSessionStore>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAnalyticsStore analyticsStore;
  late MockAuthSessionStore authSessionStore;

  setUp(() {
    analyticsStore = MockAnalyticsStore();
    authSessionStore = MockAuthSessionStore();
    UrlLauncherPlatform.instance = _StubUrlLauncher();
    when(authSessionStore.accessToken).thenReturn('token');
    when(analyticsStore.logDeviceLimitDialogShown()).thenAnswer((_) async {});
    when(analyticsStore.logDeviceLimitDashboardClicked()).thenAnswer((_) async {});
    when(analyticsStore.logDeviceLimitDismissed()).thenAnswer((_) async {});
  });

  /// Opens the device-limit prompt via [showDeviceLimitDialog].
  Future<void> openDialog(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          analyticsStorePOD.overrideWithValue(analyticsStore),
          authSessionStorePOD.overrideWithValue(authSessionStore),
        ],
        child: MaterialApp(
          theme: DesignSystem.lightTheme,
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () => showDeviceLimitDialog(ctx),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('logs the impression when the limit prompt opens', (tester) async {
    await openDialog(tester);

    expect(find.text(S.current.deviceLimitReachedTitle), findsOneWidget);
    verify(analyticsStore.logDeviceLimitDialogShown()).called(1);
  });

  testWidgets('logs the dashboard click', (tester) async {
    await openDialog(tester);

    await tester.tap(find.text(S.current.deviceLimitReachedOpenDashboard));
    await tester.pumpAndSettle();

    verify(analyticsStore.logDeviceLimitDashboardClicked()).called(1);
    verifyNever(analyticsStore.logDeviceLimitDismissed());
  });

  testWidgets('logs the dismissal when closed', (tester) async {
    await openDialog(tester);

    await tester.tap(find.text(S.current.closeBtn));
    await tester.pumpAndSettle();

    verify(analyticsStore.logDeviceLimitDismissed()).called(1);
    verifyNever(analyticsStore.logDeviceLimitDashboardClicked());
  });
}
