import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/components/dialogs/confirmation_dialog.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/settings/settings_picker_card.dart';
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

    return Observer(
      builder: (_) => SettingsPickerCard<ProtocolType>(
        title: LocaleKeys.vpnProtocolSettingLbl.tr(),
        position: position,
        value: vpnProtocolStore.protocol,
        items: ProtocolType.values,
        labelOf: (p) => LocaleKeys.protocolLabel.tr(args: [p.labelKey.tr(), p.subtitle]),
        subtitleOf: (p) => p.subtitle,
        customLabel: (p) => p.labelKey.tr(),
        onChanged: (newProtocol) => _changeProtocol(
          context,
          newProtocol: newProtocol,
          vpnStore: vpnStore,
          vpnProtocolStore: vpnProtocolStore,
          analyticsStore: analyticsStore,
        ),
        enabled: authSessionStore.isAuthenticated,
      ),
    );
  }

  Future<void> _changeProtocol(
    BuildContext context, {
    required ProtocolType newProtocol,
    required VpnStore vpnStore,
    required VpnProtocolStore vpnProtocolStore,
    required AnalyticsStore analyticsStore,
  }) async {
    if (vpnStore.isConnected) {
      final theme = Theme.of(context);
      shownConfirmationDialog(
        context,
        confirmText: LocaleKeys.confirm.tr(),
        cancelText: LocaleKeys.cancelBtn.tr(),
        icon: SvgIcon(asset: Asset.icons.warning),
        title: LocaleKeys.protocolPickerSettingTitle.tr(),
        content: Text(
          LocaleKeys.protocolPickerSettingDesc.tr(),
          style: theme.textStyles.textSm.regular.copyWith(color: theme.palette.textSecondary),
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
}
