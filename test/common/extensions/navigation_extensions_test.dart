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

  testWidgets('ignores a News Center deep link when newsCenterEnabled is false', (tester) async {
    when(remoteConfig.newsCenterEnabled).thenReturn(false);
    final (delegate, context) = await pumpNav(tester);

    await delegate.navigateToUrl(
      url: '/main/news-center?id=1',
      isAuthenticated: true,
      context: context,
      accessToken: null,
    );
    await tester.pumpAndSettle();

    // Stayed on /main — the deep link was ignored.
    expect(delegate.configuration.uri.path, '/main');
  });

  testWidgets('navigates to News Center when newsCenterEnabled is true', (tester) async {
    when(remoteConfig.newsCenterEnabled).thenReturn(true);
    final (delegate, context) = await pumpNav(tester);

    await delegate.navigateToUrl(
      url: '/main/news-center?id=1',
      isAuthenticated: true,
      context: context,
      accessToken: null,
    );
    await tester.pumpAndSettle();

    expect(delegate.configuration.uri.path, '/main/news-center');
    expect(delegate.configuration.uri.queryParameters['id'], '1');
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
