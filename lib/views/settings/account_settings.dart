import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/dialogs/confirmation_dialog.dart';
import 'package:mysterium_vpn/components/dialogs/delete_account_dialog.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/setting_item.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/settings/purchased_plan.dart';

class AccountSettings extends HookConsumerWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStore = ref.read(themeStorePOD);
    final subscriptionStore = ref.read(subscriptionStorePOD);
    final authStore = ref.watch(authStorePOD);
    final authSessionStore = ref.watch(authSessionStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);
    final remoteConfigStore = ref.read(remoteConfigStorePOD);
    final vpnStore = ref.read(vpnStorePOD);
    final handleToggleConnection = useHandleToggleConnection();
    return Observer(
      builder: (ctx) {
        final isDarkTheme = themeStore.isDarkMode;
        final active = subscriptionStore.subscription?.active ?? false;
        return Column(
          children: [
            SettingItem(
              asset: isDarkTheme ? Assets.billingDark : Assets.billingLight,
              title: LocaleKeys.myBillingPackage.tr(),
              description: subscriptionStore.subscription != null && active
                  ? PurchasedPlan(subscription: subscriptionStore.subscription!)
                  : null,
              actionWidget: HookBuilder(
                builder: (context) {
                  final handleSubscribe = useHandleSubscribe();
                  if (subscriptionStore.isLoading) {
                    return const LoadingIndicator();
                  }

                  if (!active) {
                    return EasyButton(
                      onPressed: handleSubscribe,
                      text: LocaleKeys.pricingPlanSeePlansBtn.tr(),
                    );
                  }

                  return EasyButton(
                    useSystemColor: false,
                    color: Palette.black,
                    text: LocaleKeys.goToBillingPage.tr(),
                    onPressed: () {
                      analyticsStore.logEvent(AnalyticsEvent.manageSubscription);
                      handleSubscribe();
                    },
                  );
                },
              ),
            ),
            SettingItem(
              asset: isDarkTheme ? Assets.accountNameDark : Assets.accountNameLight,
              title: authSessionStore.user?.username ?? '',
              actionWidget: Wrap(
                runSpacing: 10,
                spacing: 10,
                children: [
                  EasyButton(
                    useSystemColor: false,
                    color: Palette.black,
                    width: 100,
                    text: LocaleKeys.logout.tr(),
                    onPressed: () {
                      analyticsStore.logEvent(AnalyticsEvent.logOutPopup);
                      shownConfirmationDialog(
                        context,
                        confirmText: LocaleKeys.confirm.tr(),
                        cancelText: LocaleKeys.cancelBtn.tr(),
                        icon: const SvgIcon(
                          asset: Assets.warning,
                        ),
                        title: LocaleKeys.logoutConfirmationTitle.tr(),
                        content: Text(
                          LocaleKeys.logoutConfirmationDesc.tr(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Palette.black,
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                        onConfirm: () {
                          analyticsStore.logEvent(AnalyticsEvent.logOutConfirm);
                          authStore.logout();
                        },
                        onCancel: () {
                          analyticsStore.logEvent(AnalyticsEvent.logOutCancel);
                        },
                      );
                    },
                  ),
                  if (subscriptionStore.isSubscribed ?? false)
                    EasyButton(
                      useSystemColor: false,
                      color: Palette.black,
                      width: 200,
                      onPressed: () {
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
                                maxLines: 4,
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
                                maxLines: 4,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          onConfirm: () async {
                            analyticsStore.logEvent(AnalyticsEvent.logOutAllConfirm);
                            try {
                              await vpnStore.disconnectAllDevices();
                              showSnackbar(
                                LocaleKeys.disconnectAllDevicesSuccess.tr(),
                                type: MessageType.success,
                                textAlign: TextAlign.start,
                                action: SnackBarAction(
                                  label: LocaleKeys.reconnectBtn.tr(),
                                  backgroundColor: Palette.black,
                                  textColor: Palette.white,
                                  onPressed: () async {
                                    snackbarKey.currentState?.clearSnackBars();
                                    handleToggleConnection();
                                    context.beamBack();
                                  },
                                ),
                              );
                            } catch (e) {
                              showSnackbar(
                                LocaleKeys.failedToDisconnectAllDevices.tr(),
                              );
                            }
                          },
                          onCancel: () {
                            analyticsStore.logEvent(AnalyticsEvent.logOutAllCancel);
                          },
                        );
                      },
                      child: vpnStore.disconnectAllDevicesFuture?.status == FutureStatus.pending
                          ? const LoadingIndicator()
                          : EasyText(
                              LocaleKeys.disconnectAllDevices.tr(),
                              color: Palette.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                    ),
                ],
              ),
            ),
            if (!remoteConfigStore.hideDeleteAccount)
              SettingItem(
                asset: isDarkTheme ? Assets.deleteAccountDark : Assets.deleteAccountLight,
                title: LocaleKeys.cancelMyAccount.tr(),
                actionWidget: EasyButton(
                  useSystemColor: false,
                  color: isDarkTheme ? Palette.pink : Palette.lightBlue,
                  text: LocaleKeys.deleteAccount.tr(),
                  onPressed: () {
                    analyticsStore.logEvent(AnalyticsEvent.deleteAccount);
                    shownDeleteAccountDialog(context, authStore, analyticsStore);
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
