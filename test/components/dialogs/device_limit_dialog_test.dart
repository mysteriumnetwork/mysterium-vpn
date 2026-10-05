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

import '../../support/fake_url_launcher.dart';
import '../../support/test_localizations.dart';
import 'device_limit_dialog_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AnalyticsStore>(), MockSpec<AuthSessionStore>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAnalyticsStore analyticsStore;
  late MockAuthSessionStore authSessionStore;

  setUp(() {
    analyticsStore = MockAnalyticsStore();
    authSessionStore = MockAuthSessionStore();
    installFakeUrlLauncher();
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

  testWidgets('logs the dismissal when tapped away instead of closed', (tester) async {
    await openDialog(tester);

    // Barrier tap — the path the Close-button-local log used to miss.
    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();

    verify(analyticsStore.logDeviceLimitDismissed()).called(1);
  });

  testWidgets('logs the dismissal when closed', (tester) async {
    await openDialog(tester);

    await tester.tap(find.text(S.current.closeBtn));
    await tester.pumpAndSettle();

    verify(analyticsStore.logDeviceLimitDismissed()).called(1);
    verifyNever(analyticsStore.logDeviceLimitDashboardClicked());
  });
}
