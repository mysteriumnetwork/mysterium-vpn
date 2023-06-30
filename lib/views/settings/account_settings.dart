import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/dialogs/delete_account_dialog.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/setting_item.dart';
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
    return Observer(
      builder: (context) {
        final isDarkTheme = themeStore.isDarkMode;

        return Column(
          children: [
            SettingItem(
              asset: isDarkTheme ? Assets.billingDark : Assets.billingLight,
              title: LocaleKeys.myBillingPackage.tr(),
              subtitle: LocaleKeys.shortDesc.tr(),
              description:
                  subscriptionStore.subscription != null && subscriptionStore.subscription!.active
                      ? PurchasedPlan(subscription: subscriptionStore.subscription!)
                      : null,
              actionWidget: EasyButton(
                useSystemColor: false,
                color: Palette.black,
                text: LocaleKeys.goToBillingPage.tr(),
                onPressed: () => handleOnBillingPage(
                  billingPage: environment.values.billingPage,
                  context: context,
                  gateway: subscriptionStore.subscription?.gateway,
                  subscriptionActive: subscriptionStore.subscription?.active ?? false,
                  accessToken: authStore.authData?.accessToken,
                ),
              ),
            ),
            SettingItem(
              asset: isDarkTheme ? Assets.accountNameDark : Assets.accountNameLight,
              title: authStore.authData?.username ?? '',
              subtitle: LocaleKeys.shortDesc.tr(),
              actionWidget: EasyButton(
                useSystemColor: false,
                color: Palette.black,
                text: LocaleKeys.logout.tr(),
                onPressed: authStore.logout,
              ),
            ),
            SettingItem(
              asset: isDarkTheme ? Assets.deleteAccountDark : Assets.deleteAccountLight,
              title: LocaleKeys.cancelMyAccount.tr(),
              subtitle: LocaleKeys.shortDesc.tr(),
              actionWidget: EasyButton(
                useSystemColor: false,
                color: isDarkTheme ? Palette.pink : Palette.lightBlue,
                text: LocaleKeys.deleteAccount.tr(),
                onPressed: () {
                  shownDeleteAccountDialog(context, authStore);
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
