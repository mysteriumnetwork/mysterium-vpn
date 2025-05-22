import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/dialogs/confirmation_dialog.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/setting_item.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/vpn_store.dart';
import 'package:mysterium_vpn/views/settings/action_button.dart';
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
            Visibility(
              visible:
                  !remoteConfigStore.hideResetAppSetting && (Platform.isMacOS || Platform.isIOS),
              child: SettingItem(
                asset: isDarkTheme ? Assets.resetAppSettingDark : Assets.resetAppSettingLight,
                title: LocaleKeys.resetAppTitle.tr(),
                subtitle: EasyText(
                  LocaleKeys.resetAppDesc.tr(),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  maxLines: 3,
                  color: Palette.lightBlue,
                ),
                actionWidget: SettingActionButton(
                  action: vpnStore.resetAppFuture?.status == FutureStatus.pending
                      ? null
                      : () => _onConfirmResetApp(
                            context: context,
                            analyticsStore: analyticsStore,
                            vpnStore: vpnStore,
                          ),
                  backgroundColor: Palette.purple,
                  child: vpnStore.resetAppFuture?.status == FutureStatus.pending
                      ? const SizedBox(
                          width: 50,
                          child: LoadingIndicator(
                            radius: 16,
                            indicatorColor: Palette.white,
                          ),
                        )
                      : EasyText(
                          LocaleKeys.resetAppTitle.tr(),
                          color: Palette.white,
                        ),
                ),
              ),
            ),
            SwitchItem(
              asset: isDarkTheme ? Assets.refreshIpSettingDark : Assets.refreshIpSettingLight,
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
                asset: isDarkTheme ? Assets.refreshIpSettingDark : Assets.refreshIpSettingLight,
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

  void _onConfirmResetApp({
    required BuildContext context,
    required AnalyticsStore analyticsStore,
    required VpnStore vpnStore,
  }) {
    analyticsStore.logEvent(AnalyticsEvent.resetApp);
    if (!vpnStore.isConnected) {
      _onResetApp(vpnStore, analyticsStore);
      return;
    }
    shownConfirmationDialog(
      context,
      confirmText: LocaleKeys.resetBtn.tr(),
      cancelText: LocaleKeys.goBackButton.tr(),
      title: LocaleKeys.resetAppDialogTitle.tr(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.resetAppDialogContent.tr(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Palette.black,
            ),
            maxLines: 4,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      onConfirm: () {
        analyticsStore.logEvent(AnalyticsEvent.resetAppConfirm);
        _onResetApp(vpnStore, analyticsStore);
      },
      onCancel: () {
        analyticsStore.logEvent(AnalyticsEvent.resetAppCancel);
      },
    );
  }

  Future<void> _onResetApp(
    VpnStore vpnStore,
    AnalyticsStore analyticsStore,
  ) async {
    try {
      await vpnStore.resetApp();
      showSnackbar(
        LocaleKeys.resetAppSuccess.tr(),
        type: MessageType.success,
      );
      analyticsStore.logEvent(AnalyticsEvent.resetAppSuccess);
    } catch (e, s) {
      showSnackbar(
        LocaleKeys.resetAppFailed.tr(),
      );
      analyticsStore.logError(
        err: e,
        stack: s,
      );
    }
  }
}
