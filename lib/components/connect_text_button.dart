import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/components/async_text_button.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/location.dart';

class ConnectTextButton extends HookConsumerWidget {
  const ConnectTextButton({
    required this.onPressed,
    required this.location,
    required this.size,
    this.textScaleGroup,
    this.loadingIndicatorRadius = 16,
    this.outlinedButton = false,
    this.borderRadius,
    this.fontStyle,
    super.key,
  });

  final VoidCallback? onPressed;
  final VPNLocation? location;
  final AutoSizeGroup? textScaleGroup;
  final Size size;
  final double loadingIndicatorRadius;
  final bool outlinedButton;
  final double? borderRadius;
  final TextStyle? fontStyle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isConnected = useIsLocationConnected(location);

    void onPressed() {
      this.onPressed?.call();
    }

    return AsyncTextButton(
      isLoading: isConnected == null,
      minimumSize: size,
      textScaleGroup: textScaleGroup,
      borderRadius: borderRadius == null ? null : BorderRadius.circular(borderRadius!),
      text: (isConnected ?? false) ? LocaleKeys.disconnect.tr() : LocaleKeys.connect.tr(),
      mode: (isConnected ?? true)
          ? AsyncTextButtonMode.filled
          : outlinedButton
              ? AsyncTextButtonMode.outlined
              : AsyncTextButtonMode.elevated,
      onPressed: isConnected == null ? null : onPressed,
    );
  }
}
