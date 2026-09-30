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
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../../support/test_localizations.dart';
import 'marketing_consent_dialog_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UserPreferencesStore>(), MockSpec<AnalyticsStore>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockUserPreferencesStore userPreferencesStore;
  late MockAnalyticsStore analyticsStore;

  setUp(() {
    userPreferencesStore = MockUserPreferencesStore();
    analyticsStore = MockAnalyticsStore();
    when(analyticsStore.logMarketingConsentPromptShown()).thenAnswer((_) async {});
    when(
      userPreferencesStore.updateMarketingConsentFuture,
    ).thenAnswer((_) => ObservableFuture.value(null));
    when(
      userPreferencesStore.updateMarketingContact(
        consent: anyNamed('consent'),
        fromPopup: anyNamed('fromPopup'),
      ),
    ).thenAnswer((_) async {});
  });

  /// Opens the consent prompt via [showMarketingConsentDialog].
  Future<void> openDialog(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          userPreferencesStorePOD.overrideWithValue(userPreferencesStore),
          analyticsStorePOD.overrideWithValue(analyticsStore),
        ],
        child: MaterialApp(
          theme: DesignSystem.lightTheme,
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (ctx) => ElevatedButton(
                onPressed: () => showMarketingConsentDialog(ctx),
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

  testWidgets('logs the impression when the consent prompt opens', (tester) async {
    await openDialog(tester);

    expect(find.text(S.current.marketingConsentPopupTitle), findsOneWidget);
    verify(analyticsStore.logMarketingConsentPromptShown()).called(1);
  });

  testWidgets('accepting sends consent from the popup', (tester) async {
    await openDialog(tester);

    await tester.tap(find.text(S.current.allowNotificationsBtn));
    await tester.pumpAndSettle();

    verify(userPreferencesStore.updateMarketingContact(consent: true, fromPopup: true)).called(1);
  });

  testWidgets('declining sends refusal from the popup', (tester) async {
    await openDialog(tester);

    await tester.tap(find.text(S.current.notNowBtn));
    await tester.pumpAndSettle();

    verify(userPreferencesStore.updateMarketingContact(consent: false, fromPopup: true)).called(1);
  });
}
