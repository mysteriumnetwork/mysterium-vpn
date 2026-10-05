import 'dart:async';

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
    when(userPreferencesStore.setMarketingConsentShown()).thenAnswer((_) async {});
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

  testWidgets('opening the prompt logs the impression and records it as shown', (tester) async {
    await openDialog(tester);

    expect(find.text(S.current.marketingConsentPopupTitle), findsOneWidget);
    verify(analyticsStore.logMarketingConsentPromptShown()).called(1);
    verify(userPreferencesStore.setMarketingConsentShown()).called(1);
  });

  testWidgets('shows the prompt even when recording it as shown fails', (tester) async {
    when(userPreferencesStore.setMarketingConsentShown()).thenThrow(Exception('disk full'));

    await openDialog(tester);

    expect(find.text(S.current.marketingConsentPopupTitle), findsOneWidget);
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

  testWidgets('a second press while in flight is ignored and pops only the prompt', (tester) async {
    final gate = Completer<void>();
    when(
      userPreferencesStore.updateMarketingContact(
        consent: anyNamed('consent'),
        fromPopup: anyNamed('fromPopup'),
      ),
    ).thenAnswer((_) => gate.future);

    await openDialog(tester);

    await tester.tap(find.text(S.current.allowNotificationsBtn));
    await tester.pump();
    await tester.tap(find.text(S.current.notNowBtn));
    await tester.pump();

    gate.complete();
    await tester.pumpAndSettle();

    verify(userPreferencesStore.updateMarketingContact(consent: true, fromPopup: true)).called(1);
    verifyNever(userPreferencesStore.updateMarketingContact(consent: false, fromPopup: true));
    expect(find.text(S.current.marketingConsentPopupTitle), findsNothing);
    expect(find.text('open'), findsOneWidget);
  });

  testWidgets('cannot be dismissed while a choice is in flight', (tester) async {
    final gate = Completer<void>();
    when(
      userPreferencesStore.updateMarketingContact(
        consent: anyNamed('consent'),
        fromPopup: anyNamed('fromPopup'),
      ),
    ).thenAnswer((_) => gate.future);

    await openDialog(tester);
    await tester.tap(find.text(S.current.allowNotificationsBtn));
    await tester.pump();

    // Long enough for a dismiss animation to finish, but not pumpAndSettle:
    // the button spinner never settles while the request is pending.
    await tester.tapAt(const Offset(5, 5));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text(S.current.marketingConsentPopupTitle), findsOneWidget);

    gate.complete();
    await tester.pumpAndSettle();
    expect(find.text(S.current.marketingConsentPopupTitle), findsNothing);
  });

  testWidgets('closes when dismissed without choosing', (tester) async {
    await openDialog(tester);

    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();

    expect(find.text(S.current.marketingConsentPopupTitle), findsNothing);
    verifyNever(
      userPreferencesStore.updateMarketingContact(
        consent: anyNamed('consent'),
        fromPopup: anyNamed('fromPopup'),
      ),
    );
  });

  testWidgets('closes when the request fails', (tester) async {
    when(
      userPreferencesStore.updateMarketingContact(
        consent: anyNamed('consent'),
        fromPopup: anyNamed('fromPopup'),
      ),
    ).thenThrow(Exception('boom'));

    await openDialog(tester);

    await tester.tap(find.text(S.current.notNowBtn));
    await tester.pumpAndSettle();

    expect(find.text(S.current.marketingConsentPopupTitle), findsNothing);
  });
}
