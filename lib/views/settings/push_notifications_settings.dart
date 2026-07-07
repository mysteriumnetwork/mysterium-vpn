import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class PushNotificationsSetting extends ConsumerWidget {
  const PushNotificationsSetting({required this.position, super.key});

  final SettingsCardPosition position;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authSessionStore = ref.watch(authSessionStorePOD);
    final pushNotificationsStore = ref.watch(pushNotificationsStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);
    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;
    final theme = Theme.of(context);

    return Observer(
      builder: (_) {
        final visible =
            pushNotificationsStore.supportsPushNotifications &&
            authSessionStore.status == AuthStatus.authenticated;

        if (!visible) {
          return const SizedBox.shrink();
        }

        final subtitleWidget = isDesktop
            ? null
            : GestureDetector(
                onTap: () => _updatePushNotificationsPermissions(
                  pushNotificationsStore: pushNotificationsStore,
                  currentValue: pushNotificationsStore.pushNotificationsPermissionGranted,
                  analyticsStore: analyticsStore,
                ),
                child: Text(
                  S.current.openSystemSettingsBtn,
                  style: theme.textStyles.textXs.semibold.copyWith(
                    color: theme.palette.textBrandPrimary,
                  ),
                ),
              );

        return SettingsCard(
          title: S.current.pushNotificationsSetting,
          subtitle: isDesktop ? S.current.pushNotificationsSettingDesc : null,
          subtitleWidget: subtitleWidget,
          position: position,
          trailing: ReadOnlySwitch(
            value: pushNotificationsStore.pushNotificationsPermissionGranted,
          ),
        );
      },
    );
  }

  Future<void> _updatePushNotificationsPermissions({
    required PushNotificationsStore pushNotificationsStore,
    required bool currentValue,
    required AnalyticsStore analyticsStore,
  }) async {
    try {
      await pushNotificationsStore.updatePushNotificationsPermissions();
      analyticsStore.logEvent(
        AnalyticsEvent.togglePushNotifications,
        parameters: {
          'currentValue': currentValue.toString(),
          'newValue': (!currentValue).toString(),
        },
      );
    } catch (e) {
      showSnackbar(S.current.somethingWentWrong);
    }
  }
}
