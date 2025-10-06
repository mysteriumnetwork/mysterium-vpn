import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/easy_dropdown.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class ProtocolPicker extends ConsumerWidget {
  const ProtocolPicker({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnProtocolStore = ref.watch(vpnProtocolStorePOD);
    final vpnStore = ref.watch(vpnStorePOD);

    return Observer(
      builder: (context) => vpnProtocolStore.protocolFuture.status == FutureStatus.pending
          ? const LoadingIndicator()
          : EasyDropdown<ProtocolType>(
              value: vpnProtocolStore.protocol,
              onChanged: (ProtocolType? newProtocol) async {
                if (vpnStore.isConnected) {
                  showSnackbar('To change protocol please disconnect first');
                }
                if (newProtocol == null) {
                  return;
                }
                vpnProtocolStore.setProtocol(newProtocol);
              },
              items: ProtocolType.values
                  .map<DropdownMenuItem<ProtocolType>>(
                    (protocol) => DropdownMenuItem<ProtocolType>(
                      value: protocol,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: EasyText(protocol.label),
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }
}
