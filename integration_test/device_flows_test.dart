import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/utils/keys.dart';
import 'package:mysterium_vpn/entrypoints/app_initializer.dart';
import 'package:patrol/patrol.dart';

import 'support/app_harness.dart';
import 'support/flows.dart';

/// Flows that establish a real VPN tunnel. They cannot run on the iOS Simulator
/// (the Network Extension only runs on a physical device), so they are skipped
/// by default and enabled on real-device runs (CI's Firebase Test Lab) with
/// `--dart-define DEVICE_TESTS=true`.
const _runDeviceTests = bool.fromEnvironment('DEVICE_TESTS');

void main() {
  late final AppInitializer environment;
  patrolSetUp(() async {
    environment = await bootApp();
  });

  patrolTest('Connection: connect then disconnect the VPN', skip: !_runDeviceTests, ($) async {
    await $.pumpWidgetAndSettle(environment.getApp());
    await loginWithEnv($);

    // Connect from the map tab's connection card.
    await $(#connectButton).scrollTo();
    await $(#connectButton).tap();

    // The tunnel takes a few seconds to establish on a real device.
    await $(#connectionStatusBar).waitUntilVisible();
    await $.pump(const Duration(seconds: 15));

    // Disconnect again (same control toggles).
    await $(#connectButton).tap();
    await $.pump(const Duration(seconds: 5));
    expect($(#connectionStatusBar), findsOneWidget);
  });

  patrolTest('Connection: switch the VPN protocol to OpenVPN', skip: !_runDeviceTests, ($) async {
    await $.pumpWidgetAndSettle(environment.getApp());
    await loginWithEnv($);

    await openSettingsCategory($, #settingsConnectionCategory);

    // Switching to OpenVPN initializes the native OpenVPN tunnel — only works
    // on a real device (fails with an IPC error on the simulator).
    await selectFromPicker($, #protocolPickerCard, #protocolPickerSheet, #protocolOption_openvpn);
    await selectFromPicker($, #protocolPickerCard, #protocolPickerSheet, #protocolOption_wireguard);
  });

  patrolTest('Locations: selecting a location connects to it', skip: !_runDeviceTests, ($) async {
    await $.pumpWidgetAndSettle(environment.getApp());
    await loginWithEnv($);

    await $(#locationsTab).tap();
    await $(#locationSearch).waitUntilVisible();

    // Country code depends on the backend's available nodes; adjust for the
    // target environment. Selecting a location initiates a connection.
    final germany = locationItemKey('de');
    await $(germany).scrollTo();
    await $(germany).tap();

    await $(#connectionStatusBar).waitUntilVisible();
    await $.pump(const Duration(seconds: 15));
    expect($(#connectionStatusBar), findsOneWidget);
  });
}
