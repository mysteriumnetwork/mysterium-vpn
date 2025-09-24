import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/dialogs/confirmation_dialog.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/setting_item.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
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
    final vpnStore = ref.read(vpnStorePOD);
    final refreshIPStore = ref.read(refreshIPStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);
    final remoteConfigStore = ref.read(remoteConfigStorePOD);
    final handleToggleConnection = useHandleToggleConnection();
    final dnsStore = ref.watch(dnsStorePOD);

    return Observer(
      builder: (_) => Column(
        children: [
          Visibility(
            visible: !remoteConfigStore.hideResetAppSetting && !Platform.isAndroid,
            child: SettingItem(
              asset: Asset.icons.resetAppSetting(context),
              title: LocaleKeys.resetAppTitle.tr(),
              subtitle: EasyText(
                LocaleKeys.resetAppDesc.tr(),
                fontSize: 12,
                fontWeight: FontWeight.w400,
                maxLines: 3,
              ),
              actionWidget: SettingActionButton(
                action: vpnStore.resetAppFuture?.status == FutureStatus.pending
                    ? null
                    : () => _onConfirmResetApp(
                          context: context,
                          analyticsStore: analyticsStore,
                          vpnStore: vpnStore,
                          handleToggleConnection: handleToggleConnection,
                        ),
                backgroundColor: Palette.purple,
                child: vpnStore.resetAppFuture?.status == FutureStatus.pending
                    ? const LoadingIndicator(
                        radius: 16,
                        indicatorColor: Palette.white,
                      )
                    : EasyText(
                        LocaleKeys.resetAppTitle.tr(),
                        color: Palette.white,
                      ),
              ),
            ),
          ),
          SwitchItem(
            asset: Asset.icons.refreshIpSetting(context),
            title: LocaleKeys.refreshIPAddress.tr(),
            subtitle: LocaleKeys.getNewIPAddress.tr(),
            actionWidget: Observer(
              builder: (context) => refreshIPStore.refreshIPFuture.status == FutureStatus.pending
                  ? const LoadingIndicator()
                  : Switch(
                      value: refreshIPStore.refreshIPConnection,
                      onChanged: (val) async {
                        await refreshIPStore.toggleRefreshIPWhenConnecting();
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
              enabled: !dnsStore.notSafeContentBlocker,
              asset: Asset.icons.locker(context),
              title: LocaleKeys.malwareBlocker.tr(),
              subtitle: '',
              actionWidget: Observer(
                builder: (context) => dnsStore.malwareBlockerFuture.status == FutureStatus.pending
                    ? const LoadingIndicator()
                    : Switch(
                        value: dnsStore.malwareBlockerContent,
                        onChanged: (val) async {
                          await dnsStore.toggleMalwareBlocker();
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
              asset: Asset.icons.stop(context),
              title: LocaleKeys.contentBlockerTitle.tr(),
              subtitle: LocaleKeys.contentBlockerDesc.tr(),
              actionWidget: Observer(
                builder: (context) =>
                    dnsStore.notSafeContentBlockerFuture.status == FutureStatus.pending
                        ? const LoadingIndicator()
                        : Switch(
                            value: dnsStore.notSafeContentBlocker,
                            onChanged: (val) async {
                              await dnsStore.toggleNotSafeContentBlocker();
                              analyticsStore
                                  .logEvent(val ? AnalyticsEvent.nsfwOn : AnalyticsEvent.nsfwOff);
                            },
                          ),
              ),
            ),
          ),
          Visibility(
            visible: !remoteConfigStore.hideKillSwitch,
            child: SwitchItem(
              asset: Asset.icons.refreshIpSetting(context),
              title: LocaleKeys.killSwitch.tr(),
              subtitle: LocaleKeys.killSwitchDesc.tr(),
              actionWidget: Row(
                children: [
                  EasyText(
                    LocaleKeys.on.tr(),
                    color: Palette.lightBlue,
                  ).paddingDirectional(end: 5),
                  SvgIcon(asset: Asset.icons.checkmark),
                ],
              ),
            ),
          ),
          Visibility(
            visible: false,
            child: SettingItem(
              asset: Asset.icons.protocol(context),
              title: LocaleKeys.protocol.tr(),
              actionWidget: ProtocolPicker(
                store: vpnStore,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onConfirmResetApp({
    required BuildContext context,
    required AnalyticsStore analyticsStore,
    required VpnStore vpnStore,
    required VoidCallback handleToggleConnection,
  }) {
    analyticsStore.logEvent(AnalyticsEvent.resetApp);
    if (!vpnStore.isConnected) {
      _onResetApp(context, vpnStore, analyticsStore);
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
        _onResetApp(context, vpnStore, analyticsStore, handleToggleConnection);
      },
      onCancel: () {
        analyticsStore.logEvent(AnalyticsEvent.resetAppCancel);
      },
    );
  }

  Future<void> _onResetApp(
    BuildContext context,
    VpnStore vpnStore,
    AnalyticsStore analyticsStore, [
    VoidCallback? handleToggleConnection,
  ]) async {
    try {
      await vpnStore.resetApp();
      showSnackbar(
        LocaleKeys.resetAppSuccess.tr(),
        type: MessageType.success,
        action: handleToggleConnection != null
            ? SnackBarAction(
                label: LocaleKeys.reconnectBtn.tr(),
                backgroundColor: Palette.black,
                textColor: Palette.white,
                onPressed: () async {
                  snackbarKey.currentState?.clearSnackBars();
                  handleToggleConnection();
                },
              )
            : null,
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
