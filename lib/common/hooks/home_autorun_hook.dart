import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/screen_type.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/screen_type_hook.dart';
import 'package:mysterium_vpn/components/dialogs/info_dialog.dart';
import 'package:mysterium_vpn/components/dialogs/marketing_consent_dialog.dart';
import 'package:mysterium_vpn/components/dialogs/push_notifications_dialog.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/pages/subscription_upgrade_page.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/user_preferences_store.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

void useHomeAutorun() {
  final context = useContext();
  final vpnStore = useProvider(vpnStorePOD);
  final userPreferencesStore = useProvider(userPreferencesStorePOD);
  final remoteConfigStore = useProvider(remoteConfigStorePOD);
  final subscriptionUpgradeStore = useProvider(subscriptionUpgradeStorePOD);
  final subscriptionUpgradeShown = useRef(false);
  final screenType = useScreenType();

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
            final limitExceeded = vpnStore.vpnConfig?.limitExceeded ?? false;
            if (limitExceeded && vpnStore.vpnStatus == ConnectionStatus.connected) {
              controller.add(() => _showOrSkipConnectionLimitDialog(context));
            }
          },
        ),
        autorun(
          (_) {
            final value = userPreferencesStore.nextPromptToShow;
            if (value == UserPromptType.none) {
              return;
            }
            final isDesktop = screenType == ScreenType.desktop;

            if (value case UserPromptType.marketingConsent) {
              controller.add(
                () => showMarketingConsentDialog(
                  context,
                  desktopSize: isDesktop,
                ),
              );
            } else if (value case UserPromptType.pushNotifications) {
              controller.add(
                () => showPushNotificationsPermissionDialog(
                  context,
                  desktopSize: isDesktop,
                ),
              );
            }
          },
        ),
        autorun(
          (_) {
            if (subscriptionUpgradeShown.value) {
              return;
            }
            if (!remoteConfigStore.subscriptionUpgradeAutoDisplayEnabled) {
              return;
            }
            if (!subscriptionUpgradeStore.isEligibleForUpgrade) {
              return;
            }

            subscriptionUpgradeShown.value = true;
            controller.add(() => showSubscriptionUpgradePage(context));
          },
        ),
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
      subscriptionUpgradeStore,
      subscriptionUpgradeShown,
    ],
  );
}

Future<void> _showOrSkipConnectionLimitDialog(BuildContext context) async {
  await shownInfoDialog(
    context,
    LocaleKeys.connectionLimitExceededTitle.tr(),
    messages: [LocaleKeys.connectionLimitExceededDesc.tr()],
    isDismissible: true,
    confirmText: LocaleKeys.iUnderstandBtn.tr(),
  );
}
