import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/components/dialogs/dialogs.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../../support/test_localizations.dart';
import 'resume_subscription_dialog_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AnalyticsStore>(), MockSpec<SubscriptionStore>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockAnalyticsStore analyticsStore;
  late MockSubscriptionStore subscriptionStore;

  final paused = Subscription(
    active: true,
    id: 'sub-1',
    paused: true,
    pausedUntil: DateTime.utc(2026, 9, 15),
  );
  final resumed = Subscription(active: true, id: 'sub-1', activeUntil: DateTime.utc(2026, 10, 20));

  setUp(() {
    analyticsStore = MockAnalyticsStore();
    subscriptionStore = MockSubscriptionStore();
    when(
      analyticsStore.logSubscriptionResumeStarted(
        subscriptionId: anyNamed('subscriptionId'),
        pauseEndDate: anyNamed('pauseEndDate'),
      ),
    ).thenAnswer((_) async {});
    when(
      analyticsStore.logSubscriptionResumeCompleted(
        subscriptionId: anyNamed('subscriptionId'),
        subscriptionStatusBefore: anyNamed('subscriptionStatusBefore'),
        subscriptionStatusAfter: anyNamed('subscriptionStatusAfter'),
        billingResumeDate: anyNamed('billingResumeDate'),
      ),
    ).thenAnswer((_) async {});
    when(
      analyticsStore.logSubscriptionResumeFailed(
        subscriptionId: anyNamed('subscriptionId'),
        failureReason: anyNamed('failureReason'),
      ),
    ).thenAnswer((_) async {});
    when(subscriptionStore.subscriptionFuture).thenAnswer((_) => ObservableFuture.value(paused));
  });

  /// Opens the prompt and exposes whatever it pops through [result].
  Future<List<bool?>> openPrompt(WidgetTester tester) async {
    final result = <bool?>[];
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          analyticsStorePOD.overrideWithValue(analyticsStore),
          subscriptionStorePOD.overrideWithValue(subscriptionStore),
        ],
        child: MaterialApp(
          scaffoldMessengerKey: snackbarKey,
          theme: DesignSystem.lightTheme,
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () async => result.add(await showResumeSubscriptionPrompt(ctx)),
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
    return result;
  }

  testWidgets('shows the title, resume and back actions', (tester) async {
    await openPrompt(tester);

    expect(find.text(S.current.resumeSubscriptionTitle), findsOneWidget);
    expect(find.text(S.current.resumeBtn), findsOneWidget);
    expect(find.text(S.current.back), findsOneWidget);
    verifyNever(subscriptionStore.resumeSubscription());
  });

  testWidgets('back dismisses with false and never resumes', (tester) async {
    final result = await openPrompt(tester);

    await tester.tap(find.text(S.current.back));
    await tester.pumpAndSettle();

    expect(result, [false]);
    verifyNever(subscriptionStore.resumeSubscription());
    verifyNever(
      analyticsStore.logSubscriptionResumeStarted(
        subscriptionId: anyNamed('subscriptionId'),
        pauseEndDate: anyNamed('pauseEndDate'),
      ),
    );
  });

  testWidgets('resume logs started + completed, toasts and pops true', (tester) async {
    when(subscriptionStore.resumeSubscription()).thenAnswer((_) async {
      when(subscriptionStore.subscriptionFuture).thenAnswer((_) => ObservableFuture.value(resumed));
    });

    final result = await openPrompt(tester);

    await tester.tap(find.text(S.current.resumeBtn));
    await tester.pumpAndSettle();

    verify(
      analyticsStore.logSubscriptionResumeStarted(
        subscriptionId: 'sub-1',
        pauseEndDate: paused.pausedUntil!.toIso8601String(),
      ),
    ).called(1);
    verify(subscriptionStore.resumeSubscription()).called(1);
    // The before/after snapshots come from Subscription.analyticsStatus.
    verify(
      analyticsStore.logSubscriptionResumeCompleted(
        subscriptionId: 'sub-1',
        subscriptionStatusBefore: 'paused',
        subscriptionStatusAfter: 'active',
        billingResumeDate: resumed.activeUntil!.toIso8601String(),
      ),
    ).called(1);
    expect(find.text(S.current.subscriptionResumed), findsOneWidget);
    expect(result, [true]);
  });

  testWidgets('a failed resume keeps the dialog open, toasts and logs failed', (tester) async {
    when(subscriptionStore.resumeSubscription()).thenThrow(Exception('network'));

    final result = await openPrompt(tester);

    await tester.tap(find.text(S.current.resumeBtn));
    await tester.pumpAndSettle();

    verify(
      analyticsStore.logSubscriptionResumeFailed(
        subscriptionId: 'sub-1',
        failureReason: anyNamed('failureReason'),
      ),
    ).called(1);
    verifyNever(
      analyticsStore.logSubscriptionResumeCompleted(
        subscriptionId: anyNamed('subscriptionId'),
        subscriptionStatusBefore: anyNamed('subscriptionStatusBefore'),
        subscriptionStatusAfter: anyNamed('subscriptionStatusAfter'),
        billingResumeDate: anyNamed('billingResumeDate'),
      ),
    );
    expect(find.text(S.current.resumeSubscriptionFailed), findsOneWidget);
    // Retry-friendly: still open, nothing popped, and the button is live again.
    expect(find.text(S.current.resumeSubscriptionTitle), findsOneWidget);
    expect(result, isEmpty);
    final button = tester.widget<ButtonPrimary>(find.byType(ButtonPrimary));
    expect(button.onPressed, isNotNull);
    expect(button.loading, isNull);
  });

  testWidgets('a retry after a failure resumes successfully', (tester) async {
    when(subscriptionStore.resumeSubscription()).thenThrow(Exception('network'));
    final result = await openPrompt(tester);

    await tester.tap(find.text(S.current.resumeBtn));
    await tester.pumpAndSettle();

    when(subscriptionStore.resumeSubscription()).thenAnswer((_) async {
      when(subscriptionStore.subscriptionFuture).thenAnswer((_) => ObservableFuture.value(resumed));
    });
    await tester.tap(find.text(S.current.resumeBtn));
    await tester.pumpAndSettle();

    verify(subscriptionStore.resumeSubscription()).called(2);
    expect(result, [true]);
  });

  testWidgets('while resuming the actions are disabled and the button spins', (tester) async {
    final gate = Completer<void>();
    when(subscriptionStore.resumeSubscription()).thenAnswer((_) => gate.future);

    await openPrompt(tester);
    await tester.tap(find.text(S.current.resumeBtn));
    await tester.pump();

    final button = tester.widget<ButtonPrimary>(find.byType(ButtonPrimary));
    expect(button.onPressed, isNull);
    expect(button.loading, isNotNull);
    expect(tester.widget<ButtonTertiary>(find.byType(ButtonTertiary)).onPressed, isNull);

    gate.complete();
    await tester.pumpAndSettle();
  });

  testWidgets('a second tap while resuming does not resume twice', (tester) async {
    final gate = Completer<void>();
    when(subscriptionStore.resumeSubscription()).thenAnswer((_) => gate.future);

    await openPrompt(tester);
    await tester.tap(find.text(S.current.resumeBtn));
    await tester.pump();
    await tester.tap(find.text(S.current.resumeBtn), warnIfMissed: false);
    await tester.pump();

    verify(subscriptionStore.resumeSubscription()).called(1);

    gate.complete();
    await tester.pumpAndSettle();
  });

  testWidgets('falls back to a paused status when no subscription is loaded', (tester) async {
    when(
      subscriptionStore.subscriptionFuture,
    ).thenAnswer((_) => ObservableFuture(Completer<Subscription>().future));
    when(subscriptionStore.resumeSubscription()).thenAnswer((_) async {});

    await openPrompt(tester);
    await tester.tap(find.text(S.current.resumeBtn));
    await tester.pumpAndSettle();

    verify(analyticsStore.logSubscriptionResumeStarted(subscriptionId: '')).called(1);
    verify(
      analyticsStore.logSubscriptionResumeCompleted(
        subscriptionId: '',
        subscriptionStatusBefore: 'paused',
        subscriptionStatusAfter: 'active',
      ),
    ).called(1);
  });
}
