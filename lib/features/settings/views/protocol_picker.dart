import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/settings/views/settings_picker_card.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_protocol_store.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_store.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class ProtocolPicker extends StatelessWidget {
  const ProtocolPicker({required this.position, super.key});

  final SettingsCardPosition position;

  @override
  Widget build(BuildContext context) {
    final vpnProtocolStore = getIt<VpnProtocolStore>();
    final vpnStore = getIt<VpnStore>();
    final analyticsStore = getIt<AnalyticsStore>();
    final authSessionStore = getIt<AuthSessionStore>();

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
      shownConfirmationDialog(
        context,
        confirmText: LocaleKeys.confirm.tr(),
        cancelText: LocaleKeys.cancelBtn.tr(),
        title: LocaleKeys.protocolPickerSettingTitle.tr(),
        supportingText: LocaleKeys.protocolPickerSettingDesc.tr(),
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
