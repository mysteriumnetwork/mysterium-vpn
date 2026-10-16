import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/settings/protocol_picker.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../../support/test_localizations.dart';
import 'protocol_picker_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<VpnStore>(),
  MockSpec<VpnProtocolStore>(),
  MockSpec<AnalyticsStore>(),
  MockSpec<AuthSessionStore>(),
])
void main() {
  late MockVpnStore vpnStore;
  late MockVpnProtocolStore vpnProtocolStore;
  late MockAnalyticsStore analyticsStore;
  late MockAuthSessionStore authSessionStore;

  setUp(() {
    vpnStore = MockVpnStore();
    vpnProtocolStore = MockVpnProtocolStore();
    analyticsStore = MockAnalyticsStore();
    authSessionStore = MockAuthSessionStore();

    when(vpnStore.disconnectTunnel(reason: anyNamed('reason'))).thenAnswer((_) async {});
    when(vpnProtocolStore.protocol).thenReturn(ProtocolType.wireguard);
    when(vpnProtocolStore.setProtocol(any)).thenAnswer((_) async {});
    when(authSessionStore.isAuthenticated).thenReturn(true);
  });

  // Mirrors the app shell: a pages-based root Navigator driven by Beamer, so
  // the sheet and the confirmation dialog land on the same navigator.
  Widget harness() {
    final delegate = BeamerDelegate(
      locationBuilder: RoutesLocationBuilder(
        routes: {
          '/': (_, _, _) =>
              const Scaffold(body: ProtocolPicker(position: SettingsCardPosition.single)),
        },
      ).call,
    );
    return ProviderScope(
      overrides: [
        vpnStorePOD.overrideWithValue(vpnStore),
        vpnProtocolStorePOD.overrideWithValue(vpnProtocolStore),
        analyticsStorePOD.overrideWithValue(analyticsStore),
        authSessionStorePOD.overrideWithValue(authSessionStore),
      ],
      child: BeamerProvider(
        routerDelegate: delegate,
        child: MaterialApp.router(
          theme: DesignSystem.lightTheme,
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          routerDelegate: delegate,
          routeInformationParser: BeamerParser(),
          backButtonDispatcher: BeamerBackButtonDispatcher(delegate: delegate),
        ),
      ),
    );
  }

  Future<void> pumpAt(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(harness());
    await tester.pumpAndSettle();
  }

  /// `SettingsPickerCard` only opens the sheet on its mobile branch.
  Future<void> pickOpenVpn(WidgetTester tester) async {
    await pumpAt(tester, const Size(390, 844));

    await tester.tap(find.text('VPN protocol'));
    await tester.pumpAndSettle();
    expect(find.text('OpenVPN'), findsOneWidget, reason: 'picker sheet should be open');

    await tester.tap(find.text('OpenVPN'));
    await tester.pumpAndSettle();
  }

  group('while connected', () {
    setUp(() => when(vpnStore.isConnected).thenReturn(true));

    testWidgets('the sheet keeps the confirmation dialog it opened', (tester) async {
      await pickOpenVpn(tester);

      expect(find.text('Switching VPN protocol'), findsOneWidget);
      verifyNever(vpnProtocolStore.setProtocol(any));
    });

    testWidgets('confirming disconnects and switches the protocol', (tester) async {
      await pickOpenVpn(tester);
      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();

      verify(vpnStore.disconnectTunnel(reason: VpnDisconnectReason.user)).called(1);
      verify(vpnProtocolStore.setProtocol(ProtocolType.openvpn)).called(1);
      expect(find.byType(RadioButton), findsNothing, reason: 'sheet should close');
    });

    testWidgets('cancelling leaves the protocol untouched', (tester) async {
      await pickOpenVpn(tester);
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      verifyNever(vpnProtocolStore.setProtocol(any));
      verifyNever(vpnStore.disconnectTunnel(reason: anyNamed('reason')));
      // Closing avoids leaving the sheet on a selection that was never applied.
      expect(find.byType(RadioButton), findsNothing, reason: 'sheet should close');
    });
  });

  testWidgets('while disconnected it switches without confirmation', (tester) async {
    when(vpnStore.isConnected).thenReturn(false);
    await pickOpenVpn(tester);

    expect(find.text('Switching VPN protocol'), findsNothing);
    verify(vpnProtocolStore.setProtocol(ProtocolType.openvpn)).called(1);
  });

  // Tablet and up swap the sheet for an `EasyDropdown`, a branch the mobile
  // cases above never reach.
  group('on desktop', () {
    Finder dropdown() => find.byType(DropdownButton<ProtocolType>);

    Future<void> openMenu(WidgetTester tester) async {
      await tester.tap(dropdown());
      await tester.pumpAndSettle();
    }

    Future<void> pickOpenVpnOnDesktop(WidgetTester tester) async {
      await pumpAt(tester, const Size(1440, 900));
      await openMenu(tester);
      expect(find.text('OpenVPN'), findsOneWidget, reason: 'dropdown menu should be open');

      await tester.tap(find.text('OpenVPN').last);
      await tester.pumpAndSettle();
    }

    testWidgets('renders a dropdown instead of the picker sheet', (tester) async {
      when(vpnStore.isConnected).thenReturn(false);
      await pumpAt(tester, const Size(1440, 900));

      expect(dropdown(), findsOneWidget);
      await tester.tap(find.text('VPN protocol'));
      await tester.pumpAndSettle();
      expect(
        find.byType(RadioButton),
        findsNothing,
        reason: 'the card itself should not open a sheet',
      );
    });

    group('while connected', () {
      setUp(() => when(vpnStore.isConnected).thenReturn(true));

      testWidgets('picking waits for the confirmation dialog', (tester) async {
        await pickOpenVpnOnDesktop(tester);

        expect(find.text('Switching VPN protocol'), findsOneWidget);
        verifyNever(vpnProtocolStore.setProtocol(any));
      });

      testWidgets('confirming disconnects and switches the protocol', (tester) async {
        await pickOpenVpnOnDesktop(tester);
        await tester.tap(find.text('Confirm'));
        await tester.pumpAndSettle();

        verify(vpnStore.disconnectTunnel(reason: VpnDisconnectReason.user)).called(1);
        verify(vpnProtocolStore.setProtocol(ProtocolType.openvpn)).called(1);
      });

      testWidgets('cancelling leaves the protocol untouched', (tester) async {
        await pickOpenVpnOnDesktop(tester);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        verifyNever(vpnProtocolStore.setProtocol(any));
        verifyNever(vpnStore.disconnectTunnel(reason: anyNamed('reason')));
      });
    });

    testWidgets('while disconnected it switches without confirmation', (tester) async {
      when(vpnStore.isConnected).thenReturn(false);
      await pickOpenVpnOnDesktop(tester);

      expect(find.text('Switching VPN protocol'), findsNothing);
      verify(vpnProtocolStore.setProtocol(ProtocolType.openvpn)).called(1);
    });

    // A menu route left behind by a previous open trips DropdownButton's
    // `_dropdownRoute == null` assert and wedges the control for good.
    testWidgets('the menu reopens after a switch', (tester) async {
      when(vpnStore.isConnected).thenReturn(false);
      await pickOpenVpnOnDesktop(tester);

      await openMenu(tester);

      expect(tester.takeException(), isNull);
      expect(find.text('OpenVPN'), findsOneWidget, reason: 'menu should open a second time');
    });
  });
}
