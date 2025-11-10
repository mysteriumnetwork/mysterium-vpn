import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';

enum AsyncTextButtonMode {
  outlined,
  filled,
  elevated;
}

class AsyncTextButton extends HookWidget {
  const AsyncTextButton({
    required this.text,
    required this.mode,
    required this.onPressed,
    this.isLoading = false,
    this.minimumSize = const Size(100, 36),
    this.borderRadius,
    this.textScaleGroup,
    super.key,
  });

  final String text;
  final AsyncTextButtonMode mode;
  final bool isLoading;
  final Size minimumSize;
  final BorderRadius? borderRadius;
  final AutoSizeGroup? textScaleGroup;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final mode = isLoading ? AsyncTextButtonMode.filled : this.mode;
    final child = isLoading
        ? const LoadingIndicator(radius: 14)
        : _Label(text: text, mode: mode, textScaleGroup: textScaleGroup);

    return switch (mode) {
      AsyncTextButtonMode.outlined => OutlinedButton(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.all(6),
            minimumSize: minimumSize,
            shape: borderRadius == null
                ? null
                : RoundedRectangleBorder(
                    borderRadius: borderRadius!,
                  ),
          ),
          child: child,
        ),
      AsyncTextButtonMode.filled => FilledButton(
          onPressed: onPressed,
          style: FilledButton.styleFrom(
            padding: isLoading ? null : const EdgeInsets.all(6),
            minimumSize: minimumSize,
            shape: borderRadius == null
                ? null
                : RoundedRectangleBorder(
                    borderRadius: borderRadius!,
                  ),
          ),
          child: child,
        ),
      AsyncTextButtonMode.elevated => ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            padding: const EdgeInsets.all(6),
            minimumSize: minimumSize,
            backgroundColor: Palette.purple,
            foregroundColor: Palette.white,
            shape: borderRadius == null
                ? null
                : RoundedRectangleBorder(
                    borderRadius: borderRadius!,
                  ),
          ),
          child: child,
        ),
    };
  }
}

class _Label extends StatelessWidget {
  const _Label({
    required this.text,
    required this.mode,
    required this.textScaleGroup,
  });

  final String text;
  final AsyncTextButtonMode mode;
  final AutoSizeGroup? textScaleGroup;

  @override
  Widget build(BuildContext context) => AutoSizeText(
        text,
        group: textScaleGroup,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontSize: switch (mode) {
            AsyncTextButtonMode.elevated => 14,
            _ => 12,
          },
          fontWeight: switch (mode) {
            AsyncTextButtonMode.elevated => FontWeight.w600,
            _ => FontWeight.w500,
          },
        ),
      );
}
