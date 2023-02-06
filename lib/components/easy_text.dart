// Flutter imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
// Project imports:

class EasyText extends StatelessWidget {
  const EasyText(
    this.text, {
    Key? key,
    this.fontSize,
    this.maxLines = 1,
    this.letterSpacing,
    this.textAlign,
    this.overflow = TextOverflow.ellipsis,
    this.fontWeight,
    this.textDecoration,
    this.color,
    this.cursor,
    this.colorDecoration,
  }) : super(key: key);

  final String text;
  final double? fontSize;
  final double? letterSpacing;
  final FontWeight? fontWeight;
  final MouseCursor? cursor;
  final TextAlign? textAlign;
  final int maxLines;
  final TextOverflow? overflow;
  final TextDecoration? textDecoration;
  final Color? color;
  final Color? colorDecoration;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: cursor ?? MouseCursor.defer,
      child: AutoSizeText(
        text,
        textAlign: textAlign,
        overflow: overflow,
        maxLines: maxLines,
        style: TextStyle(
          decoration: textDecoration,
          decorationColor: colorDecoration,
          color: color ?? Theme.of(context).primaryTextTheme.bodyLarge?.color ?? Palette.black,
          fontSize: fontSize ?? 12,
          letterSpacing: letterSpacing,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}
