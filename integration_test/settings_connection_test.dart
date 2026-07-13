import 'package:mysterium_vpn/entrypoints/app_initializer.dart';
import 'package:patrol/patrol.dart';

import 'support/app_harness.dart';
import 'support/flows.dart';

void main() {
  late final AppInitializer environment;
  patrolSetUp(() async {
    environment = await bootApp();
  });

  patrolTest('Connection: change the content blocker when available', ($) async {
    await $.pumpWidgetAndSettle(environment.getApp());
    await loginWithEnv($);

    await openSettingsCategory($, #settingsConnectionCategory);

    // The blocker picker is gated by remote-config flags, so exercise it only
    // when shown. Selecting "None" is safe on the simulator — it toggles DNS
    // content blocking (a backend call), not the VPN tunnel, and is a no-op when
    // None is already the current value.
    //
    // NOTE: the VPN *protocol* picker is intentionally not exercised here —
    // switching to OpenVPN initializes the native OpenVPN tunnel, which fails on
    // the simulator (IPC to the Network Extension). It is covered in
    // `device_flows_test.dart` instead.
    if (await isVisibleWithin($, #blockerPickerCard)) {
      await selectFromPicker($, #blockerPickerCard, #blockerPickerSheet, #blockerOption_none);
    }
  });
}
