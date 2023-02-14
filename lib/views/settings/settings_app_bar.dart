import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/app_version.dart';
import 'package:mysterium_vpn/components/header.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingsAppBar extends HookConsumerWidget {
  const SettingsAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgIconButton(
          onPressed: () {
            context.beamBack();
          },
          asset: Assets.navigateBack,
        ),
        Header(text: LocaleKeys.settings.tr()),
        const AppVersion(),
      ],
    ).padding(horizontal: 20, top: 20);
  }
}
