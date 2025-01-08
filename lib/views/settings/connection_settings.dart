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
    final remoteConfigStore = ref.read(remoteConfigStorePOD);
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
                    await vpnStore.toggleRefreshIPWhenConnecting();
                    analyticsStore.logEvent(
                      val ? AnalyticsEvent.refreshIpEnable : AnalyticsEvent.refreshIpDisable,
                    );
                  },
                ),
              ),
            ),
            Visibility(
              visible: !remoteConfigStore.hideMalwareBlocker,
              child: SwitchItem(
                enabled: !vpnStore.notSafeContentBlocker,
                asset: isDarkTheme ? Assets.lockerDark : Assets.lockerLight,
                title: LocaleKeys.malwareBlocker.tr(),
                subtitle: '',
                actionWidget: Observer(
                  builder: (context) => Switch(
                    value: vpnStore.malwareBlockerContent,
                    onChanged: (val) async {
                      await vpnStore.toggleMalwareBlocker();
                      analyticsStore
                          .logEvent(val ? AnalyticsEvent.malwareOn : AnalyticsEvent.malwareOff);
                    },
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !remoteConfigStore.hideNotSafeContentBlocker,
              child: SwitchItem(
                asset: isDarkTheme ? Assets.lockerDark : Assets.lockerLight,
                title: LocaleKeys.contentBlockerTitle.tr(),
                subtitle: LocaleKeys.contentBlockerDesc.tr(),
                actionWidget: Observer(
                  builder: (context) => Switch(
                    value: vpnStore.notSafeContentBlocker,
                    onChanged: (val) async {
                      await vpnStore.toggleNotSafeContentBlocker();
                      analyticsStore.logEvent(val ? AnalyticsEvent.nsfwOn : AnalyticsEvent.nsfwOff);
                    },
                  ),
                ),
              ),
            ),
            Visibility(
              visible: !remoteConfigStore.hideKillSwitch,
              child: SwitchItem(
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
