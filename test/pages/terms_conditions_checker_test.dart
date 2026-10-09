import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/models/terms_conditions.dart';
import 'package:mysterium_vpn/pages/static/ft_checkers/terms_conditions_checker.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/terms_conditions_store.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../support/test_localizations.dart';
import 'terms_conditions_checker_test.mocks.dart';

@GenerateNiceMocks([MockSpec<TermsConditionsStore>()])
void main() {
  late MockTermsConditionsStore store;

  // Nice mocks already default the getters to false/null and the futures to
  // Future.value(), so only the gate-specific stubs below are set.
  setUp(() => store = MockTermsConditionsStore());

  Future<void> pumpChecker(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [termsConditionsStorePOD.overrideWithValue(store)],
        child: MaterialApp(
          theme: DesignSystem.lightTheme,
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          home: const TermsConditionsChecker(child: Text('home')),
        ),
      ),
    );
  }

  void stubGate({
    TermsConditionsFailureType? failure,
    bool isLoading = false,
    bool isAccepting = false,
    String html = '',
  }) {
    when(store.requiresTermsConditionsApproval).thenReturn(true);
    when(store.failure).thenReturn(failure);
    when(store.isLoading).thenReturn(isLoading);
    when(store.isAccepting).thenReturn(isAccepting);
    when(
      store.latestTermsConditions,
    ).thenReturn(html.isEmpty ? null : TermsAndConditions(content: html, version: '2'));
  }

  testWidgets('shows the child when approval is not required', (tester) async {
    await pumpChecker(tester);

    expect(find.text('home'), findsOneWidget);
    expect(find.text(S.current.termsConditionsAcceptBtn), findsNothing);
  });

  testWidgets('hides the child and shows the gate when approval is required', (tester) async {
    stubGate(html: '<p>terms</p>');
    await pumpChecker(tester);

    expect(find.text('home'), findsNothing);
    expect(find.text(S.current.termsConditionsAcceptBtn), findsOneWidget);
    expect(find.text(S.current.termsConditionsUpdatedTitle), findsOneWidget);
    expect(find.text(S.current.termsConditionsUpdatedSubtitle), findsOneWidget);
  });

  testWidgets('Accept submits the acceptance', (tester) async {
    stubGate(html: '<p>terms</p>');
    await pumpChecker(tester);

    await tester.tap(find.text(S.current.termsConditionsAcceptBtn));
    await tester.pump();

    verify(store.acceptTermsConditions()).called(1);
  });

  testWidgets('Accept shows loading while the save is in flight', (tester) async {
    stubGate(html: '<p>terms</p>', isAccepting: true);
    await pumpChecker(tester);

    final button = tester.widget<ButtonPrimary>(find.byType(ButtonPrimary));
    expect(button.loading, ButtonLoading(text: S.current.termsConditionsAcceptingBtn));
    expect(button.onPressed, isNotNull);
  });

  testWidgets('shows a loading panel while the terms are being fetched', (tester) async {
    stubGate(isLoading: true);
    await pumpChecker(tester);

    expect(find.text(S.current.termsConditionsLoading), findsOneWidget);
    expect(find.byType(LoadingIndicator), findsOneWidget);
  });

  testWidgets('Accept is disabled and reports the content load', (tester) async {
    stubGate(isLoading: true);
    await pumpChecker(tester);

    final button = tester.widget<ButtonPrimary>(find.byType(ButtonPrimary));
    expect(button.onPressed, isNull);
    expect(button.loading, ButtonLoading(text: S.current.termsConditionsLoadingBtn));
  });

  // A resume triggers a re-check; that must not read as "Accepting", and must
  // not leave a silently dead button either.
  testWidgets('a background re-check says it is checking, not loading', (tester) async {
    stubGate(html: '<p>terms</p>', isLoading: true);
    await pumpChecker(tester);

    final button = tester.widget<ButtonPrimary>(find.byType(ButtonPrimary));
    expect(button.onPressed, isNull);
    expect(button.loading, ButtonLoading(text: S.current.termsConditionsCheckingBtn));
    // The terms stay on screen, so this is a refresh and not a first load.
    expect(find.text(S.current.termsConditionsLoading), findsNothing);
  });

  testWidgets('Accept is idle once the terms are loaded', (tester) async {
    stubGate(html: '<p>terms</p>');
    await pumpChecker(tester);

    final button = tester.widget<ButtonPrimary>(find.byType(ButtonPrimary));
    expect(button.loading, isNull);
    expect(button.onPressed, isNotNull);
  });

  // Layout is driven by frame width, not by the host platform, so the two
  // Figma frames must resolve to different content widths.
  testWidgets('the desktop frame caps content at the design width', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1040, 699);
    addTearDown(tester.view.reset);

    stubGate(html: '<p>terms</p>');
    await pumpChecker(tester);

    final panel = tester.getSize(
      find.ancestor(of: find.byType(HtmlWidget), matching: find.byType(DecoratedBox)).first,
    );
    expect(panel.width, 680);
  });

  testWidgets('the document panel fills the width while loading', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(375, 812);
    addTearDown(tester.view.reset);

    stubGate(isLoading: true);
    await pumpChecker(tester);

    final panel = tester.getSize(
      find.ancestor(of: find.byType(LoadingIndicator), matching: find.byType(DecoratedBox)).first,
    );
    expect(panel.width, 375 - 32);
  });

  // Figma frames: mobile 375x812, desktop 1040x699. A RenderFlex overflow
  // throws in a widget test, so rendering at these sizes is the check.
  for (final (name, size) in const [('mobile', Size(375, 812)), ('desktop', Size(1040, 699))]) {
    testWidgets('renders the gate at the $name frame size', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.reset);

      stubGate(html: '<p>${'terms ' * 400}</p>');
      await pumpChecker(tester);

      expect(find.text(S.current.termsConditionsUpdatedTitle), findsOneWidget);
      expect(find.text(S.current.termsConditionsAcceptBtn), findsOneWidget);
    });

    testWidgets('renders the load failure at the $name frame size', (tester) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = size;
      addTearDown(tester.view.reset);

      stubGate(failure: TermsConditionsFailureType.loading);
      await pumpChecker(tester);

      expect(find.text(S.current.termsConditionsLoadFailureTitle), findsOneWidget);
    });
  }

  testWidgets('Retry on a load failure checks terms again', (tester) async {
    stubGate(failure: TermsConditionsFailureType.loading);
    await pumpChecker(tester);

    expect(find.text(S.current.termsConditionsLoadFailureTitle), findsOneWidget);
    expect(find.byType(ButtonPrimary), findsNothing);

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
