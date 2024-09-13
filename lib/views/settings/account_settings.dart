import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/dialogs/confirmation_dialog.dart';
import 'package:mysterium_vpn/components/dialogs/delete_account_dialog.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
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
    final environment = ref.watch(environmentPOD);
    final authStore = ref.watch(authStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);
    return Observer(
      builder: (context) {
        final isDarkTheme = themeStore.isDarkMode;
        final gateway = subscriptionStore.subscription?.gateway;
        final active = subscriptionStore.subscription?.active ?? false;
        return Column(
          children: [
            SettingItem(
              asset: isDarkTheme ? Assets.billingDark : Assets.billingLight,
              title: LocaleKeys.myBillingPackage.tr(),
              description: subscriptionStore.subscription != null && active
                  ? PurchasedPlan(subscription: subscriptionStore.subscription!)
                  : null,
              actionWidget: Visibility(
                visible: !Platform.isMacOS || (isMobilePaymentGateway(gateway) || gateway == null),
                child: EasyButton(
                  useSystemColor: false,
                  color: Palette.black,
                  text: LocaleKeys.goToBillingPage.tr(),
                  onPressed: () {
                    handleOnBillingPage(
                      billingPage: environment.values.billingPage,
                      context: context,
                      gateway: gateway,
                      subscriptionActive: active,
                      accessToken: authStore.authData?.accessToken,
                    );
                  },
                ),
              ),
            ),
            SettingItem(
              asset: isDarkTheme ? Assets.accountNameDark : Assets.accountNameLight,
              title: authStore.authData?.username ?? '',
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
                  EasyButton(
                    useSystemColor: false,
                    color: Palette.black,
                    text: LocaleKeys.logoutAllDevices.tr(),
                    width: 200,
                    onPressed: () {
                      analyticsStore.logEvent(AnalyticsEvent.logOutAll);
                      shownConfirmationDialog(
                        context,
                        confirmText: LocaleKeys.confirm.tr(),
                        cancelText: LocaleKeys.cancelBtn.tr(),
                        icon: const SvgIcon(
                          asset: Assets.warning,
                        ),
                        title: LocaleKeys.logoutAllDevicesConfirmationTitle.tr(),
                        content: Text(
                          LocaleKeys.logoutAllDevicesConfirmationDesc.tr(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Palette.black,
                          ),
                          maxLines: 2,
                          textAlign: TextAlign.center,
                        ),
                        onConfirm: authStore.logoutFromAllDevices,
                      );
                    },
                  ),
                ],
              ),
            ),
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
