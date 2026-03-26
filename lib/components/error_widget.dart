import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/hooks/future_status_hook.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:styled_widget/styled_widget.dart';

class RetryOnErrorWidget extends HookWidget {
  const RetryOnErrorWidget({required this.error, required this.onRetry, super.key});

  final String error;
  final FutureOr<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (notifier, status) = useFutureStatus();

    Future<void> onRetry() async {
      await this.onRetry();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        EasyText(
          error,
          maxLines: 4,
          color: theme.palette.textErrorPrimary,
          textAlign: TextAlign.center,
          fontWeight: FontWeight.w700,
        ).padding(bottom: 20),
        ButtonPrimary(
          decoration: ButtonDecoration(decorationColor: theme.palette.borderError),
          loading: status.isLoading ? const ButtonLoading() : null,
          onPressed: () => notifier.run(onRetry),
          child: Text(LocaleKeys.tryAgainBtn.tr()),
        ),
      ],
    ).paddingDirectional(all: 20).center();
  }
}
