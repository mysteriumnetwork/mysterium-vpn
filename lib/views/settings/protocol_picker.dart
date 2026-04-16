import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/dialogs/confirmation_dialog.dart';
import 'package:mysterium_vpn/components/easy_dropdown.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/picker_bottom_sheet.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide Palette, ScreenType;

class ProtocolPicker extends ConsumerWidget {
  const ProtocolPicker({required this.position, super.key});

  final SettingsCardPosition position;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnProtocolStore = ref.watch(vpnProtocolStorePOD);
    final vpnStore = ref.watch(vpnStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);
    final authSessionStore = ref.watch(authSessionStorePOD);

    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;
    final theme = Theme.of(context);
    final title = LocaleKeys.vpnProtocolSettingLbl.tr();

    if (isDesktop) {
      return SettingsCard(
        title: title,
        position: position,
        trailing: Observer(
          builder: (context) => EasyDropdown<ProtocolType>(
            value: vpnProtocolStore.protocol,
            onChanged: authSessionStore.isAuthenticated
                ? (ProtocolType? newProtocol) {
                    if (newProtocol == null) {
                      return;
                    }
                    _changeProtocol(
                      context,
                      newProtocol: newProtocol,
                      vpnStore: vpnStore,
                      vpnProtocolStore: vpnProtocolStore,
                      analyticsStore: analyticsStore,
                    );
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
        ),
      );
    }

    // Mobile
    return Observer(
      builder: (context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: authSessionStore.isAuthenticated
            ? () => showPickerBottomSheet<ProtocolType>(
                context: context,
                title: title,
                items: ProtocolType.values,
                value: vpnProtocolStore.protocol,
                labelOf: (p) => p.label,
                onChanged: (newProtocol) => _changeProtocol(
                  context,
                  newProtocol: newProtocol,
                  vpnStore: vpnStore,
                  vpnProtocolStore: vpnProtocolStore,
                  analyticsStore: analyticsStore,
                ),
              )
            : null,
        child: SettingsCard(
          title: title,
          subtitle: vpnProtocolStore.protocol.label,
          position: position,
          trailing: Icon(UntitledUI.chevron_right, size: 24, color: theme.palette.iconTertiary),
        ),
      ),
    );
  }

  void _changeProtocol(
    BuildContext context, {
    required ProtocolType newProtocol,
    required VpnStore vpnStore,
    required VpnProtocolStore vpnProtocolStore,
    required AnalyticsStore analyticsStore,
  }) {
    if (vpnStore.isConnected) {
      shownConfirmationDialog(
        context,
        confirmText: LocaleKeys.confirm.tr(),
        cancelText: LocaleKeys.cancelBtn.tr(),
        icon: SvgIcon(asset: Asset.icons.warning),
        title: LocaleKeys.protocolPickerSettingTitle.tr(),
        content: Text(
          LocaleKeys.protocolPickerSettingDesc.tr(),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Palette.black),
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
      vpnProtocolStore.setProtocol(newProtocol);
    }
  }
}
