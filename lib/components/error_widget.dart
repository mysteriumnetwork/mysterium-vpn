import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/hooks/future_status_hook.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
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
        Text(
          error,
          maxLines: 4,
          style: theme.textStyles.textSm.semibold,
          textAlign: TextAlign.center,
        ).padding(bottom: 20),
        ButtonPrimary(
          loading: status.isLoading ? const ButtonLoading() : null,
          onPressed: () => notifier.run(onRetry),
          child: Text(S.current.tryAgainBtn),
        ),
      ],
    ).paddingDirectional(all: 20).center();
  }
}
