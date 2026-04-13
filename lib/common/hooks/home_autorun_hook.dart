import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/enums/message_type.dart';
import 'package:mysterium_vpn/core/exceptions/exceptions.dart';
import 'package:mysterium_vpn/core/extensions/navigation_extensions.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/shared/components/dialogs/device_limit_dialog.dart';
import 'package:mysterium_vpn/shared/components/dialogs/marketing_consent_dialog.dart';
import 'package:mysterium_vpn/shared/components/dialogs/push_notifications_dialog.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/pages/subscription_upgrade_modal_page.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/notifications/store/push_notifications_store.dart';
import 'package:mysterium_vpn/features/settings/store/user_preferences_store.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_store.dart';

void useHomeAutorun() {
  final context = useContext();
  final vpnStore = useProvider<VpnStore>(vpnStorePOD);
  final userPreferencesStore = useProvider<UserPreferencesStore>(userPreferencesStorePOD);
  final authSessionStore = useProvider<AuthSessionStore>(authSessionStorePOD);
  final pushNotificationsStore = useProvider<PushNotificationsStore>(pushNotificationsStorePOD);

  return useEffect(
    () {
      final controller = StreamController<Future<Object?> Function()>(sync: true);
      final subscription = controller.stream
          .asyncMap((it) async {
            // instead of widget binding addPostFrameCallback
            // we use microtask (for simplicity) to ensure dialog is shown
            // after the current frame is rendered
            await Future.microtask(() {});
            return it();
          })
          .listen((_) {});
      final disposers = <ReactionDisposer>[
        autorun((_) {
          if (!authSessionStore.isAuthenticated) {
            return;
          }
          final value = userPreferencesStore.nextPromptToShow;
          if (value == UserPromptType.none) {
            return;
          }

          // Only show dialog if not already shown
          if (!userPreferencesStore.isPromptShown(value)) {
            userPreferencesStore.markPromptAsShown(value);

            if (value case UserPromptType.marketingConsent) {
              controller.add(() => showMarketingConsentDialog(context));
            } else if (value case UserPromptType.pushNotifications) {
              controller.add(() => showPushNotificationsPermissionDialog(context));
            }
          }
        }),
        autorun((_) {
          final error = vpnStore.fetchConfigFuture?.error;
          if (error is DeviceLimitReachedException && !vpnStore.isDeviceLimitErrorShown) {
            vpnStore.markDeviceLimitErrorAsShown();
            controller.add(() => showDeviceLimitDialog(context));
          }
          return null;
        }),
        autorun((_) {
          final notification = pushNotificationsStore.lastNotification;
          if (notification?.id == pushNotificationsStore.lastShownPushNotificationId) {
            return;
          }
          pushNotificationsStore.lastShownPushNotificationId = notification?.id;
          if (notification?.additionalData != null) {
            if (notification!.additionalData!.containsKey('redirect_url')) {
              final redirectUrl = notification.additionalData!['redirect_url'];
              if (redirectUrl is! String || redirectUrl.isEmpty) {
                return;
              }
              Beamer.of(context).navigateToUrl(
                url: redirectUrl,
                context: context,
                isAuthenticated: authSessionStore.isAuthenticated,
                accessToken: authSessionStore.accessToken,
              );
            } else if (notification.additionalData!.containsKey('coupon_code')) {
              final couponCode = notification.additionalData!['coupon_code'];
              if (couponCode is! String || couponCode.isEmpty) {
                return;
              }
              if (!authSessionStore.isAuthenticated) {
                return;
              }
              FlutterClipboard.copy(couponCode).then((value) {
                showSnackbar(
                  LocaleKeys.couponCodeCopied.tr(namedArgs: {'couponCode': '"$couponCode"'}),
                  type: MessageType.success,
                );
                if (context.mounted) {
                  showSubscriptionUpgradeModalPage(context);
                }
              });
            }
          }
        }),
      ];

      return () async {
        for (final dispose in disposers) {
          dispose();
        }
        await subscription.cancel();
        await controller.close();
      };
    },
    // Empty dependency array - disposers are only set up once
    // MobX reactions handle their own reactivity without needing widget rebuild
    [],
  );
}
