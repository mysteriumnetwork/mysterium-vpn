import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class ConnectionStatusBar extends HookConsumerWidget {
  const ConnectionStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);
    final connectionStatus = useComputedValue(() => vpnStore.vpnStatus);
    final isFetchingConfig = useComputedValue(() => vpnStore.isFetchingConfig);

    final status = connectionStatus.toBarStatus(isFetchingConfig: isFetchingConfig);
    return ConnectionBar(label: status.localizedLabel, status: status);
  }
}
