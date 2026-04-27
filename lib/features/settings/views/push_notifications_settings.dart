import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/notifications/store/push_notifications_store.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class PushNotificationsSetting extends StatelessWidget {
  const PushNotificationsSetting({required this.position, super.key});

  final SettingsCardPosition position;

  @override
  Widget build(BuildContext context) {
    final authSessionStore = getIt<AuthSessionStore>();
    final pushNotificationsStore = getIt<PushNotificationsStore>();
    final analyticsStore = getIt<AnalyticsStore>();
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
                  LocaleKeys.openSystemSettingsBtn.tr(),
                  style: theme.textStyles.textXs.semibold.copyWith(
                    color: theme.palette.textBrandPrimary,
                  ),
                ),
              );

        return SettingsCard(
          title: LocaleKeys.pushNotificationsSetting.tr(),
          subtitle: isDesktop ? LocaleKeys.pushNotificationsSettingDesc.tr() : null,
          subtitleWidget: subtitleWidget,
          position: position,
          trailing: Switch(
            value: pushNotificationsStore.pushNotificationsPermissionGranted,
            onChanged: null,
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
      showSnackbar(LocaleKeys.somethingWentWrong.tr());
    }
  }
}
