import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/setting_item.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/settings/language_picker.dart';
import 'package:mysterium_vpn/views/settings/theme_picker.dart';

class ApplicationSettings extends HookConsumerWidget {
  const ApplicationSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStore = ref.read(themeStorePOD);
    final localeStore = ref.read(localeStorePOD);
    return Observer(
      builder: (context) {
        final isDarkTheme = themeStore.isDarkMode;

        return Column(
          children: [
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
        );
      },
    );
  }
}
