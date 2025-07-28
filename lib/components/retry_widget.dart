import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:styled_widget/styled_widget.dart';

class RetryWdiget extends StatelessWidget {
  const RetryWdiget({
    required this.onRetry,
    required this.error,
    required this.asset,
    super.key,
  });

  final VoidCallback onRetry;
  final dynamic error;
  final String asset;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgIcon(
            asset: asset,
          ).padding(top: 10, bottom: 10),
          ErrorText(
            error: error,
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

class ErrorText extends StatelessWidget {
  const ErrorText({
    required this.error,
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
  });
  final dynamic error;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;

  String _getErrorMessage(error) {
    if (error is DioException) {
      return error.message ?? LocaleKeys.somethingWentWrong.tr();
    } else if (error is ApiException) {
      return error.message;
    } else if (error is Exception) {
      return error.toString();
    } else if (error is String) {
      return error;
    }
    return LocaleKeys.somethingWentWrong.tr();
  }

  @override
  Widget build(BuildContext context) => EasyText(
        _getErrorMessage(error),
        fontSize: 16,
        fontWeight: FontWeight.w700,
        maxLines: 2,
        textAlign: TextAlign.center,
      );
}
