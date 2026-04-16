import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/screen_type_hook.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/dialogs/confirmation_dialog.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/settings/blocker_picker.dart';
import 'package:mysterium_vpn/views/settings/protocol_picker.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide LoadingIndicator, ScreenType;

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
    final authSessionStore = ref.watch(authSessionStorePOD);
    final vpnProtocolStore = ref.watch(vpnProtocolStorePOD);
    final screenType = useScreenType();
    final isDesktop = screenType != ScreenType.mobile;
    final theme = Theme.of(context);

    return Observer(
      builder: (_) {
        final disableSettings = !authSessionStore.isAuthenticated;

        final showReset = !remoteConfigStore.hideResetAppSetting && !Platform.isAndroid;
        final showBlocker =
            !dnsStore.hideMalwareContentBlocker || !dnsStore.hideNotSafeContentBlocker;
        final showProtocol = vpnProtocolStore.isProtocolPickerAvailable;

        final builders = <Widget Function(SettingsCardPosition)>[];
        final spacing = theme.spacing;
        if (showReset) {
          builders.add(
            (pos) => SettingsCard(
              title: LocaleKeys.resetAppTitle.tr(),
              subtitle: LocaleKeys.resetAppDesc.tr(),
              position: pos,
              trailing: ButtonTertiary(
                decoration: ButtonDecoration(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.symmetric(horizontal: spacing.xs, vertical: spacing.xxs),
                ),
                size: ButtonSize.small,
                onPressed:
                    vpnStore.resetAppFuture?.status == FutureStatus.pending || disableSettings
                    ? null
                    : () => _onConfirmResetApp(
                        context: context,
                        analyticsStore: analyticsStore,
                        vpnStore: vpnStore,
                        handleToggleConnection: handleToggleConnection,
                      ),
                child: Text(LocaleKeys.resetAppTitle.tr()),
              ),
            ),
          );
        }

        builders.add(
          (pos) => SettingsCard(
            title: LocaleKeys.refreshIPAddress.tr(),
            subtitle: LocaleKeys.getNewIPAddress.tr(),
            position: pos,
            trailing: Observer(
              builder: (context) => refreshIPStore.refreshIPFuture.status == FutureStatus.pending
                  ? const LoadingIndicator()
                  : Switch(
                      value: refreshIPStore.refreshIPConnection,
                      onChanged: disableSettings
                          ? null
                          : (val) async {
                              await refreshIPStore.toggleRefreshIPWhenConnecting();
                              analyticsStore.logEvent(
                                val
                                    ? AnalyticsEvent.refreshIpEnable
                                    : AnalyticsEvent.refreshIpDisable,
                              );
                            },
                    ),
            ),
          ),
        );

        if (showBlocker) {
          builders.add((pos) => BlockerPicker(position: pos));
        }

        if (showProtocol) {
          builders.add((pos) => ProtocolPicker(position: pos));
        }

        final total = builders.length;
        if (total == 0) {
          return const SizedBox.shrink();
        }

        final cards = Column(
          children: [for (var i = 0; i < total; i++) builders[i](_cardPosition(i, total))],
        );

        return isDesktop
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: theme.spacing.xl3),
                child: cards,
              )
            : cards;
      },
    );
  }

  SettingsCardPosition _cardPosition(int index, int total) {
    if (total == 1) {
      return SettingsCardPosition.single;
    }
    if (index == 0) {
      return SettingsCardPosition.top;
    }
    if (index == total - 1) {
      return SettingsCardPosition.bottom;
    }
    return SettingsCardPosition.middle;
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
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
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
                backgroundColor: Colors.black,
                textColor: Colors.white,
                onPressed: () async {
                  snackbarKey.currentState?.clearSnackBars();
                  handleToggleConnection();
                },
              )
            : null,
      );
      analyticsStore.logEvent(AnalyticsEvent.resetAppSuccess);
    } catch (e, s) {
      showSnackbar(LocaleKeys.resetAppFailed.tr());
      analyticsStore.logError(err: e, stack: s);
    }
  }
}
