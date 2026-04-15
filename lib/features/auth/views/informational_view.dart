import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:styled_widget/styled_widget.dart';

class InformationalView extends StatelessWidget {
  const InformationalView({required this.translationKey, super.key});
  final String translationKey;
  @override
  Widget build(BuildContext context) => BaseLayout(
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
