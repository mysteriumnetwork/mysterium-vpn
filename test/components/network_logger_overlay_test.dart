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
void main() {
  late MockRemoteConfigStore remoteConfig;

  setUp(() => remoteConfig = MockRemoteConfigStore());

  // No Router/ModalRoute ancestor here, matching where the overlay really
  // lives: inside MaterialApp.router's builder, above the app Router.
  Future<void> pumpOverlay(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [remoteConfigStorePOD.overrideWithValue(remoteConfig)],
        child: MaterialApp(
          theme: DesignSystem.lightTheme,
          home: const NetworkLoggerOverlayView(child: Text('app')),
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
