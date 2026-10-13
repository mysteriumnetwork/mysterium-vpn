import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mysterium_vpn/components/network_logger_overlay.dart';
import 'package:mysterium_vpn/debug/network_logger/network_logger_view.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import 'network_logger_overlay_test.mocks.dart';

@GenerateNiceMocks([MockSpec<RemoteConfigStore>()])
/// Mirrors production: a Router owning the app navigator, with the overlay
/// mounted in `MaterialApp.router`'s builder — i.e. above that Router.
class _AppRouterDelegate extends RouterDelegate<Object>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin<Object> {
  @override
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) => Navigator(
    key: navigatorKey,
    pages: const [MaterialPage<void>(child: Text('app'))],
    onDidRemovePage: (_) {},
  );

  @override
  Future<void> setNewRoutePath(Object configuration) async {}
}

void main() {
  late MockRemoteConfigStore remoteConfig;

  setUp(() => remoteConfig = MockRemoteConfigStore());

  Future<void> pumpOverlay(WidgetTester tester) async {
    final delegate = _AppRouterDelegate();
    addTearDown(delegate.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [remoteConfigStorePOD.overrideWithValue(remoteConfig)],
        child: MaterialApp.router(
          theme: DesignSystem.lightTheme,
          routerDelegate: delegate,
          backButtonDispatcher: RootBackButtonDispatcher(),
          builder: (context, child) => NetworkLoggerOverlayView(child: child!),
        ),
      ),
    );
    await tester.pump();
  }

  testWidgets('shows the app and the launcher button', (tester) async {
    await pumpOverlay(tester);

    expect(find.text('app'), findsOneWidget);
    expect(find.byType(NetworkLoggerButton), findsOneWidget);
  });

  testWidgets('opens the logger without needing a Router ancestor', (tester) async {
    await pumpOverlay(tester);

    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(NetworkLoggerScreen), findsOneWidget);
    expect(find.byType(NetworkLoggerButton), findsNothing);
  });

  testWidgets('closing the logger restores the app and the button', (tester) async {
    await pumpOverlay(tester);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.byType(NetworkLoggerScreen), findsNothing);
    expect(find.byType(NetworkLoggerButton), findsOneWidget);
    expect(find.text('app'), findsOneWidget);
  });
}
