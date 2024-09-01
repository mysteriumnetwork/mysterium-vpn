import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/setting_item.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/settings/protocol_picker.dart';
import 'package:mysterium_vpn/views/settings/switch_item.dart';
import 'package:styled_widget/styled_widget.dart';

class ConnectionSettings extends HookConsumerWidget {
  const ConnectionSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStore = ref.read(themeStorePOD);
    final vpnStore = ref.read(vpnStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);
    return Observer(
      builder: (context) {
        final isDarkTheme = themeStore.isDarkMode;

        return Column(
          children: [
            SwitchItem(
              asset: isDarkTheme ? Assets.refreshDark : Assets.refreshLight,
              title: LocaleKeys.refreshIPAddress.tr(),
              subtitle: LocaleKeys.getNewIPAddress.tr(),
              actionWidget: Observer(
                builder: (context) => Switch(
                  value: vpnStore.refreshIPConnection,
                  onChanged: (val) async {
                    vpnStore.toggleRefreshIPWhenConnecting();
                    if (val) {
                      analyticsStore.logEvent(AnalyticsEvent.refreshIpEnable);
                    } else {
                      analyticsStore.logEvent(AnalyticsEvent.refreshIpDisable);
                    }
                  },
                ),
              ),
            ),
            SwitchItem(
              asset: isDarkTheme ? Assets.refreshDark : Assets.refreshLight,
              title: LocaleKeys.killSwitch.tr(),
              subtitle: LocaleKeys.killSwitchDesc.tr(),
              actionWidget: Row(
                children: [
                  EasyText(
                    LocaleKeys.on.tr(),
                    color: Palette.lightBlue,
                  ).paddingDirectional(end: 5),
                  const SvgIcon(
                    asset: Assets.checkmark,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: false,
              child: SettingItem(
                asset: isDarkTheme ? Assets.protocolDark : Assets.protocolLight,
                title: LocaleKeys.protocol.tr(),
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
