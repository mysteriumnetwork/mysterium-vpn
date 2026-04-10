import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/components/base_app_bar.dart';
import 'package:mysterium_vpn/components/base_layout.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:styled_widget/styled_widget.dart';

class InformationalView extends ConsumerWidget {
  const InformationalView({required this.translationKey, super.key});
  final String translationKey;
  @override
  Widget build(BuildContext context, WidgetRef ref) => BaseLayout(
    header: BaseAppBar(onBackButtonPressed: context.beamBack),
    child: Center(
      child: EasyText(
        translationKey.tr(),
        maxLines: 4,
        color: Palette.purple,
        textAlign: TextAlign.center,
      ).paddingDirectional(all: 20),
    ),
  );
}
