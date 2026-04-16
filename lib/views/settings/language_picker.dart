import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/screen_type.dart';
import 'package:mysterium_vpn/components/easy_dropdown.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/picker_bottom_sheet.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide ScreenType;

class LanguagePicker extends ConsumerWidget {
  const LanguagePicker({required this.position, super.key});

  final SettingsCardPosition position;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.read(localeStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);

    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;
    final theme = Theme.of(context);
    final title = LocaleKeys.languageSettingLbl.tr();

    Future<void> onChange(Locale locale) async {
      await context.setLocale(locale);
      await store.setLocale(locale);
      analyticsStore.logLanguageChange(locale.languageCode);
    }

    if (isDesktop) {
      return SettingsCard(
        title: title,
        position: position,
        trailing: Observer(
          builder: (_) => EasyDropdown<Locale>(
            value: store.currentLocale,
            onChanged: (Locale? locale) async {
              if (locale == null) {
                return;
              }
              await onChange(locale);
            },
            items: kSupportedLocales
                .map<DropdownMenuItem<Locale>>(
                  (locale) => DropdownMenuItem<Locale>(
                    value: locale,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: EasyText(locale.languageCode.tr()),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      );
    }

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => showPickerBottomSheet<Locale>(
        context: context,
        title: title,
        items: kSupportedLocales,
        value: store.currentLocale,
        labelOf: (locale) => locale.languageCode.tr(),
        onChanged: onChange,
      ),
      child: SettingsCard(
        title: title,
        position: position,
        trailing: Icon(UntitledUI.chevron_right, size: 24, color: theme.palette.iconTertiary),
      ),
    );
  }
}
