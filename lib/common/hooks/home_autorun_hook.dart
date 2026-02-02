import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/extensions/navigation_extensions.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/components/dialogs/device_limit_dialog.dart';
import 'package:mysterium_vpn/components/dialogs/marketing_consent_dialog.dart';
import 'package:mysterium_vpn/components/dialogs/push_notifications_dialog.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/user_preferences_store.dart';

void useHomeAutorun() {
  final context = useContext();
  final vpnStore = useProvider(vpnStorePOD);
  final userPreferencesStore = useProvider(userPreferencesStorePOD);
  final remoteConfigStore = useProvider(remoteConfigStorePOD);
  final authSessionStore = useProvider(authSessionStorePOD);
  final pushNotificationsStore = useProvider(pushNotificationsStorePOD);
  return useEffect(
    () {
      final controller = StreamController<Future<Object?> Function()>(sync: true);
      final subscription = controller.stream.asyncMap((it) async {
        // instead of widget binding addPostFrameCallback
        // we use microtask (for simplicity) to ensure dialog is shown
        // after the current frame is rendered
        await Future.microtask(() {});
        return it();
      }).listen((_) {});
      final disposers = <ReactionDisposer>[
        autorun(
          (_) {
            if (!authSessionStore.isAuthenticated) {
              return;
            }
            final value = userPreferencesStore.nextPromptToShow;
            if (value == UserPromptType.none) {
              return;
            }

            if (value case UserPromptType.marketingConsent) {
              controller.add(
                () => showMarketingConsentDialog(context),
              );
            } else if (value case UserPromptType.pushNotifications) {
              controller.add(
                () => showPushNotificationsPermissionDialog(context),
              );
            }
          },
        ),
        autorun((_) {
          final error = vpnStore.fetchConfigFuture?.error;
          if (error is DeviceLimitReachedException) {
            controller.add(() => showDeviceLimitDialog(context));
          }
          return null;
        }),
        autorun((_) {
          final notification = pushNotificationsStore.lastNotification;
          if (notification?.additionalData != null &&
              notification!.additionalData!.containsKey('redirect_url')) {
            final redirectUrl = notification.additionalData!['redirect_url'];
            if (redirectUrl is! String || redirectUrl.isEmpty) {
              return;
            }
            Beamer.of(context).navigateToUrl(redirectUrl, context);
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
    [
      vpnStore,
      userPreferencesStore,
      remoteConfigStore,
      authSessionStore,
    ],
  );
}
