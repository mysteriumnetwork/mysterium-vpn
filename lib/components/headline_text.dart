import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

class HeadlineText extends ConsumerWidget {
  const HeadlineText(
      {Key? key,
      required this.text,
      this.color,
      this.maxLines = 1,
      this.fontSize = 40,
      this.fontWeight = FontWeight.w800})
      : super(key: key);

  final String text;
  final Color? color;
  final double fontSize;
  final FontWeight fontWeight;
  final int maxLines;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStore = ref.read(themeStorePOD);
    return Observer(builder: (context) {
      final themeColor =
          themeStore.isDarkMode || checkMediaWidth(context, 700) ? Palette.white : Palette.darkBlue;
      return EasyText(
        text,
        color: color ?? themeColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        maxLines: maxLines,
      ).padding(vertical: 6);
    });
  }
}
