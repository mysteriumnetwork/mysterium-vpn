import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../../support/test_localizations.dart';
import 'delete_account_dialog_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthStore>(), MockSpec<VpnStore>(), MockSpec<AnalyticsStore>()])
void main() {
  late MockAuthStore authStore;
  late MockVpnStore vpnStore;
  late MockAnalyticsStore analytics;

  setUp(() {
    authStore = MockAuthStore();
    vpnStore = MockVpnStore();
    analytics = MockAnalyticsStore();
    when(authStore.deleteAccountFeature).thenAnswer((_) => ObservableFuture.value(null));
    when(authStore.deleteAccount()).thenAnswer((_) async {});
    when(authStore.logout()).thenAnswer((_) async {});
    when(vpnStore.disconnectTunnel(reason: anyNamed('reason'))).thenAnswer((_) async {});
  });

  /// Opens the dialog, confirms deletion, then confirms the redirect-to-login.
  Future<void> deleteAndRedirect(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: DesignSystem.lightTheme,
        locale: testLocale,
        localizationsDelegates: testLocalizationsDelegates,
        supportedLocales: testSupportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => shownDeleteAccountDialog(
                context,
                authStore: authStore,
                vpnStore: vpnStore,
                analyticsStore: analytics,
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'DELETE');
    await tester.pumpAndSettle();
    await tester.tap(find.text(S.current.allowBtn));
    await tester.pumpAndSettle();

    await tester.tap(find.text(S.current.goToLoginBtn));
    await tester.pumpAndSettle();
  }

  testWidgets('tears the tunnel down as a logout, then logs out', (tester) async {
    await deleteAndRedirect(tester);

    verify(authStore.deleteAccount()).called(1);
    verify(vpnStore.disconnectTunnel(reason: VpnDisconnectReason.logout)).called(1);
    verify(authStore.logout()).called(1);
  });

  testWidgets('still logs out when the teardown fails', (tester) async {
    when(
      vpnStore.disconnectTunnel(reason: anyNamed('reason')),
    ).thenThrow(Exception('platform channel failed'));

    await deleteAndRedirect(tester);

    verify(authStore.logout()).called(1);
    verify(
      analytics.logEvent(AnalyticsEvent.logOutDisconnectFailed, parameters: {'reason': 'error'}),
    ).called(1);
  });

  /// Opens the dialog with the store reporting a delete already in flight.
  /// Fixed pumps, not pumpAndSettle: the button spinner never settles.
  Future<void> openWhileDeleting(WidgetTester tester, Completer<void> gate) async {
    // One instance, not a new one per build: a fresh ObservableFuture each
    // read would keep the Observer rebuilding forever.
    final deleting = ObservableFuture<void>(gate.future);
    when(authStore.deleteAccount()).thenAnswer((_) => gate.future);
    when(authStore.deleteAccountFeature).thenAnswer((_) => deleting);

    await tester.pumpWidget(
      MaterialApp(
        theme: DesignSystem.lightTheme,
        locale: testLocale,
        localizationsDelegates: testLocalizationsDelegates,
        supportedLocales: testSupportedLocales,
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => shownDeleteAccountDialog(
                context,
                authStore: authStore,
                vpnStore: vpnStore,
                analyticsStore: analytics,
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
  }

  testWidgets('cannot be dismissed while the deletion is in flight', (tester) async {
    final gate = Completer<void>();
    await openWhileDeleting(tester, gate);

    await tester.tapAt(const Offset(5, 5));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text(S.current.deleteAccountQuestion), findsOneWidget);

    gate.complete();
    await tester.pumpAndSettle();
  });

  testWidgets('locks the confirmation field while the deletion is in flight', (tester) async {
    final gate = Completer<void>();
    await openWhileDeleting(tester, gate);

    expect(tester.widget<TextField>(find.byType(TextField)).enabled, isFalse);

    gate.complete();
    await tester.pumpAndSettle();
  });
}
