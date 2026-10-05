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
import 'push_notifications_dialog_test.mocks.dart';

@GenerateNiceMocks([MockSpec<UserPreferencesStore>(), MockSpec<AnalyticsStore>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockUserPreferencesStore userPreferencesStore;
  late MockAnalyticsStore analyticsStore;

  setUp(() {
    userPreferencesStore = MockUserPreferencesStore();
    analyticsStore = MockAnalyticsStore();
    when(analyticsStore.logPushNotificationsPromptShown()).thenAnswer((_) async {});
    when(
      analyticsStore.logPushNotificationsPromptDecision(accepted: anyNamed('accepted')),
    ).thenAnswer((_) async {});
    when(
      userPreferencesStore.setPushNotificationsShown(userAllowed: anyNamed('userAllowed')),
    ).thenAnswer((_) async {});
    when(userPreferencesStore.markPushPromptShown()).thenAnswer((_) async {});
  });

  /// Opens the prompt via [showPushNotificationsPermissionDialog].
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
                onPressed: () => showPushNotificationsPermissionDialog(ctx),
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

  testWidgets('opening the prompt logs the impression and starts the cooldown', (tester) async {
    await openDialog(tester);

    expect(find.text(S.current.pushNotificationsConsentPopupTitle), findsOneWidget);
    verify(analyticsStore.logPushNotificationsPromptShown()).called(1);
    verify(userPreferencesStore.markPushPromptShown()).called(1);
  });

  testWidgets('allowing records the prompt as shown with consent', (tester) async {
    await openDialog(tester);

    await tester.tap(find.text(S.current.allowPushNotificationsBtn));
    await tester.pumpAndSettle();

    verify(userPreferencesStore.setPushNotificationsShown(userAllowed: true)).called(1);
    verify(analyticsStore.logPushNotificationsPromptDecision(accepted: true)).called(1);
  });

  testWidgets('declining records the prompt as shown without consent', (tester) async {
    await openDialog(tester);

    await tester.tap(find.text(S.current.notNowBtn));
    await tester.pumpAndSettle();

    verify(userPreferencesStore.setPushNotificationsShown(userAllowed: false)).called(1);
    verify(analyticsStore.logPushNotificationsPromptDecision(accepted: false)).called(1);
  });

  testWidgets('a second press while in flight is ignored and pops only the prompt', (tester) async {
    final gate = Completer<void>();
    when(
      userPreferencesStore.setPushNotificationsShown(userAllowed: anyNamed('userAllowed')),
    ).thenAnswer((_) => gate.future);

    await openDialog(tester);

    await tester.tap(find.text(S.current.allowPushNotificationsBtn));
    await tester.pump();
    await tester.tap(find.text(S.current.notNowBtn));
    await tester.pump();

    gate.complete();
    await tester.pumpAndSettle();

    verify(userPreferencesStore.setPushNotificationsShown(userAllowed: true)).called(1);
    verifyNever(userPreferencesStore.setPushNotificationsShown(userAllowed: false));
    expect(find.text(S.current.pushNotificationsConsentPopupTitle), findsNothing);
    expect(find.text('open'), findsOneWidget);
  });

  testWidgets('still closes when the decision throws', (tester) async {
    when(
      userPreferencesStore.setPushNotificationsShown(userAllowed: anyNamed('userAllowed')),
    ).thenThrow(Exception('boom'));

    await openDialog(tester);
    await tester.tap(find.text(S.current.allowPushNotificationsBtn));
    await tester.pumpAndSettle();

    expect(find.text(S.current.pushNotificationsConsentPopupTitle), findsNothing);
  });

  testWidgets('dismissing without choosing logs no decision', (tester) async {
    await openDialog(tester);

    await tester.tapAt(const Offset(5, 5));
    await tester.pumpAndSettle();

    expect(find.text(S.current.pushNotificationsConsentPopupTitle), findsNothing);
    verifyNever(analyticsStore.logPushNotificationsPromptDecision(accepted: anyNamed('accepted')));
    verifyNever(
      userPreferencesStore.setPushNotificationsShown(userAllowed: anyNamed('userAllowed')),
    );
  });
}
