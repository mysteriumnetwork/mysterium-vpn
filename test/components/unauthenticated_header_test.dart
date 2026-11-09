import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../support/test_localizations.dart';
import 'unauthenticated_header_test.mocks.dart';

@GenerateNiceMocks([MockSpec<AuthSessionStore>(), MockSpec<AnalyticsStore>()])
void main() {
  late MockAuthSessionStore authSession;
  late MockAnalyticsStore analytics;

  setUp(() {
    authSession = MockAuthSessionStore();
    analytics = MockAnalyticsStore();
  });

  Future<BeamerDelegate> pumpAt(
    WidgetTester tester, {
    required String path,
    required bool canBrowseApp,
  }) async {
    when(authSession.canBrowseApp).thenReturn(canBrowseApp);
    final delegate = BeamerDelegate(
      initialPath: path,
      locationBuilder: (routeInformation, _) => _AuthLocation(routeInformation),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          authSessionStorePOD.overrideWithValue(authSession),
          analyticsStorePOD.overrideWithValue(analytics),
        ],
        child: MaterialApp.router(
          theme: DesignSystem.lightTheme,
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          routerDelegate: delegate,
          routeInformationParser: BeamerParser(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return delegate;
  }

  final backButton = find.byIcon(UntitledUI.arrow_narrow_left);

  testWidgets('back on check-your-email returns to the login screen', (tester) async {
    final delegate = await pumpAt(tester, path: Routes.checkYourEmail.path, canBrowseApp: true);

    await tester.tap(backButton);
    await tester.pumpAndSettle();

    expect(delegate.configuration.uri.path, Routes.login.path);
  });

  testWidgets('back on the login screen closes the auth flow to home', (tester) async {
    final delegate = await pumpAt(tester, path: Routes.login.path, canBrowseApp: true);

    await tester.tap(backButton);
    await tester.pumpAndSettle();

    expect(delegate.configuration.uri.path, Routes.main.path);
  });

  testWidgets('check-your-email keeps its back button when the app cannot be browsed', (
    tester,
  ) async {
    final delegate = await pumpAt(tester, path: Routes.checkYourEmail.path, canBrowseApp: false);

    expect(backButton, findsOneWidget);

    await tester.tap(backButton);
    await tester.pumpAndSettle();

    expect(delegate.configuration.uri.path, Routes.login.path);
  });

  testWidgets('the login screen hides back when the app cannot be browsed', (tester) async {
    await pumpAt(tester, path: Routes.login.path, canBrowseApp: false);

    expect(backButton, findsNothing);
  });
}

class _AuthLocation extends BeamLocation<BeamState> {
  _AuthLocation(RouteInformation super.info);

  @override
  List<Pattern> get pathPatterns => [
    Routes.main.path,
    Routes.login.path,
    Routes.checkYourEmail.path,
  ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final path = state.uri.path;
    return [
      if (path.contains(Routes.main.path))
        const BeamPage(
          key: ValueKey('main'),
          name: '/main',
          child: Scaffold(body: SizedBox.shrink()),
        ),
      if (path.contains(Routes.login.path))
        const BeamPage(
          key: ValueKey('login'),
          name: '/login',
          child: Scaffold(body: UnauthenticatedHeader(backLabel: 'Home')),
        ),
      if (path.contains(Routes.checkYourEmail.path))
        const BeamPage(
          key: ValueKey('check-your-email'),
          name: '/login/check-your-email',
          child: Scaffold(body: UnauthenticatedHeader()),
        ),
    ];
  }
}
