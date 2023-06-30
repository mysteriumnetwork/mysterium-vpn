import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/setting_item.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/settings/protocol_picker.dart';
import 'package:mysterium_vpn/views/settings/switch_item.dart';

class ConnectionSettings extends HookConsumerWidget {
  const ConnectionSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStore = ref.read(themeStorePOD);
    final vpnStore = ref.read(vpnStorePOD);
    return Observer(
      builder: (context) {
        final isDarkTheme = themeStore.isDarkMode;

        return Column(
          children: [
            Visibility(
              visible: false,
              child: SwitchItem(
                asset: isDarkTheme ? Assets.killSwitchDark : Assets.killSwitchLight,
                title: LocaleKeys.killSwitch.tr(),
                subtitle: LocaleKeys.shortDesc.tr(),
                actionWidget: Observer(
                  builder: (context) => Switch(
                    value: vpnStore.killSwitch,
                    onChanged: (val) async {
                      vpnStore.toggleKillSwitch();
                    },
                  ),
                ),
              ),
            ),
            SwitchItem(
              asset: isDarkTheme ? Assets.refreshDark : Assets.refreshLight,
              title: LocaleKeys.refreshIPAddress.tr(),
              subtitle: LocaleKeys.getNewIPAddress.tr(),
              actionWidget: Observer(
                builder: (context) => Switch(
                  value: vpnStore.resetConnection,
                  onChanged: (val) async {
                    vpnStore.toggleResetConnection();
                  },
                ),
              ),
            ),
            Visibility(
              visible: false,
              child: SettingItem(
                asset: isDarkTheme ? Assets.protocolDark : Assets.protocolLight,
                title: LocaleKeys.protocol.tr(),
                subtitle: LocaleKeys.shortDesc.tr(),
                actionWidget: ProtocolPicker(
                  store: vpnStore,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
