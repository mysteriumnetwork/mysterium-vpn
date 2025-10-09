import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/dialogs/confirmation_dialog.dart';
import 'package:mysterium_vpn/components/easy_dropdown.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class ProtocolPicker extends ConsumerWidget {
  const ProtocolPicker({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnProtocolStore = ref.watch(vpnProtocolStorePOD);
    final vpnStore = ref.watch(vpnStorePOD);
    final analyticsStore = ref.watch(analyticsStorePOD);

    return Observer(
      builder: (context) => vpnProtocolStore.protocolFuture.status == FutureStatus.pending
          ? const LoadingIndicator()
          : EasyDropdown<ProtocolType>(
              value: vpnProtocolStore.protocol,
              onChanged: (ProtocolType? newProtocol) async {
                if (newProtocol == null) {
                  return;
                }
                if (vpnStore.isConnected) {
                  shownConfirmationDialog(
                    context,
                    confirmText: LocaleKeys.confirm.tr(),
                    cancelText: LocaleKeys.cancelBtn.tr(),
                    icon: SvgIcon(asset: Asset.icons.warning),
                    title: 'Switching VPN protocol',
                    content: const Text(
                      'Switching the VPN protocol will disconnect you. You’ll need to reconnect afterwards.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Palette.black,
                      ),
                      maxLines: 5,
                      textAlign: TextAlign.center,
                    ),
                    onConfirm: () async {
                      analyticsStore.logEvent(AnalyticsEvent.changeProtocolTypeApproved);
                      await vpnStore.disconnectFromVpn();
                      vpnProtocolStore.setProtocol(newProtocol);
                    },
                    onCancel: () {
                      analyticsStore.logEvent(AnalyticsEvent.changeProtocolTypeDeclined);
                    },
                  );
                } else {
                  vpnProtocolStore.setProtocol(newProtocol);
                }
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
