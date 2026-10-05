import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/components/dialogs/dialogs.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/subscription_cancellation_store.dart';
import 'package:mysterium_vpn/views/subscription/cancel_subscription_survey_view.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../../support/test_localizations.dart';
import 'cancel_subscription_survey_view_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SubscriptionCancellationStore>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<RemoteConfigStore>(),
])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSubscriptionCancellationStore cancelStore;
  late MockAnalyticsStore analyticsStore;
  late MockRemoteConfigStore remoteConfigStore;

  setUp(() {
    cancelStore = MockSubscriptionCancellationStore();
    analyticsStore = MockAnalyticsStore();
    remoteConfigStore = MockRemoteConfigStore();
    when(remoteConfigStore.cancelSubscriptionReasonKeys).thenReturn(null);
    when(cancelStore.canPauseSubscription()).thenAnswer((_) async => false);
    when(cancelStore.isStoreSubscription()).thenReturn(false);
    when(
      cancelStore.setSurvey(reasons: anyNamed('reasons'), feedback: anyNamed('feedback')),
    ).thenAnswer((_) async => false);
    when(analyticsStore.logCancellationReasonSkipped()).thenAnswer((_) async {});
  });

  Future<void> pumpSurvey(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          subscriptionCancellationStorePOD.overrideWithValue(cancelStore),
          analyticsStorePOD.overrideWithValue(analyticsStore),
          remoteConfigStorePOD.overrideWithValue(remoteConfigStore),
        ],
        child: MaterialApp(
          theme: DesignSystem.lightTheme,
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showCancelSubscriptionSurveyDialog(context),
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

  testWidgets('shows title, continue, skip, other reason, and feedback field', (tester) async {
    await pumpSurvey(tester);

    expect(find.text('${S.current.cancelSurveyTitle} (${S.current.optional})'), findsOneWidget);
    expect(find.text(S.current.continueBtn), findsOneWidget);
    expect(find.text(S.current.skipBtn), findsOneWidget);
    expect(find.text(S.current.otherReason), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('typing feedback selects other; clearing keeps other selected', (tester) async {
    // arrange
    await pumpSurvey(tester);
    final otherCheckbox = find.descendant(
      of: find.widgetWithText(CheckboxItem, S.current.otherReason),
      matching: find.byType(Checkbox),
    );

    // act / assert — type selects Other
    await tester.enterText(find.byType(TextField), 'too expensive');
    await tester.pump();
    expect(tester.widget<Checkbox>(otherCheckbox).value, isTrue);

    // act / assert — clear keeps Other selected
    await tester.enterText(find.byType(TextField), '');
    await tester.pump();
    expect(tester.widget<Checkbox>(otherCheckbox).value, isTrue);
  });

  testWidgets('unchecking other clears feedback text', (tester) async {
    // arrange
    await pumpSurvey(tester);
    await tester.enterText(find.byType(TextField), 'too expensive');
    await tester.pump();

    // act
    await tester.tap(find.text(S.current.otherReason));
    await tester.pump();

    // assert
    expect(tester.widget<TextField>(find.byType(TextField)).controller?.text, isEmpty);
    expect(
      tester
          .widget<Checkbox>(
            find.descendant(
              of: find.widgetWithText(CheckboxItem, S.current.otherReason),
              matching: find.byType(Checkbox),
            ),
          )
          .value,
      isFalse,
    );
  });

  testWidgets('close resets and pops', (tester) async {
    // arrange
    await pumpSurvey(tester);

    // act
    await tester.tap(find.byIcon(UntitledUI.x_close));
    await tester.pumpAndSettle();

    // assert
    verify(cancelStore.reset()).called(1);
    expect(find.byType(CancelSubscriptionSurveyView), findsNothing);
  });

  testWidgets('skip logs skipped analytics and checks pause', (tester) async {
    // arrange
    await pumpSurvey(tester);

    // act
    await tester.tap(find.byType(ButtonTertiary));
    await tester.pumpAndSettle();

    // assert
    verify(analyticsStore.logCancellationReasonSkipped()).called(1);
    verify(cancelStore.canPauseSubscription()).called(1);
    verifyNever(
      cancelStore.setSurvey(reasons: anyNamed('reasons'), feedback: anyNamed('feedback')),
    );
  });

  testWidgets('continue with typed feedback submits other and feedback', (tester) async {
    // arrange
    when(
      cancelStore.setSurvey(reasons: anyNamed('reasons'), feedback: anyNamed('feedback')),
    ).thenAnswer((_) async => true);
    await pumpSurvey(tester);

    // act
    await tester.enterText(find.byType(TextField), 'too expensive');
    await tester.pump();
    await tester.tap(find.byType(ButtonPrimary));
    await tester.pumpAndSettle();

    // assert
    verify(
      cancelStore.setSurvey(reasons: {kCancelReasonOther}, feedback: 'too expensive'),
    ).called(1);
    verifyNever(analyticsStore.logCancellationReasonSkipped());
    verify(cancelStore.canPauseSubscription()).called(1);
  });

  testWidgets('continue with empty reasons is treated as skipped', (tester) async {
    // arrange
    await pumpSurvey(tester);

    // act
    await tester.tap(find.byType(ButtonPrimary));
    await tester.pumpAndSettle();

    // assert
    verify(cancelStore.setSurvey(reasons: <String>{}, feedback: '')).called(1);
    verify(analyticsStore.logCancellationReasonSkipped()).called(1);
    verify(cancelStore.canPauseSubscription()).called(1);
  });

  testWidgets('cannot be dismissed while an action is in flight', (tester) async {
    // arrange
    final gate = Completer<bool>();
    when(cancelStore.canPauseSubscription()).thenAnswer((_) => gate.future);
    await pumpSurvey(tester);

    // act — press Continue, then try to close while the fetch is pending
    await tester.tap(find.byType(ButtonPrimary));
    await tester.pump();
    await tester.tap(find.byIcon(UntitledUI.x_close));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    // assert — still here, so proceed()'s pop can't land on the page below
    expect(find.byType(CancelSubscriptionSurveyView), findsOneWidget);
    verifyNever(cancelStore.reset());

    gate.complete(false);
    await tester.pumpAndSettle();
    expect(find.text('open'), findsOneWidget);
  });

  testWidgets('skip spins the skip button, not continue', (tester) async {
    // arrange
    final gate = Completer<bool>();
    when(cancelStore.canPauseSubscription()).thenAnswer((_) => gate.future);
    await pumpSurvey(tester);

    // act
    await tester.tap(find.byType(ButtonTertiary));
    await tester.pump();

    // assert
    expect(tester.widget<ButtonTertiary>(find.byType(ButtonTertiary)).loading, isNotNull);
    expect(tester.widget<ButtonPrimary>(find.byType(ButtonPrimary)).loading, isNull);

    gate.complete(false);
    await tester.pumpAndSettle();
  });

  testWidgets('re-enables the footer when the submission throws', (tester) async {
    // arrange — proceed() awaits the subscription fetch, which can reject.
    // Real feedback so the submit path isn't itself counted as a skip.
    when(cancelStore.canPauseSubscription()).thenThrow(Exception('offline'));
    when(
      cancelStore.setSurvey(reasons: anyNamed('reasons'), feedback: anyNamed('feedback')),
    ).thenAnswer((_) async => true);
    await pumpSurvey(tester);
    await tester.enterText(find.byType(TextField), 'too expensive');
    await tester.pump();

    // act
    await tester.tap(find.byType(ButtonPrimary));
    await tester.pumpAndSettle();

    // assert — still on the survey, and skip works again
    expect(find.byType(CancelSubscriptionSurveyView), findsOneWidget);
    await tester.tap(find.byType(ButtonTertiary));
    await tester.pumpAndSettle();
    verify(analyticsStore.logCancellationReasonSkipped()).called(1);
  });

  testWidgets('ignores skip while a survey submission is in flight', (tester) async {
    // arrange
    final gate = Completer<bool>();
    when(
      cancelStore.setSurvey(reasons: anyNamed('reasons'), feedback: anyNamed('feedback')),
    ).thenAnswer((_) => gate.future);
    await pumpSurvey(tester);

    // act
    await tester.tap(find.byType(ButtonPrimary));
    await tester.pump();
    await tester.tap(find.byType(ButtonTertiary));
    await tester.pump();
    gate.complete(true);
    await tester.pumpAndSettle();

    // assert
    verifyNever(analyticsStore.logCancellationReasonSkipped());
    verify(cancelStore.canPauseSubscription()).called(1);
  });
}
