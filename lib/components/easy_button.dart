import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class EasyButton extends HookConsumerWidget {
  const EasyButton(
      {Key? key,
      this.text,
      this.child,
      required this.onPressed,
      this.color,
      this.useSystemColor = true,
      this.isDisabled = false,
      this.width,
      this.height})
      : super(key: key);

  final String? text;
  final Widget? child;
  final VoidCallback? onPressed;
  final Color? color;
  final bool useSystemColor;
  final bool isDisabled;
  final double? width;
  final double? height;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStore = ref.watch(themeStorePOD);

    return SizedBox(
        width: width,
        height: height,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: useSystemColor
                ? null
                : color ??
                    (themeStore.themeType == ThemeType.light ? Palette.black : Palette.lightBlack),
          ),
          child: text != null ? EasyText(text!, color: Palette.white) : child,
        ));
  }
}
