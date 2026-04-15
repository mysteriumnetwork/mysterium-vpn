import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/core/theme/theme_store.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn/shared/components/easy_text.dart';
import 'package:styled_widget/styled_widget.dart';

class HeadlineText extends StatelessWidget {
  const HeadlineText({
    required this.text,
    this.color,
    this.maxLines = 1,
    this.fontSize = 50,
    this.fontWeight = FontWeight.w700,
    this.textAlign = TextAlign.start,
    super.key,
  });

  final String text;
  final Color? color;
  final double fontSize;
  final FontWeight fontWeight;
  final int maxLines;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final themeStore = getIt<ThemeStore>();
    return Observer(
      builder: (context) {
        final themeColor = themeStore.isDarkMode || checkMediaWidth(context, 750)
            ? Palette.white
            : Palette.darkBlue;
        return EasyText(
          text,
          color: color ?? themeColor,
          fontSize: fontSize,
          fontWeight: fontWeight,
          maxLines: maxLines,
          textAlign: textAlign,
        ).padding(vertical: 6);
      },
    );
  }
}
