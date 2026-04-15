import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/extensions/asset.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/notifications/store/push_notifications_store.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:styled_widget/styled_widget.dart';

class PushNotificationsSetting extends StatelessWidget {
  const PushNotificationsSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final authSessionStore = getIt<AuthSessionStore>();
    final pushNotificationsStore = getIt<PushNotificationsStore>();
    final analyticsStore = getIt<AnalyticsStore>();
    return Observer(
      builder: (context) {
        final visible =
            pushNotificationsStore.supportsPushNotifications &&
            authSessionStore.status == AuthStatus.authenticated;
        return Visibility(
          visible: visible,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: context.c.isDarkMode ? Palette.darkIndigo : Palette.grayContainer,
              borderRadius: const BorderRadius.all(Radius.circular(20)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgIcon(asset: Asset.icons.notification(context)).paddingDirectional(end: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    EasyText(
                      LocaleKeys.pushNotificationsSetting.tr(),
                      fontSize: 14,
                      maxLines: 2,
                      fontWeight: FontWeight.w700,
                    ).padding(bottom: 4),
                    EasyText(
                      LocaleKeys.pushNotificationsSettingDesc.tr(),
                      fontSize: 12,
                      maxLines: 3,
                    ).padding(bottom: 4),
                    TextButton(
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        alignment: Alignment.centerLeft,
                      ),
                      onPressed: () => _updatePushNotificationsPermissions(
                        pushNotificationsStore: pushNotificationsStore,
                        currentValue: pushNotificationsStore.pushNotificationsPermissionGranted,
                        analyticsStore: analyticsStore,
                      ),
                      child: EasyText(
                        LocaleKeys.openSystemSettingsBtn.tr(),
                        fontSize: 12,
                        color: Palette.purple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ).expanded(),
                Switch(
                  value: pushNotificationsStore.pushNotificationsPermissionGranted,
                  onChanged: null,
                ),
              ],
            ),
          ).paddingDirectional(bottom: 10, horizontal: 20),
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
