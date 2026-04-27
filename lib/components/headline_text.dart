import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/theme/theme_store.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
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
    final theme = Theme.of(context);
    final themeStore = getIt<ThemeStore>();
    return Observer(
      builder: (context) {
        final themeColor = themeStore.isDarkMode || checkMediaWidth(context, 750)
            ? Palette.white
            : Palette.grayPurple.shade800;
        return Text(
          text,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
          style: theme.textStyles.displayXlg.bold.copyWith(
            color: color ?? themeColor,
            fontSize: fontSize,
            fontWeight: fontWeight,
          ),
        ).padding(vertical: 6);
      },
    );
  }
}
