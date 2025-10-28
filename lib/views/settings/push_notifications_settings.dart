import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/screen_type_hook.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/auth/auth_status.dart';
import 'package:mysterium_vpn/views/settings/switch_item.dart';
import 'package:styled_widget/styled_widget.dart';

class PushNotificationsSetting extends HookConsumerWidget {
  const PushNotificationsSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authSessionStore = ref.watch(authSessionStorePOD);
    final authStatus = useComputedValue(() => authSessionStore.status);
    final userPreferencesStore = ref.watch(userPreferencesStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);

    final screenType = useScreenType();
    final isMobile = screenType == ScreenType.mobile;
    return Observer(
      builder: (context) => Visibility(
        visible: Platform.isAndroid &&
            authStatus == AuthStatus.authenticated &&
            userPreferencesStore.pushNotificationsPermissionGranted != null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            EasyText(
              LocaleKeys.pushNotificationsTitle.tr(),
              fontSize: isMobile ? 16 : 14,
              fontWeight: isMobile ? FontWeight.w600 : FontWeight.w400,
            ).padding(
              bottom: isMobile ? 16 : 16,
              left: isMobile ? 40 : 20,
              top: isMobile ? 16 : 30,
              right: 0,
            ),
            SwitchItem(
              asset: Asset.icons.notification(context),
              title: LocaleKeys.pushNotificationsSetting.tr(),
              subtitle: LocaleKeys.pushNotificationsSettingDesc.tr(),
              actionWidget: Observer(
                builder: (context) => Switch(
                  value: userPreferencesStore.pushNotificationsPermissionGranted!,
                  onChanged: (val) async {
                    try {
                      await userPreferencesStore.updatePushNotificationsPermissions();
                      analyticsStore.logEvent(
                        AnalyticsEvent.togglePushNotifications,
                        parameters: {'value': val.toString()},
                      );
                    } catch (e) {
                      showSnackbar(
                        LocaleKeys.somethingWentWrong.tr(),
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
