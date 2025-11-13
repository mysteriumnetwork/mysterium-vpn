// Flutter imports:
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
// Project imports:

class EasyText extends StatelessWidget {
  const EasyText(
    this.text, {
    super.key,
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
    this.autoSizeGroup,
    this.minFontSize = 10,
    this.height,
  });

  final String text;
  final double? fontSize;
  final double? letterSpacing;
  final double? height;
  final FontWeight? fontWeight;
  final MouseCursor? cursor;
  final TextAlign? textAlign;
  final int maxLines;
  final TextOverflow? overflow;
  final TextDecoration? textDecoration;
  final Color? color;
  final Color? colorDecoration;
  final AutoSizeGroup? autoSizeGroup;
  final double minFontSize;

  @override
  Widget build(BuildContext context) => MouseRegion(
        cursor: cursor ?? MouseCursor.defer,
        child: AutoSizeText(
          text,
          group: autoSizeGroup,
          textAlign: textAlign,
          overflow: overflow,
          maxLines: maxLines,
          minFontSize: minFontSize,
          style: GoogleFonts.montserrat(
            decoration: textDecoration,
            decorationColor: colorDecoration,
            color: color ?? Theme.of(context).textTheme.bodyLarge?.color ?? Palette.black,
            fontSize: fontSize ?? 16,
            letterSpacing: letterSpacing,
            fontWeight: fontWeight,
            height: height,
          ),
        ),
      );
}
