import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/circle_box.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/views/settings/account_settings.dart';
import 'package:mysterium_vpn/views/settings/application_settings.dart';
import 'package:mysterium_vpn/views/settings/connection_settings.dart';
import 'package:mysterium_vpn/views/settings/settings_desktop_view.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingsDesktopRightPanel extends HookConsumerWidget {
  const SettingsDesktopRightPanel({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingCategory = ref.watch(selectedCategoryProvider);
    return Column(
      children: [
        _HeaderTitle(
          title: settingCategory.trKey.tr(),
        ).padding(bottom: 80),
        if (settingCategory == SettingCategory.connection) const ConnectionSettings(),
        if (settingCategory == SettingCategory.application) const ApplicationSettings(),
        if (settingCategory == SettingCategory.account) const AccountSettings(),
      ],
    )
        .scrollable()
        .padding(horizontal: 40, vertical: 40)
        .height(getMediaHeight(context))
        .backgroundColor(Theme.of(context).colorScheme.background);
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
