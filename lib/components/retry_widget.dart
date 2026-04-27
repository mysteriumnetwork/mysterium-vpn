import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:styled_widget/styled_widget.dart';

class RetryWdiget extends StatelessWidget {
  const RetryWdiget({required this.onRetry, required this.error, required this.asset, super.key});

  final VoidCallback onRetry;
  final dynamic error;
  final SvgGenImage asset;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgIcon(asset: asset).padding(top: 10, bottom: 10),
        Text(
          error is Object
              ? resolveErrorMessage(error as Object)
              : LocaleKeys.somethingWentWrong.tr(),
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: theme.textStyles.textMd.bold,
        ).padding(bottom: 12),
        ButtonPrimary(onPressed: onRetry, child: Text(LocaleKeys.retryBtn.tr())),
      ],
    );
  }
}
