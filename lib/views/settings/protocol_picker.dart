import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/settings/settings_picker_card.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

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
        key: K.protocolPickerCard,
        sheetKey: K.protocolPickerSheet,
        itemKeyOf: (p) => Key('protocolOption_${p.name}'),
        title: S.current.vpnProtocolSettingLbl,
        position: position,
        value: vpnProtocolStore.protocol,
        items: ProtocolType.values,
        labelOf: (p) => S.current.protocolLabel(_label(p), p.subtitle),
        subtitleOf: (p) => p.subtitle,
        customLabel: _label,
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
      shownConfirmationDialog(
        context,
        confirmText: S.current.confirm,
        cancelText: S.current.cancelBtn,
        title: S.current.protocolPickerSettingTitle,
        supportingText: S.current.protocolPickerSettingDesc,
        onConfirm: () async {
          analyticsStore.logEvent(AnalyticsEvent.changeProtocolTypeApproved);
          await vpnStore.disconnectTunnel(reason: VpnDisconnectReason.user);
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

String _label(ProtocolType p) => switch (p) {
  ProtocolType.wireguard => S.current.fastLabel,
  ProtocolType.openvpn => S.current.batterySaverLabel,
};
