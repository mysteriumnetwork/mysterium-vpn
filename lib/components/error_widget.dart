import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:styled_widget/styled_widget.dart';

class RetryOnErrorWidget extends StatelessWidget {
  const RetryOnErrorWidget({
    required this.error,
    required this.onRetry,
    super.key,
  });
  final String error;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EasyText(
            error,
            maxLines: 4,
            color: Palette.pink,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w700,
          ).padding(bottom: 20),
          EasyButton(
            width: 200,
            text: LocaleKeys.tryAgainBtn.tr(),
            onPressed: onRetry,
          ),
        ],
      ).paddingDirectional(all: 20).center();
}
