import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
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

    return switch (isConnected) {
      false => outlinedButton
          ? OutlinedButton(
              onPressed: onPressed,
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(6),
                minimumSize: size,
                shape: borderRadius != null
                    ? RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(borderRadius!),
                      )
                    : null,
              ),
              child: AutoSizeText(
                LocaleKeys.connect.tr(),
                group: textScaleGroup,
                style: fontStyle ??
                    TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: context.c.isDarkMode ? Palette.white : Palette.purple,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                minimumSize: size,
                backgroundColor: Palette.purple,
                elevation: 0,
              ),
              child: AutoSizeText(
                LocaleKeys.connect.tr(),
                group: textScaleGroup,
                style: fontStyle ??
                    const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Palette.white,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
      true => FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            minimumSize: size,
            padding: const EdgeInsets.all(6),
          ),
          child: AutoSizeText(
            LocaleKeys.disconnect.tr(),
            group: textScaleGroup,
            style: fontStyle ??
                const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      null => FilledButton(
          onPressed: null,
          style: FilledButton.styleFrom(minimumSize: size),
          child: const LoadingIndicator(radius: 14),
        ),
    };
  }
}
