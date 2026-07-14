import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/l10n/arb_locale.dart';
import 'package:mysterium_vpn/l10n/tr_bridge.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/settings/settings_picker_card.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class LanguagePicker extends ConsumerWidget {
  const LanguagePicker({required this.position, super.key});

  final SettingsCardPosition position;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.read(localeStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);

    return Observer(
      builder: (_) => SettingsPickerCard<Locale>(
        key: K.languagePickerCard,
        sheetKey: K.languagePickerSheet,
        itemKeyOf: (locale) => Key('languageOption_${locale.toLanguageTag()}'),
        title: S.current.languageSettingLbl,
        position: position,
        value: store.currentLocale,
        items: supportedLocales,
        labelOf: (locale) => Tr.byKey(_labelKey(locale)),
        onChanged: (locale) async {
          // `localeStore` drives `MaterialApp.locale` and the app.dart reaction
          // that reloads `S`, so setting it here is enough.
          await store.setLocale(locale);
          analyticsStore.logLanguageChange(locale.toLanguageTag());
        },
      ),
    );
  }

  // When two supported locales share a language code (e.g. pt and pt-BR), the
  // country-specific one needs its own label key (`ptBR`) to avoid a duplicate
  // entry; otherwise the language code is the key.
  String _labelKey(Locale locale) {
    final sharesLanguageCode =
        supportedLocales.where((l) => l.languageCode == locale.languageCode).length > 1;
    return sharesLanguageCode && locale.countryCode != null
        ? '${locale.languageCode}${locale.countryCode}'
        : locale.languageCode;
  }
}
