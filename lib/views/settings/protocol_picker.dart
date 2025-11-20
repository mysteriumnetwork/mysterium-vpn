import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/dialogs/confirmation_dialog.dart';
import 'package:mysterium_vpn/components/easy_dropdown.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
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
    final authSessionStore = ref.watch(authSessionStorePOD);
    return Observer(
      builder: (context) => EasyDropdown<ProtocolType>(
        value: vpnProtocolStore.protocol,
        onChanged: authSessionStore.status == AuthStatus.authenticated
            ? (ProtocolType? newProtocol) async {
                if (newProtocol == null) {
                  return;
                }
                if (vpnStore.isConnected) {
                  shownConfirmationDialog(
                    context,
                    confirmText: LocaleKeys.confirm.tr(),
                    cancelText: LocaleKeys.cancelBtn.tr(),
                    icon: SvgIcon(asset: Asset.icons.warning),
                    title: LocaleKeys.protocolPickerSettingTitle.tr(),
                    content: Text(
                      LocaleKeys.protocolPickerSettingDesc.tr(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: Palette.black,
                      ),
                      maxLines: 5,
                      textAlign: TextAlign.center,
                    ),
                    onConfirm: () async {
                      analyticsStore.logEvent(AnalyticsEvent.changeProtocolTypeApproved);
                      await vpnStore.disconnectTunnel();
                      await vpnProtocolStore.setProtocol(newProtocol);
                    },
                    onCancel: () {
                      analyticsStore.logEvent(AnalyticsEvent.changeProtocolTypeDeclined);
                    },
                  );
                } else {
                  await vpnProtocolStore.setProtocol(newProtocol);
                }
              }
            : null,
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
