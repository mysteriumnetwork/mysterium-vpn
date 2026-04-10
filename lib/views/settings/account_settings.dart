import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/extensions/asset.dart';
import 'package:mysterium_vpn/common/hooks/future_status_hook.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/components/dialogs/cancel_subscription_survey_dialog.dart';
import 'package:mysterium_vpn/components/dialogs/confirmation_dialog.dart';
import 'package:mysterium_vpn/components/dialogs/delete_account_dialog.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/setting_item.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/settings/action_button.dart';
import 'package:mysterium_vpn/views/settings/purchased_plan.dart';

class AccountSettings extends HookConsumerWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authSessionStore = ref.watch(authSessionStorePOD);
    final authStatus = useComputedValue(() => authSessionStore.status);

    return switch (authStatus) {
      AuthStatus.authenticated => const _Authenticated(),
      AuthStatus.unauthenticated => const _Unauthenticated(),
      _ => const SizedBox.shrink(),
    };
  }
}

class _Unauthenticated extends HookConsumerWidget {
  const _Unauthenticated();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void handleSignIn() {
      context.beamToNamed(Routes.platformLogin.path);
    }

    return SettingItem(
      asset: Asset.icons.accountName(context),
      title: LocaleKeys.accountSignInTitle.tr(),
      actionWidget: EasyButton(text: LocaleKeys.accountSignIn.tr(), onPressed: handleSignIn),
    );
  }
}

class _Authenticated extends HookConsumerWidget {
  const _Authenticated();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionStore = ref.read(subscriptionStorePOD);
    final authStore = ref.watch(authStorePOD);
    final authSessionStore = ref.watch(authSessionStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);
    final remoteConfigStore = ref.read(remoteConfigStorePOD);
    final vpnStore = ref.read(vpnStorePOD);
    return Observer(
      builder: (ctx) {
        final subscription = subscriptionStore.subscriptionFuture.value;
        final isLoading = subscriptionStore.subscriptionFuture.status == FutureStatus.pending;
        return Column(
          children: [
            SettingItem(
              asset: Asset.icons.billing(context),
              title: LocaleKeys.myBillingPackage.tr(),
              description: subscription != null && subscription.active
                  ? PurchasedPlan(subscription: subscription)
                  : null,
              actionWidget: HookBuilder(
                builder: (context) {
                  final handleSubscribe = useHandleSubscribe();
                  final (notifier, subscribeStatus) = useFutureStatus();

                  useValueChanged<AsyncSnapshot<void>, void>(subscribeStatus, (_, _) {
                    if (subscribeStatus.hasError) {
                      showSnackbar(LocaleKeys.somethingWentWrong.tr());
                    }
                  });

                  Future<void> onSubscribePress() async {
                    await notifier.runAndAwait(
                      () async =>
                          await handleSubscribe(manageSubscription: subscription?.active ?? false),
                    );
                  }

                  if (isLoading) {
                    return const LoadingIndicator();
                  }

                  if (subscriptionStore.subscriptionFuture.status == FutureStatus.rejected) {
                    return SettingActionButton(
                      action: subscriptionStore.refreshSubscription,
                      child: EasyText(LocaleKeys.retryBtn.tr(), color: Palette.white),
                    );
                  }

                  if (subscription == null || !subscription.active) {
                    return SettingActionButton(
                      action: subscribeStatus.isLoading ? null : onSubscribePress,
                      child: subscribeStatus.isLoading
                          ? const LoadingIndicator()
                          : EasyText(LocaleKeys.pricingPlanSeePlansBtn.tr(), color: Palette.white),
                    );
                  }

                  return ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 250),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      spacing: 16,
                      children: [
                        SettingActionButton(
                          backgroundColor: Palette.purple,
                          action: () async {
                            analyticsStore.logEvent(AnalyticsEvent.manageSubscription);
                            await onSubscribePress();
                          },
                          child: EasyText(LocaleKeys.goToBillingPage.tr(), color: Palette.white),
                        ),
                        SettingActionButton(
                          action: () async {
                            final shouldProceed = await showCancelSubscriptionSurveyDialog(context);
                            if (shouldProceed ?? false) {
                              await onSubscribePress();
                            }
                          },
                          child: EasyText(
                            LocaleKeys.cancelSubscriptionBtn.tr(),
                            color: Palette.white,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            SettingItem(
              asset: Asset.icons.accountName(context),
              title: authSessionStore.user?.username ?? '',
              actionWidget: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 250),
                child: SizedBox(
                  width: double.infinity,
                  child: SettingActionButton(
                    child: EasyText(LocaleKeys.logout.tr(), color: Palette.white),
                    action: () {
                      analyticsStore.logEvent(AnalyticsEvent.logOutPopup);
                      shownConfirmationDialog(
                        context,
                        confirmText: LocaleKeys.confirm.tr(),
                        cancelText: LocaleKeys.cancelBtn.tr(),
                        icon: SvgIcon(asset: Asset.icons.warning),
                        title: LocaleKeys.logoutConfirmationTitle.tr(),
                        content: Text(
                          vpnStore.isConnected
                              ? LocaleKeys.logoutVPNConnectedDesc.tr()
                              : LocaleKeys.logoutConfirmationDesc.tr(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Palette.black,
                          ),
                          maxLines: 5,
                          textAlign: TextAlign.center,
                        ),
                        onConfirm: () async {
                          analyticsStore.logEvent(AnalyticsEvent.logOutConfirm);
                          await vpnStore.disconnectTunnel();
                          authStore.logout();
                        },
                        onCancel: () {
                          analyticsStore.logEvent(AnalyticsEvent.logOutCancel);
                        },
                      );
                    },
                  ),
                ),
              ),
            ),
            if (!remoteConfigStore.hideDeleteAccount)
              SettingItem(
                asset: Asset.icons.deleteAccount(context),
                title: LocaleKeys.cancelMyAccount.tr(),
                actionWidget: SettingActionButton(
                  child: EasyText(LocaleKeys.deleteAccount.tr(), color: Palette.white),
                  action: () {
                    analyticsStore.logEvent(AnalyticsEvent.deleteAccount);
                    shownDeleteAccountDialog(
                      context,
                      authStore: authStore,
                      analyticsStore: analyticsStore,
                      vpnStore: vpnStore,
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
