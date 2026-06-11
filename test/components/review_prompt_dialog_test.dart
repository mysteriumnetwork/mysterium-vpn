import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/generated/codegen_loader.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'review_prompt_dialog_test.mocks.dart';

@GenerateNiceMocks([MockSpec<ReviewPromptStore>(), MockSpec<AnalyticsStore>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockReviewPromptStore store;
  late MockAnalyticsStore analytics;

  const inAppReviewChannel = MethodChannel('dev.britannio.in_app_review');

  setUp(() {
    store = MockReviewPromptStore();
    analytics = MockAnalyticsStore();
    SharedPreferences.setMockInitialValues({});
    // Keep the native-review side effect silent so the "Leave a review" path
    // doesn't hit a real platform channel.
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      inAppReviewChannel,
      (call) async => call.method == 'isAvailable' ? true : null,
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      inAppReviewChannel,
      null,
    );
  });

  /// Pumps a minimal app, overrides the review-prompt + analytics stores with
  /// mocks, and opens the flow via [showReviewPromptDialog].
  Future<void> openFlow(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          reviewPromptStorePOD.overrideWithValue(store),
          analyticsStorePOD.overrideWithValue(analytics),
        ],
        child: EasyLocalization(
          supportedLocales: const [Locale('en')],
          path: 'resources/langs',
          fallbackLocale: const Locale('en'),
          startLocale: const Locale('en'),
          useOnlyLangCode: true,
          assetLoader: const CodegenLoader(),
          child: Builder(
            builder: (ctx) => MaterialApp(
              theme: DesignSystem.lightTheme,
              locale: EasyLocalization.of(ctx)?.locale,
              localizationsDelegates: EasyLocalization.of(ctx)?.delegates,
              supportedLocales: EasyLocalization.of(ctx)?.supportedLocales ?? const [Locale('en')],
              home: Scaffold(
                body: Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () => showReviewPromptDialog(context),
                    child: const Text('open'),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('records the display and shows the Yes/No satisfaction modal', (tester) async {
    await openFlow(tester);
    verify(store.onShown()).called(1);
    expect(find.byIcon(UntitledUI.thumbs_up), findsOneWidget); // Yes
    expect(find.byIcon(UntitledUI.thumbs_down), findsOneWidget); // No
  });

  testWidgets('Yes records the positive click and opens the positive modal', (tester) async {
    await openFlow(tester);
    await tester.tap(find.byIcon(UntitledUI.thumbs_up));
    await tester.pumpAndSettle();
    verify(store.onSatisfactionYes()).called(1);
    // Positive modal: a primary "Leave a review" button and no thumbs-down.
    expect(find.byType(ButtonPrimary), findsOneWidget);
    expect(find.byIcon(UntitledUI.thumbs_down), findsNothing);
  });

  testWidgets('No records the negative click', (tester) async {
    await openFlow(tester);
    await tester.tap(find.byIcon(UntitledUI.thumbs_down));
    await tester.pumpAndSettle();
    verify(store.onSatisfactionNo()).called(1);
  });

  testWidgets('closing the satisfaction modal dismisses', (tester) async {
    await openFlow(tester);
    await tester.tap(find.byIcon(UntitledUI.x_close));
    await tester.pumpAndSettle();
    verify(store.onDismiss()).called(1);
  });

  testWidgets('positive modal: Not now dismisses', (tester) async {
    await openFlow(tester);
    await tester.tap(find.byIcon(UntitledUI.thumbs_up)); // Yes → positive modal
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ButtonSecondary)); // Not now (the only secondary button)
    await tester.pumpAndSettle();
    verify(store.onDismiss()).called(1);
  });

  testWidgets('positive modal: Leave a review opens the native review', (tester) async {
    await openFlow(tester);
    await tester.tap(find.byIcon(UntitledUI.thumbs_up)); // Yes → positive modal
    await tester.pumpAndSettle();
    await tester.tap(find.byType(ButtonPrimary)); // Leave a review
    await tester.pumpAndSettle();
    verify(store.onLeaveReview()).called(1);
  });
}
