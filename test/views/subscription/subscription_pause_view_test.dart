import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart' hide when;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/components/dialogs/dialogs.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/subscription_cancellation_store.dart';
import 'package:mysterium_vpn/views/subscription/subscription_pause_view.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../../support/test_localizations.dart';
import 'subscription_pause_view_test.mocks.dart';

@GenerateNiceMocks([MockSpec<SubscriptionCancellationStore>(), MockSpec<AnalyticsStore>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSubscriptionCancellationStore cancelStore;
  late MockAnalyticsStore analyticsStore;

  setUp(() {
    cancelStore = MockSubscriptionCancellationStore();
    analyticsStore = MockAnalyticsStore();
    when(cancelStore.isProcessing).thenReturn(false);
    when(cancelStore.availablePauseDurations).thenReturn(ObservableList.of(['1m', '3m', '6m']));
    when(cancelStore.isStoreSubscription()).thenReturn(false);
    when(cancelStore.pauseSubscription(any)).thenAnswer((_) async => true);
    when(cancelStore.currentSubscriptionId()).thenReturn('sub-1');
    when(analyticsStore.logCancellationPauseOfferViewed()).thenAnswer((_) async {});
    when(
      analyticsStore.logCancellationPauseDeclined(subscriptionId: anyNamed('subscriptionId')),
    ).thenAnswer((_) async {});
  });

  /// Opens the pause offer as a modal so Back / × can dismiss it.
  Future<void> pumpPauseView(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          subscriptionCancellationStorePOD.overrideWithValue(cancelStore),
          analyticsStorePOD.overrideWithValue(analyticsStore),
        ],
        child: MaterialApp(
          theme: DesignSystem.lightTheme,
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => showSubscriptionPauseDialog(context),
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

  testWidgets('shows title, durations, pause, continue, and logs viewed', (tester) async {
    // arrange
    await pumpPauseView(tester);

    // act
    await tester.pump();

    // assert
    expect(find.text(S.current.notReadyToCancelTitle), findsOneWidget);
    expect(find.text(S.current.pauseSubscriptionBtn), findsOneWidget);
    expect(find.text(S.current.continueToCancelBtn), findsOneWidget);
    expect(find.text(S.current.pauseSubscriptionInfoDesc), findsOneWidget);
    expect(find.text(S.current.pauseForMonths(1)), findsOneWidget);
    expect(find.text(S.current.pauseForMonths(3)), findsOneWidget);
    expect(find.text(S.current.pauseForMonths(6)), findsOneWidget);
    verify(analyticsStore.logCancellationPauseOfferViewed()).called(1);
    verify(cancelStore.markPauseOfferShown()).called(1);
  });

  testWidgets('disables pause until a duration is selected', (tester) async {
    // arrange
    await pumpPauseView(tester);

    // act
    final button = tester.widget<ButtonPrimary>(find.byType(ButtonPrimary));

    // assert
    expect(button.onPressed, isNull);
  });

  testWidgets('selecting a duration enables pause', (tester) async {
    // arrange
    await pumpPauseView(tester);

    // act
    await tester.tap(find.text(S.current.pauseForMonths(1)));
    await tester.pump();

    // assert
    final button = tester.widget<ButtonPrimary>(find.byType(ButtonPrimary));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('close resets and pops', (tester) async {
    // arrange
    await pumpPauseView(tester);

    // act
    await tester.tap(find.byIcon(UntitledUI.x_close));
    await tester.pumpAndSettle();

    // assert
    verify(cancelStore.reset()).called(1);
    expect(find.byType(SubscriptionPauseView), findsNothing);
  });

  testWidgets('pause success dismisses after pausing the selected duration', (tester) async {
    // arrange
    await pumpPauseView(tester);

    // act
    await tester.tap(find.text(S.current.pauseForMonths(3)));
    await tester.pump();
    await tester.tap(find.byType(ButtonPrimary));
    await tester.pumpAndSettle();

    // assert
    verify(cancelStore.pauseSubscription('3m')).called(1);
    verify(cancelStore.reset()).called(1);
    expect(find.byType(SubscriptionPauseView), findsNothing);
  });

  testWidgets('pause failure shows a snackbar', (tester) async {
    // arrange
    when(cancelStore.pauseSubscription(any)).thenAnswer((_) async => false);
    await pumpPauseView(tester);

    // act
    await tester.tap(find.text(S.current.pauseForMonths(1)));
    await tester.pump();
    await tester.tap(find.byType(ButtonPrimary));
    await tester.pump();

    // assert
    expect(find.text(S.current.pauseSubscriptionFailed), findsOneWidget);
    expect(find.byType(SubscriptionPauseView), findsOneWidget);
    await tester.pump(const Duration(seconds: 4));
  });

  testWidgets('continue to cancel logs declined and shows the web prompt', (tester) async {
    // arrange
    await pumpPauseView(tester);

    // act
    await tester.tap(find.byType(ButtonTertiary));
    await tester.pumpAndSettle();

    // assert
    verify(analyticsStore.logCancellationPauseDeclined(subscriptionId: 'sub-1')).called(1);
    expect(find.byType(SubscriptionPauseView), findsNothing);
    expect(find.text(S.current.continueCancellationOnWebTitle), findsOneWidget);
  });
}
