import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/base_layout.dart';
import 'package:mysterium_vpn/components/dialogs/delete_account_dialog.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/header_title.dart';
import 'package:mysterium_vpn/components/setting_item.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/settings/kill_switch.dart';
import 'package:mysterium_vpn/views/settings/language_picker.dart';
import 'package:mysterium_vpn/views/settings/protocol_picker.dart';
import 'package:mysterium_vpn/views/settings/theme_picker.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingsMobileView extends HookConsumerWidget {
  const SettingsMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStore = ref.read(themeStorePOD);
    final vpnStore = ref.read(vpnStorePOD);
    final localeStore = ref.read(localeStorePOD);
    final authStore = ref.watch(authStorePOD);
    final subscriptionStore = ref.watch(subscriptionStorePOD);
    final environment = ref.watch(environmentPOD);
    return BaseLayout(
      headerTitle: LocaleKeys.settings.tr(),
      child: Observer(
        builder: (context) {
          final isDarkTheme = themeStore.isDarkMode;
          return Column(
            children: [
              Visibility(
                visible: false,
                child: Column(
                  children: [
                    HeaderTitle(text: LocaleKeys.connection.tr()),
                    KillSwitchItem(
                      asset: isDarkTheme ? Assets.killSwitchDark : Assets.killSwitchLight,
                      title: LocaleKeys.killSwitch.tr(),
                      subtitle: LocaleKeys.shortDesc.tr(),
                      store: vpnStore,
                    ),
                    SettingItem(
                      asset: isDarkTheme ? Assets.protocolDark : Assets.protocolLight,
                      title: LocaleKeys.protocol.tr(),
                      subtitle: LocaleKeys.shortDesc.tr(),
                      actionWidget: ProtocolPicker(
                        store: vpnStore,
                      ),
                    ),
                  ],
                ),
              ),
              HeaderTitle(text: LocaleKeys.application.tr()),
              SettingItem(
                asset: isDarkTheme ? Assets.languageDark : Assets.languageLight,
                title: LocaleKeys.appLang.tr(),
                subtitle: LocaleKeys.shortDesc.tr(),
                actionWidget: LanguagePicker(
                  store: localeStore,
                ),
              ),
              SettingItem(
                asset: isDarkTheme ? Assets.themeDark : Assets.themeLight,
                title: LocaleKeys.theme.tr(),
                subtitle: LocaleKeys.theme.tr(),
                actionWidget: ThemePicker(
                  store: themeStore,
                ),
              ),
              HeaderTitle(text: LocaleKeys.account.tr()),
              SettingItem(
                asset: isDarkTheme ? Assets.billingDark : Assets.billingLight,
                title: LocaleKeys.myBillingPackage.tr(),
                subtitle: LocaleKeys.shortDesc.tr(),
                actionWidget: EasyButton(
                  height: 40,
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
                  height: 40,
                  onPressed: authStore.logout,
                ),
              ),
              SettingItem(
                asset: isDarkTheme ? Assets.deleteAccountDark : Assets.deleteAccountLight,
                title: LocaleKeys.cancelMyAccount.tr(),
                subtitle: LocaleKeys.shortDesc.tr(),
                actionWidget: EasyButton(
                  useSystemColor: false,
                  height: 40,
                  color: isDarkTheme ? Palette.pink : Palette.lightBlue,
                  text: LocaleKeys.deleteAccount.tr(),
                  onPressed: () {
                    shownDeleteAccountDialog(context, authStore);
                  },
                ),
              ),
            ],
          ).scrollable();
        },
      ),
    );
  }
}
