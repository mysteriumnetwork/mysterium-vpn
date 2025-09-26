import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
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
import 'package:mysterium_vpn/services/auth/auth_status.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/vpn_store.dart';
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
      actionWidget: EasyButton(
        text: LocaleKeys.accountSignIn.tr(),
        onPressed: handleSignIn,
      ),
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
    final handleToggleConnection = useHandleToggleConnection();
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
                  if (isLoading) {
                    return const LoadingIndicator();
                  }

                  if (subscriptionStore.subscriptionFuture.status == FutureStatus.rejected) {
                    return SettingActionButton(
                      action: subscriptionStore.refreshSubscription,
                      child: EasyText(
                        LocaleKeys.retryBtn.tr(),
                        color: Palette.white,
                      ),
                    );
                  }

                  if (subscription == null || !subscription.active) {
                    return SettingActionButton(
                      action: handleSubscribe,
                      child: EasyText(
                        LocaleKeys.pricingPlanSeePlansBtn.tr(),
                        color: Palette.white,
                      ),
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
                          child: EasyText(
                            LocaleKeys.goToBillingPage.tr(),
                            color: Palette.white,
                          ),
                          action: () {
                            analyticsStore.logEvent(AnalyticsEvent.manageSubscription);
                            handleSubscribe();
                          },
                        ),
                        SettingActionButton(
                          child: EasyText(
                            LocaleKeys.cancelSubscriptionBtn.tr(),
                            color: Palette.white,
                          ),
                          action: () async {
                            final shouldProceed = await showCancelSubscriptionSurveyDialog(context);
                            if (shouldProceed ?? false) {
                              handleSubscribe();
                            }
                          },
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
              actionWidget: Wrap(
                runSpacing: 10,
                spacing: 10,
                children: [
                  SettingActionButton(
                    child: EasyText(
                      LocaleKeys.logout.tr(),
                      color: Palette.white,
                    ),
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
                          await vpnStore.disconnectFromVpn();
                          authStore.logout();
                        },
                        onCancel: () {
                          analyticsStore.logEvent(AnalyticsEvent.logOutCancel);
                        },
                      );
                    },
                  ),
                  if (subscriptionStore.isSubscribed ?? false)
                    SettingActionButton(
                      action: () => _onDisconnectedAllDevices(
                        context,
                        analyticsStore,
                        vpnStore,
                        handleToggleConnection,
                      ),
                      child: vpnStore.disconnectAllDevicesFuture?.status == FutureStatus.pending
                          ? const LoadingIndicator(
                              radius: 16,
                            )
                          : EasyText(
                              LocaleKeys.disconnectAllDevices.tr(),
                              color: Palette.white,
                            ),
                    ),
                ],
              ),
            ),
            if (!remoteConfigStore.hideDeleteAccount)
              SettingItem(
                asset: Asset.icons.deleteAccount(context),
                title: LocaleKeys.cancelMyAccount.tr(),
                actionWidget: SettingActionButton(
                  child: EasyText(
                    LocaleKeys.deleteAccount.tr(),
                    color: Palette.white,
                  ),
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

  Future<void> _onDisconnectedAllDevices(
    BuildContext context,
    AnalyticsStore analyticsStore,
    VpnStore vpnStore,
    VoidCallback handleToggleConnection,
  ) async {
    analyticsStore.logEvent(AnalyticsEvent.logOutAll);
    shownConfirmationDialog(
      context,
      confirmText: LocaleKeys.confirm.tr(),
      cancelText: LocaleKeys.cancelBtn.tr(),
      title: LocaleKeys.disconnectAllDevicesTitle.tr(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.disconnectAllDevicesDesc.tr(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Palette.black,
            ),
            maxLines: 5,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            LocaleKeys.disconnectAllDevicesConfirmation.tr(),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Palette.black.withValues(alpha: 0.7),
            ),
            maxLines: 5,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      onConfirm: () => _onConfirmDisconnectedAllDevices(
        context,
        analyticsStore,
        vpnStore,
        handleToggleConnection,
      ),
      onCancel: () {
        analyticsStore.logEvent(AnalyticsEvent.logOutAllCancel);
      },
    );
  }

  Future<void> _onConfirmDisconnectedAllDevices(
    BuildContext context,
    AnalyticsStore analyticsStore,
    VpnStore vpnStore,
    VoidCallback handleToggleConnection,
  ) async {
    analyticsStore.logEvent(AnalyticsEvent.logOutAllConfirm);
    try {
      final isConnected = vpnStore.isConnected;
      await vpnStore.disconnectAllDevices();
      showSnackbar(
        LocaleKeys.disconnectAllDevicesSuccess.tr(),
        type: MessageType.success,
        textAlign: TextAlign.start,
        action: isConnected
            ? SnackBarAction(
                label: LocaleKeys.reconnectBtn.tr(),
                backgroundColor: Palette.black,
                textColor: Palette.white,
                onPressed: () async {
                  snackbarKey.currentState?.clearSnackBars();
                  handleToggleConnection();
                  context.beamBack();
                },
              )
            : null,
      );
    } catch (e) {
      showSnackbar(
        LocaleKeys.failedToDisconnectAllDevices.tr(),
      );
    }
  }
}
