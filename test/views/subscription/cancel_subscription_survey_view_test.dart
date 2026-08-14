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

  testWidgets('shows title, continue, skip, and other reason', (tester) async {
    await pumpSurvey(tester);

    expect(find.text('${S.current.cancelSurveyTitle} (${S.current.optional})'), findsOneWidget);
    expect(find.text(S.current.continueBtn), findsOneWidget);
    expect(find.text(S.current.skipBtn), findsOneWidget);
    expect(find.text(S.current.otherReason), findsOneWidget);
  });

  testWidgets('tap other shows feedback field', (tester) async {
    // arrange
    await pumpSurvey(tester);

    // act
    await tester.tap(find.text(S.current.otherReason));
    await tester.pump();

    // assert
    expect(find.byType(TextField), findsOneWidget);
  });

  testWidgets('uncheck other hides feedback field', (tester) async {
    // arrange
    await pumpSurvey(tester);

    // act
    await tester.tap(find.text(S.current.otherReason));
    await tester.pump();
    await tester.tap(find.text(S.current.otherReason));
    await tester.pump();

    // assert
    expect(find.byType(TextField), findsNothing);
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

  testWidgets('continue with a reason submits those reasons', (tester) async {
    // arrange
    when(
      cancelStore.setSurvey(reasons: anyNamed('reasons'), feedback: anyNamed('feedback')),
    ).thenAnswer((_) async => true);
    await pumpSurvey(tester);

    // act
    await tester.tap(find.text(S.current.otherReason));
    await tester.pump();
    await tester.tap(find.byType(ButtonPrimary));
    await tester.pumpAndSettle();

    // assert
    verify(cancelStore.setSurvey(reasons: {kCancelReasonOther}, feedback: '')).called(1);
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
}
