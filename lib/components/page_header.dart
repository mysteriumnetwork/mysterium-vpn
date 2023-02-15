import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/app_version.dart';
import 'package:mysterium_vpn/components/header_title.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:styled_widget/styled_widget.dart';

class PageHeader extends HookConsumerWidget {
  const PageHeader({super.key, required this.headerTitle});
  final String headerTitle;
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
        HeaderTitle(text: headerTitle, color: Palette.white),
        const AppVersion(),
      ],
    ).padding(horizontal: 20);
  }
}
