import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:styled_widget/styled_widget.dart';

class RetryOnErrorWidget extends StatefulWidget {
  const RetryOnErrorWidget({required this.error, required this.onRetry, super.key});

  final String error;
  final FutureOr<void> Function() onRetry;

  @override
  State<RetryOnErrorWidget> createState() => _RetryOnErrorWidgetState();
}

class _RetryOnErrorWidgetState extends State<RetryOnErrorWidget> {
  bool _isLoading = false;

  Future<void> _handleRetry() async {
    setState(() => _isLoading = true);
    try {
      await widget.onRetry();
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          widget.error,
          maxLines: 4,
          style: theme.textStyles.textSm.semibold,
          textAlign: TextAlign.center,
        ).padding(bottom: 20),
        ButtonPrimary(
          loading: _isLoading ? const ButtonLoading() : null,
          onPressed: _handleRetry,
          child: Text(LocaleKeys.tryAgainBtn.tr()),
        ),
      ],
    ).paddingDirectional(all: 20).center();
  }
}
