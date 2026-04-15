import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/core/theme/theme_store.dart';
import 'package:mysterium_vpn/service_locator.dart';

class EasyButton extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final themeStore = getIt<ThemeStore>();
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
