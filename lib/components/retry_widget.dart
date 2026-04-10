import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:styled_widget/styled_widget.dart';

class RetryWdiget extends StatelessWidget {
  const RetryWdiget({required this.onRetry, required this.error, required this.asset, super.key});

  final VoidCallback onRetry;
  final dynamic error;
  final SvgGenImage asset;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SvgIcon(asset: asset).padding(top: 10, bottom: 10),
      EasyText(
        error is Object ? resolveErrorMessage(error as Object) : LocaleKeys.somethingWentWrong.tr(),
        fontSize: 16,
        fontWeight: FontWeight.w700,
        maxLines: 2,
        textAlign: TextAlign.center,
      ).padding(bottom: 12),
      EasyButton(
        useSystemColor: false,
        color: Palette.lightBlack,
        text: LocaleKeys.retryBtn.tr(),
        onPressed: onRetry,
      ),
    ],
  );
}
