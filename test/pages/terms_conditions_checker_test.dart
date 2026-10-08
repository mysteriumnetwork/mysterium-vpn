import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/models/terms_conditions.dart';
import 'package:mysterium_vpn/pages/static/ft_checkers/terms_conditions_checker.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../stores/smart_refresh_store_test.mocks.dart';
import '../support/test_localizations.dart';

class _BuildProbe extends StatelessWidget {
  const _BuildProbe();

  static int builds = 0;

  @override
  Widget build(BuildContext context) {
    builds++;
    return const Text('home');
  }
}

void main() {
  late MockTermsConditionsStore store;

  setUp(() {
    _BuildProbe.builds = 0;
    store = MockTermsConditionsStore();
    when(store.requiresTermsConditionsApproval).thenReturn(false);
    when(store.failure).thenReturn(null);
    when(store.isLoading).thenReturn(false);
    when(store.latestTermsConditions).thenReturn(null);
    when(store.acceptTermsConditions()).thenAnswer((_) async {});
    when(store.checkForUpdatedTermsConditions()).thenAnswer((_) async {});
  });

  Future<void> pumpChecker(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [termsConditionsStorePOD.overrideWithValue(store)],
        child: MaterialApp(
          theme: DesignSystem.lightTheme,
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          home: const TermsConditionsChecker(child: _BuildProbe()),
        ),
      ),
    );
  }

  void stubGate({TermsConditionsFailureType? failure, bool isLoading = false, String html = ''}) {
    when(store.requiresTermsConditionsApproval).thenReturn(true);
    when(store.failure).thenReturn(failure);
    when(store.isLoading).thenReturn(isLoading);
    when(
      store.latestTermsConditions,
    ).thenReturn(html.isEmpty ? null : TermsAndConditions(content: html, version: '2'));
  }

  testWidgets('shows the child when approval is not required', (tester) async {
    await pumpChecker(tester);

    expect(find.text('home'), findsOneWidget);
    expect(find.text('Accept'), findsNothing);
    expect(_BuildProbe.builds, greaterThan(0));
  });

  testWidgets('hides the child and shows the gate when approval is required', (tester) async {
    stubGate();
    await pumpChecker(tester);

    expect(find.text('home'), findsNothing);
    expect(_BuildProbe.builds, 0);
    expect(find.text('Accept'), findsOneWidget);
    expect(find.text('Our Terms & Conditions have changed'), findsOneWidget);
  });

  testWidgets('Accept shows loading while the save is in flight', (tester) async {
    stubGate(isLoading: true);
    await pumpChecker(tester);

    expect(tester.widget<ButtonPrimary>(find.byType(ButtonPrimary)).loading, isA<ButtonLoading>());
  });

  testWidgets('Retry on a load failure checks terms again', (tester) async {
    stubGate(failure: TermsConditionsFailureType.loading);
    await pumpChecker(tester);

    expect(find.text(S.current.termsConditionsLoadFailureTitle), findsOneWidget);

    await tester.tap(find.text(S.current.retryBtn));
    await tester.pump();

    verify(store.checkForUpdatedTermsConditions()).called(1);
    verifyNever(store.acceptTermsConditions());
  });

  testWidgets('Retry on a save failure accepts again', (tester) async {
    stubGate(failure: TermsConditionsFailureType.saving);
    await pumpChecker(tester);

    expect(find.text(S.current.termsConditionsSaveFailureTitle), findsOneWidget);

    await tester.tap(find.text(S.current.retryBtn));
    await tester.pump();

    verify(store.acceptTermsConditions()).called(1);
    verifyNever(store.checkForUpdatedTermsConditions());
  });
}
