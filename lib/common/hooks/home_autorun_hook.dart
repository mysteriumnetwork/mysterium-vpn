import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/extensions/navigation_extensions.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/pages/subscription_upgrade_modal_page.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/campaign/campaign_view.dart';
import 'package:mysterium_vpn/views/vpn_error_message.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

void useHomeAutorun() {
  final context = useContext();
  final vpnStore = useProvider<VpnStore>(vpnStorePOD);
  final userPreferencesStore = useProvider<UserPreferencesStore>(userPreferencesStorePOD);
  final authSessionStore = useProvider<AuthSessionStore>(authSessionStorePOD);
  final pushNotificationsStore = useProvider<PushNotificationsStore>(pushNotificationsStorePOD);
  final reviewPromptStore = useProvider<ReviewPromptStore>(reviewPromptStorePOD);
  final subscriptionOnboardingStore = useProvider(subscriptionOnboardingStorePOD);
  // Captured against the home view's context so it survives the onboarding
  // dialog being popped — invoking it inside the dialog would race with the
  // route's disposal and short-circuit at `context.mounted`.
  final handleSubscribe = useHandleSubscribe();

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

            if (value case UserPromptType.noneSubsOnboarding) {
              controller.add(() async {
                final initialStep = await userPreferencesStore.getNoneSubsOnboardingStep();
                if (!context.mounted) {
                  return null;
                }
                final shouldSubscribe = await showOnboardingDialog(
                  context,
                  initialStep: initialStep,
                );
                // Force-quit kills the process before reaching this line, so
                // the in-progress step persisted from the dialog survives.
                await userPreferencesStore.setNoneSubsOnboardingCompleted();
                if (shouldSubscribe == true && context.mounted) {
                  await handleSubscribe();
                }
                return null;
              });
            } else if (value case UserPromptType.marketingConsent) {
              controller.add(() => showMarketingConsentDialog(context));
            } else if (value case UserPromptType.pushNotifications) {
              controller.add(() => showPushNotificationsPermissionDialog(context));
            } else if (value case UserPromptType.subscriptionOnboarding) {
              controller.add(() async => subscriptionOnboardingStore.showSubscriptionOnboarding());
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
        // Translate + surface store-emitted connection errors here, so
        // `VpnStore` stays translation-free. A `reaction` (not `autorun`) so a
        // stale error left unconsumed while Home was unmounted isn't replayed
        // out of context when it remounts — it only fires on new emissions.
        reaction((_) => vpnStore.connectionError, (error) {
          if (error != null) {
            showSnackbar(vpnErrorMessage(error));
            vpnStore.consumeConnectionError();
          }
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
            } else if (notification.additionalData!.containsKey('campaign_url')) {
              final campaignUrl = notification.additionalData!['campaign_url'];
              if (campaignUrl is! String || campaignUrl.isEmpty) {
                return;
              }
              final couponCode = notification.additionalData!['coupon_code'];
              if (couponCode is! String || couponCode.isEmpty) {
                return;
              }

              showCampaignDialog(context, Uri.parse(campaignUrl), couponCode);
            } else if (notification.additionalData!.containsKey('coupon_code')) {
              final couponCode = notification.additionalData!['coupon_code'];
              if (couponCode is! String || couponCode.isEmpty) {
                return;
              }
              if (!authSessionStore.isAuthenticated) {
                return;
              }
              Clipboard.setData(ClipboardData(text: couponCode)).then((value) {
                showSnackbar(
                  S.current.couponCodeCopied('"$couponCode"'),
                  type: SnackbarType.success,
                );
                if (context.mounted) {
                  showSubscriptionUpgradeModalPage(context);
                }
              });
            }
          }
        }),
        autorun((_) {
          if (!reviewPromptStore.pendingPrompt) {
            return;
          }
          controller.add(() async {
            if (!context.mounted) {
              return null;
            }
            // Suppress while a flow is on top of home (onboarding, paywall /
            // checkout, subscription, cancellation, …): only show when home is
            // the active route.
            if (!(ModalRoute.of(context)?.isCurrent ?? true)) {
              await reviewPromptStore.onSuppressedByActiveFlow();
              return null;
            }
            await showReviewPromptDialog(context);
            return null;
          });
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
