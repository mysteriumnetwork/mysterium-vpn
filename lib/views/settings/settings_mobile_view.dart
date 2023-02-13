import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/dialogs/delete_account_dialog.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/header.dart';
import 'package:mysterium_vpn/components/setting_item.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/settings/kill_switch.dart';
import 'package:mysterium_vpn/views/settings/language_picker.dart';
import 'package:mysterium_vpn/views/settings/protocol_picker.dart';
import 'package:mysterium_vpn/views/settings/settings_app_bar.dart';
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
    final killSwitchValue = useState(true);

    return Column(
      children: [
        const SettingsAppBar().padding(bottom: 40),
        Expanded(
            child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: Observer(builder: (context) {
                  final isDarkTheme = themeStore.themeType == ThemeType.dark;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Header(text: LocaleKeys.connection.tr()),
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
                          )),
                      Header(text: LocaleKeys.application.tr()),
                      SettingItem(
                          asset: isDarkTheme ? Assets.languageDark : Assets.languageLight,
                          title: LocaleKeys.appLang.tr(),
                          subtitle: LocaleKeys.shortDesc.tr(),
                          actionWidget: LanguagePicker(
                            store: localeStore,
                          )),
                      SettingItem(
                          asset: isDarkTheme ? Assets.themeDark : Assets.themeLight,
                          title: LocaleKeys.theme.tr(),
                          subtitle: LocaleKeys.theme.tr(),
                          actionWidget: ThemePicker(
                            store: themeStore,
                          )),
                      Header(text: LocaleKeys.account.tr()),
                      SettingItem(
                        asset: isDarkTheme ? Assets.billingDark : Assets.billingLight,
                        title: LocaleKeys.myBillingPackage.tr(),
                        subtitle: LocaleKeys.shortDesc.tr(),
                        actionWidget: EasyButton(
                          width: 160,
                          useSystemColor: false,
                          color: Palette.black,
                          text: LocaleKeys.goToBillingPage.tr(),
                          onPressed: () {},
                        ),
                      ),
                      SettingItem(
                        asset: isDarkTheme ? Assets.accountNameDark : Assets.accountNameLight,
                        title: authStore.email,
                        subtitle: LocaleKeys.shortDesc.tr(),
                        actionWidget: EasyButton(
                          useSystemColor: false,
                          color: Palette.black,
                          text: LocaleKeys.logout,
                          width: 100,
                          onPressed: authStore.logout,
                        ),
                      ),
                      SettingItem(
                        asset: isDarkTheme ? Assets.deleteAccountDark : Assets.deleteAccountLight,
                        title: LocaleKeys.cancelMyAccount.tr(),
                        subtitle: LocaleKeys.shortDesc.tr(),
                        actionWidget: EasyButton(
                          useSystemColor: false,
                          width: 160,
                          color: isDarkTheme ? Palette.pink : Palette.lightBlue,
                          text: LocaleKeys.deleteAccount.tr(),
                          onPressed: () {
                            shownDeleteAccountDialog(context, authStore, isDarkTheme);
                          },
                        ),
                      ),
                    ],
                  ).scrollable();
                }))),
      ],
    );
  }
}
