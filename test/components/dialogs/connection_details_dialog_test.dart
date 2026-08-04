import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/dialogs/connection_details_dialog.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../../support/test_localizations.dart';
import 'connection_details_dialog_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<VpnStore>(),
  MockSpec<ConnectionDisplayStore>(),
  MockSpec<VpnProtocolStore>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<SelectedLocationStore>(),
  MockSpec<IpRefreshExhaustionStore>(),
])
void main() {
  const germany = VPNLocation(
    id: 'DE',
    ipType: IPType.datacenter,
    translations: {'en': 'Germany'},
    countryCode: 'DE',
  );

  late MockVpnStore vpnStore;
  late MockConnectionDisplayStore connectionDisplayStore;
  late MockVpnProtocolStore protocolStore;
  late MockAnalyticsStore analyticsStore;
  late MockSelectedLocationStore selectedLocationStore;
  late MockIpRefreshExhaustionStore ipRefreshExhaustionStore;

  setUp(() {
    vpnStore = MockVpnStore();
    connectionDisplayStore = MockConnectionDisplayStore();
    protocolStore = MockVpnProtocolStore();
    analyticsStore = MockAnalyticsStore();
    selectedLocationStore = MockSelectedLocationStore();
    ipRefreshExhaustionStore = MockIpRefreshExhaustionStore();

    when(vpnStore.vpnStatus).thenReturn(VpnConnectionStatus.connected);
    when(vpnStore.isConnected).thenReturn(true);
    when(vpnStore.isFetchingConfig).thenReturn(false);
    when(vpnStore.connectedIpPoolCount).thenReturn(4);
    when(vpnStore.connectedAt).thenReturn(DateTime.now());
    when(connectionDisplayStore.connectionIP).thenReturn('203.0.113.5');
    when(connectionDisplayStore.connectedOrDisplayLocation).thenReturn(germany);
    when(protocolStore.protocol).thenReturn(ProtocolType.wireguard);
    when(ipRefreshExhaustionStore.exhaustionNotice).thenReturn(null);
  });

  Future<void> openDialog(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          vpnStorePOD.overrideWithValue(vpnStore),
          connectionDisplayStorePOD.overrideWithValue(connectionDisplayStore),
          vpnProtocolStorePOD.overrideWithValue(protocolStore),
          analyticsStorePOD.overrideWithValue(analyticsStore),
          selectedLocationStorePOD.overrideWithValue(selectedLocationStore),
          ipRefreshExhaustionStorePOD.overrideWithValue(ipRefreshExhaustionStore),
        ],
        child: BeamerProvider(
          routerDelegate: BeamerDelegate(
            locationBuilder: RoutesLocationBuilder(
              routes: {'/': (_, a, b) => const SizedBox.shrink()},
            ).call,
          ),
          child: MaterialApp(
            theme: DesignSystem.lightTheme,
            locale: testLocale,
            localizationsDelegates: testLocalizationsDelegates,
            supportedLocales: testSupportedLocales,
            home: Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => showConnectionDetailsDialog(context),
                  child: const Text('open'),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    // Fixed pumps instead of pumpAndSettle — the dialog runs a periodic timer.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
  }

  testWidgets('mobile layout is top-aligned directly below the header', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await openDialog(tester);

    final appbarBottom = tester.getRect(find.byType(ModalAppbar)).bottom;
    final cardTop = tester.getRect(find.byType(LocationStatusCard)).top;
    // Content hugs the header (scroll padding only) — a regression here
    // (e.g. double app-bar inset) pushes it towards the screen centre.
    expect(cardTop - appbarBottom, lessThanOrEqualTo(24));
  });

  testWidgets('shows location, status and all detail rows', (tester) async {
    await openDialog(tester);

    expect(find.text('Germany'), findsOneWidget);
    expect(find.text('Connected'), findsOneWidget);
    expect(find.text('My IP'), findsOneWidget);
    expect(find.text('Hidden'), findsOneWidget);
    expect(find.text('VPN IP'), findsOneWidget);
    expect(find.text('203.0.113.5'), findsOneWidget);
    expect(find.text('IP type'), findsOneWidget);
    expect(find.text('Protocol'), findsOneWidget);
    expect(find.text('WireGuard'), findsOneWidget);
    expect(find.text('IP pool'), findsOneWidget);
    expect(find.text('4'), findsOneWidget);
    expect(find.text('Connected since'), findsOneWidget);
  });

  testWidgets('refresh triggers an IP refresh via VpnStore', (tester) async {
    await openDialog(tester);

    await tester.tap(find.text('Refresh'));
    await tester.pump();

    verify(analyticsStore.logRefreshIP('203.0.113.5')).called(1);
    verify(selectedLocationStore.value = null).called(1);
    verify(vpnStore.manageConnection(refreshIP: true)).called(1);
  });

  testWidgets('refresh is disabled when the IP pool has a single address', (tester) async {
    when(vpnStore.connectedIpPoolCount).thenReturn(1);
    await openDialog(tester);

    await tester.tap(find.text('Refresh'));
    await tester.pump();

    verifyNever(vpnStore.manageConnection(refreshIP: true));
  });

  testWidgets('refresh is disabled while not fully connected (getting IP)', (tester) async {
    when(vpnStore.isFetchingConfig).thenReturn(true);
    when(vpnStore.isConnected).thenReturn(false);
    await openDialog(tester);

    await tester.tap(find.text('Refresh'));
    await tester.pump();

    verifyNever(vpnStore.manageConnection(refreshIP: true));
  });

  testWidgets('refresh spins and blocks re-press while a refresh is pending', (tester) async {
    final pending = Completer<void>();
    when(vpnStore.manageConnection(refreshIP: true)).thenAnswer((_) => pending.future);
    await openDialog(tester);

    final spin = tester
        .widget<RotationTransition>(
          find.descendant(
            of: find.byType(ButtonTertiary),
            matching: find.byType(RotationTransition),
          ),
        )
        .turns;

    await tester.tap(find.text('Refresh'));
    await tester.pump();
    expect((spin as AnimationController).isAnimating, isTrue);

    await tester.tap(find.text('Refresh'));
    await tester.pump();
    verify(vpnStore.manageConnection(refreshIP: true)).called(1);

    pending.complete();
    await tester.pump();
    expect(spin.isAnimating, isFalse);
  });

  testWidgets('snackbars route to the dialog while it is open', (tester) async {
    await openDialog(tester);

    showSnackbar('refresh failed');
    await tester.pump();

    expect(
      find.descendant(
        of: find.byType(ScaffoldMessenger).last,
        matching: find.text('refresh failed'),
      ),
      findsOneWidget,
    );
    // Let the snackbar's auto-dismiss timer elapse before the test ends.
    await tester.pump(const Duration(seconds: 5));
  });

  testWidgets('connected-since clamps to zero when connectedAt is in the future', (tester) async {
    when(vpnStore.connectedAt).thenReturn(DateTime.now().add(const Duration(hours: 2)));
    await openDialog(tester);

    expect(find.text('00:00:00'), findsOneWidget);
  });

  testWidgets('shows getting-IP status while fetching config', (tester) async {
    when(vpnStore.isFetchingConfig).thenReturn(true);
    await openDialog(tester);

    expect(find.text('Getting IP address...'), findsOneWidget);
  });

  group('disconnected', () {
    setUp(() {
      when(vpnStore.vpnStatus).thenReturn(VpnConnectionStatus.disconnected);
      when(vpnStore.isConnected).thenReturn(false);
      when(vpnStore.connectedAt).thenReturn(null);
      when(connectionDisplayStore.connectionIP).thenReturn(null);
      when(connectionDisplayStore.isLoading).thenReturn(false);
    });

    testWidgets('shows Connect instead of Refresh and empties the IP rows', (tester) async {
      await openDialog(tester);

      expect(find.text('Disconnected'), findsOneWidget);
      expect(find.text('Connect'), findsOneWidget);
      expect(find.text('Refresh'), findsNothing);
      expect(find.text('Hidden'), findsNothing);
      expect(find.byIcon(UntitledUI.eye_off), findsNothing);
      expect(find.text('...'), findsNothing);
    });

    testWidgets('Connect triggers a connection', (tester) async {
      await openDialog(tester);

      await tester.tap(find.text('Connect'));
      await tester.pump();

      verify(vpnStore.manageConnection()).called(1);
    });
  });
}
