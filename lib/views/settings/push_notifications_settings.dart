import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/auth/auth_status.dart';
import 'package:mysterium_vpn/views/settings/switch_item.dart';

class PushNotificationsSetting extends HookConsumerWidget {
  const PushNotificationsSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authSessionStore = ref.watch(authSessionStorePOD);
    final authStatus = useComputedValue(() => authSessionStore.status);
    final userPreferencesStore = ref.watch(userPreferencesStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);
    return Observer(
      builder: (context) => Visibility(
        visible: Platform.isAndroid &&
            authStatus == AuthStatus.authenticated &&
            userPreferencesStore.pushNotificationsPermissionGranted != null,
        child: SwitchItem(
          asset: Asset.icons.notification(context),
          title: 'Push Notifications',
          subtitle: 'VPN Status, Server Alerts, and Special Offers',
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
      ),
    );
  }
}
