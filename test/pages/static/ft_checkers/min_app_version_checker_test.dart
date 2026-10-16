import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/pages/static/ft_checkers/min_app_version_checker.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../../../support/test_localizations.dart';
import 'min_app_version_checker_test.mocks.dart';

@GenerateNiceMocks([MockSpec<RemoteConfigStore>()])
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockRemoteConfigStore config;

  // Env.init() never runs under `flutter test`, so the build version is the
  // BuildInfo default. Everything below is relative to it.
  final currentVersion = Env.buildInfo.buildVersion;

  setUp(() => config = MockRemoteConfigStore());

  /// Pins the platform rather than reading the host's: CI runs this suite on
  /// Linux, which ships no minimum and so could never render the wall.
  Future<void> pumpChecker(WidgetTester tester, {required String minVersion}) async {
    when(config.minMacosBuildNumber).thenReturn(minVersion);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [remoteConfigStorePOD.overrideWithValue(config)],
        // `builder`, not `home`: in production FTCheckers is mounted in
        // MaterialApp.router's builder, i.e. ABOVE the router's Navigator. The
        // wall must render there, so the test mounts it the same way.
        child: MaterialApp(
          theme: DesignSystem.lightTheme,
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          builder: (context, _) => Builder(
            builder: (inner) {
              expect(Navigator.maybeOf(inner), isNull);
              return const MinAppVersionChecker(
                operatingSystem: 'macos',
                child: Text('app content'),
              );
            },
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  group('MinAppVersionChecker', () {
    testWidgets('renders the app when the build is not behind the minimum', (tester) async {
      await pumpChecker(tester, minVersion: currentVersion);

      expect(find.text('app content'), findsOneWidget);
      expect(find.text(S.current.updateRequiredTitle), findsNothing);
    });

    testWidgets('blocks the app when the build is behind the minimum', (tester) async {
      await pumpChecker(tester, minVersion: '99.0.0');

      expect(find.text('app content'), findsNothing);
      expect(find.text(S.current.updateRequiredTitle), findsOneWidget);
    });

    testWidgets('states why it blocked and both versions involved', (tester) async {
      await pumpChecker(tester, minVersion: '99.0.0');

      expect(find.text(S.current.featureToggleMinVersionNotSatisfied), findsOneWidget);
      expect(find.text(S.current.updateCurrentVersionLbl), findsOneWidget);
      expect(find.text(currentVersion), findsOneWidget);
      expect(find.text(S.current.updateRequiredVersionLbl), findsOneWidget);
      expect(find.text('99.0.0'), findsOneWidget);
    });

    testWidgets('offers the update action and no way to dismiss the wall', (tester) async {
      await pumpChecker(tester, minVersion: '99.0.0');

      expect(find.widgetWithText(ButtonPrimary, S.current.buttonUpdateApp), findsOneWidget);
      // The wall is mandatory: nothing on it closes, skips or goes back. The
      // app subtree is discarded while it shows, so there is also no route
      // underneath to return to.
      expect(find.byIcon(UntitledUI.x_close), findsNothing);
      expect(find.byType(BackButton), findsNothing);
      expect(find.byIcon(UntitledUI.arrow_left), findsNothing);
    });
  });

  group('getMinAppBuildNumber', () {
    setUp(() {
      when(config.minAndroidBuildNumber).thenReturn('1.0.0');
      when(config.minIosBuildNumber).thenReturn('2.0.0');
      when(config.minMacosBuildNumber).thenReturn('3.0.0');
      when(config.minWindowsStandAloneBuildNumber).thenReturn('4.0.0');
    });

    String resolveFor(String os) => MinAppVersionChecker(
      operatingSystem: os,
      child: const SizedBox.shrink(),
    ).getMinAppBuildNumber(remoteConfigStore: config);

    test('maps each gated platform to its own remote-config key', () {
      expect(resolveFor('android'), '1.0.0');
      expect(resolveFor('ios'), '2.0.0');
      expect(resolveFor('macos'), '3.0.0');
      expect(resolveFor('windows'), '4.0.0');
    });

    test('never gates a platform without a minimum, so Linux resolves to 0', () {
      expect(resolveFor('linux'), '0');
      expect(resolveFor('fuchsia'), '0');
    });
  });
}
