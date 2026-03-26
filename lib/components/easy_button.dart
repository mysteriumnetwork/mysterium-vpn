import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class EasyButton extends ConsumerWidget {
  const EasyButton({
    required this.onPressed,
    this.text,
    this.child,
    this.color,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.useSystemColor = true,
    this.isDisabled = false,
    this.width,
    this.height,
    super.key,
  });

  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? disabledBackgroundColor;
  final Color? disabledForegroundColor;
  final bool useSystemColor;
  final bool isDisabled;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStore = ref.read(themeStorePOD);
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: useSystemColor
              ? null
              : color ?? (themeStore.isDarkMode ? Palette.lightBlack : Palette.black),
          disabledBackgroundColor: disabledBackgroundColor,
          disabledForegroundColor: disabledForegroundColor,
        ),
        child: text != null
            ? EasyText(text!, color: Palette.white, fontSize: 16, fontWeight: FontWeight.w700)
            : child,
      ),
    );
  }
}
