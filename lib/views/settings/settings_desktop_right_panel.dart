import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/circle_box.dart';
import 'package:mysterium_vpn/components/dialogs/delete_account_dialog.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/setting_item.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/settings/kill_switch.dart';
import 'package:mysterium_vpn/views/settings/language_picker.dart';
import 'package:mysterium_vpn/views/settings/protocol_picker.dart';
import 'package:mysterium_vpn/views/settings/settings_desktop_view.dart';
import 'package:mysterium_vpn/views/settings/theme_picker.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingsDesktopRightPanel extends HookConsumerWidget {
  const SettingsDesktopRightPanel({
    required this.settingCategory,
    super.key,
  });
  final ValueNotifier<SettingCategory> settingCategory;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStore = ref.read(themeStorePOD);
    final vpnStore = ref.read(vpnStorePOD);
    final localeStore = ref.read(localeStorePOD);
    final authStore = ref.watch(authStorePOD);
    final subscriptionStore = ref.watch(subscriptionStorePOD);
    final environment = ref.watch(environmentPOD);
    return Observer(
      builder: (context) {
        final isDarkTheme = themeStore.isDarkMode;
        return Column(
          children: [
            _HeaderTitle(
              title: settingCategory.value.trKey.tr(),
            ).padding(bottom: 80),
            if (settingCategory.value == SettingCategory.connection) ...[
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
            if (settingCategory.value == SettingCategory.application) ...[
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
            ],
            if (settingCategory.value == SettingCategory.account) ...[
              SettingItem(
                asset: isDarkTheme ? Assets.billingDark : Assets.billingLight,
                title: LocaleKeys.myBillingPackage.tr(),
                subtitle: LocaleKeys.shortDesc.tr(),
                actionWidget: EasyButton(
                  useSystemColor: false,
                  color: Palette.black,
                  text: LocaleKeys.goToBillingPage.tr(),
                  onPressed: () => handleOnBillingPage(
                    billingPage: environment.values.billingPage,
                    context: context,
                    gateway: subscriptionStore.subscription?.gateway,
                    subscriptionActive: subscriptionStore.subscription?.active ?? false,
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
          ],
        )
            .scrollable()
            .padding(horizontal: 40, vertical: 40)
            .height(getMediaHeight(context))
            .backgroundColor(Theme.of(context).colorScheme.background);
      },
    );
  }
}

class _HeaderTitle extends StatelessWidget {
  const _HeaderTitle({
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          EasyText(
            LocaleKeys.settings.tr(),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
          CircleBox(
            size: 8,
            color: Theme.of(context).secondaryHeaderColor,
          ).padding(horizontal: 14),
          EasyText(
            title,
            fontSize: 20,
            fontWeight: FontWeight.w300,
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ],
      );
}
