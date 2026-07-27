import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

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
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: SvgIcon(asset: asset),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            error is Object ? resolveErrorMessage(error as Object) : S.current.somethingWentWrong,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: theme.textStyles.textMd.bold,
          ),
        ),
        ButtonPrimary(onPressed: onRetry, child: Text(S.current.retryBtn)),
      ],
    );
  }
}
