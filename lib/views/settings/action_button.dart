import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/hooks/future_status_hook.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class SettingActionButton extends HookWidget {
  const SettingActionButton({
    required this.action,
    required this.child,
    this.backgroundColor,
    this.height = 34,
    this.width = 100,
    this.borderRadius = 4,
    super.key,
  });

  final Color? backgroundColor;
  final double height;
  final double width;
  final double borderRadius;
  final FutureOr<void> Function()? action;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final (notifier, status) = useFutureStatus();

    void handlePressed() {
      notifier.run(() async => action?.call());
    }

    return Theme(
      data: DesignSystemTheme.of(context),
      child: ButtonPrimary(
        decoration: ButtonDecoration(
          decorationColor: backgroundColor,
          minimumSize: Size(width, height),
        ),
        size: ButtonSize.small,
        onPressed: action == null || status.isLoading ? null : handlePressed,
        loading: status.isLoading ? const ButtonLoading() : null,
        child: child,
      ),
    );
  }
}
