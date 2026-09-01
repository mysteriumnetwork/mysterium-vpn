import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/extensions/navigation_extensions.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';

import 'navigation_extensions_test.mocks.dart';

@GenerateNiceMocks([MockSpec<RemoteConfigStore>()])
void main() {
  late MockRemoteConfigStore remoteConfig;

  setUp(() {
    remoteConfig = MockRemoteConfigStore();
  });

  /// Pumps a Beamer app (starting at `/main`) and returns the delegate plus a
  /// context under the ProviderScope, with [remoteConfigStorePOD] overridden.
  Future<(BeamerDelegate, BuildContext)> pumpNav(WidgetTester tester) async {
    final delegate = BeamerDelegate(
      initialPath: '/main',
      locationBuilder: (routeInformation, _) => _TestLocation(routeInformation),
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [remoteConfigStorePOD.overrideWithValue(remoteConfig)],
        child: MaterialApp.router(routerDelegate: delegate, routeInformationParser: BeamerParser()),
      ),
    );
    await tester.pumpAndSettle();
    return (delegate, tester.element(find.byKey(const Key('probe'))));
  }

  group('navigateToUrl', () {
    testWidgets('ignores a News Center deep link when newsCenterEnabled is false', (tester) async {
      when(remoteConfig.newsCenterEnabled).thenReturn(false);
      final (delegate, context) = await pumpNav(tester);

      final handled = await delegate.navigateToUrl(
        url: '/main/news-center?id=1',
        isAuthenticated: true,
        context: context,
        accessToken: null,
      );
      await tester.pumpAndSettle();

      // Stayed on /main — the deep link was ignored.
      expect(handled, isFalse);
      expect(delegate.configuration.uri.path, '/main');
    });

    testWidgets('navigates to News Center when newsCenterEnabled is true', (tester) async {
      when(remoteConfig.newsCenterEnabled).thenReturn(true);
      final (delegate, context) = await pumpNav(tester);

      final handled = await delegate.navigateToUrl(
        url: '/main/news-center?id=1',
        isAuthenticated: true,
        context: context,
        accessToken: null,
      );
      await tester.pumpAndSettle();

      expect(handled, isTrue);
      expect(delegate.configuration.uri.path, '/main/news-center');
      expect(delegate.configuration.uri.queryParameters['id'], '1');
    });

    testWidgets('reports an unrecognised route as unhandled', (tester) async {
      final (delegate, context) = await pumpNav(tester);

      final handled = await delegate.navigateToUrl(
        url: '/not-a-route',
        isAuthenticated: true,
        context: context,
        accessToken: null,
      );
      await tester.pumpAndSettle();

      expect(handled, isFalse);
      expect(delegate.configuration.uri.path, '/main');
    });

    testWidgets('reports an authenticated-only route as unhandled when signed out', (tester) async {
      final (delegate, context) = await pumpNav(tester);

      final handled = await delegate.navigateToUrl(
        url: '/subscribe',
        isAuthenticated: false,
        context: context,
        accessToken: null,
      );
      await tester.pumpAndSettle();

      expect(handled, isFalse);
    });
  });

  group('openPushNotificationTarget', () {
    testWidgets('opens a valid deep link', (tester) async {
      when(remoteConfig.newsCenterEnabled).thenReturn(true);
      final (delegate, context) = await pumpNav(tester);

      await openPushNotificationTarget(
        deepLink: '/main/news-center?id=5',
        delegate: delegate,
        context: context,
        isAuthenticated: true,
        accessToken: null,
      );
      await tester.pumpAndSettle();

      expect(delegate.configuration.uri.path, '/main/news-center');
      expect(delegate.configuration.uri.queryParameters['id'], '5');
    });

    testWidgets('falls back to the inbox when the deep link is missing', (tester) async {
      when(remoteConfig.newsCenterEnabled).thenReturn(true);
      final (delegate, context) = await pumpNav(tester);

      await openPushNotificationTarget(
        deepLink: null,
        delegate: delegate,
        context: context,
        isAuthenticated: true,
        accessToken: null,
      );
      await tester.pumpAndSettle();

      expect(delegate.configuration.uri.path, '/main/news-center');
    });

    testWidgets('falls back to the inbox when the deep link is unsupported', (tester) async {
      when(remoteConfig.newsCenterEnabled).thenReturn(true);
      final (delegate, context) = await pumpNav(tester);

      await openPushNotificationTarget(
        deepLink: '/not-a-route',
        delegate: delegate,
        context: context,
        isAuthenticated: true,
        accessToken: null,
      );
      await tester.pumpAndSettle();

      expect(delegate.configuration.uri.path, '/main/news-center');
    });

    testWidgets('the fallback still respects the News Center kill switch', (tester) async {
      when(remoteConfig.newsCenterEnabled).thenReturn(false);
      final (delegate, context) = await pumpNav(tester);

      await openPushNotificationTarget(
        deepLink: null,
        delegate: delegate,
        context: context,
        isAuthenticated: true,
        accessToken: null,
      );
      await tester.pumpAndSettle();

      expect(delegate.configuration.uri.path, '/main');
    });
  });
}

class _TestLocation extends BeamLocation<BeamState> {
  _TestLocation(RouteInformation super.info);

  @override
  List<Pattern> get pathPatterns => ['/main', '/main/news-center'];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
    const BeamPage(
      key: ValueKey('probe'),
      child: SizedBox(key: Key('probe')),
    ),
  ];
}
