import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:styled_widget/styled_widget.dart';

class Banner extends StatelessWidget {
  const Banner({
    required this.title,
    this.cta,
    this.onPressed,
    this.body,
    this.onDismiss,
    this.mainBanner = true,
    this.style = BannerStyle.info,
    super.key,
  });

  final Widget title;
  final Widget? cta;
  final Widget? body;
  final bool mainBanner;

  final VoidCallback? onDismiss;
  final VoidCallback? onPressed;
  final BannerStyle style;

  @override
  Widget build(BuildContext context) {
    final canDismiss = onDismiss != null;

    return _DefaultBannerStyle(
      style: style,
      child: RawMaterialButton(
        onPressed: onPressed,
        elevation: 0,
        fillColor: style.backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: style.borderRadius, side: style.border),
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: style.padding,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: canDismiss ? 32 : 0),
                      child: title,
                    ),
                    if (body != null) Padding(padding: const EdgeInsets.only(top: 6), child: body),
                    if (cta != null) Padding(padding: const EdgeInsets.only(top: 12), child: cta),
                  ],
                ),
              ),
            ),
            if (canDismiss) _DismissButton(onPressed: onDismiss, mainBanner: mainBanner),
          ],
        ),
      ),
    );
  }
}

class _DismissButton extends StatelessWidget {
  const _DismissButton({required this.onPressed, required this.mainBanner});

  final VoidCallback? onPressed;
  final bool mainBanner;

  @override
  Widget build(BuildContext context) {
    final bannerStyle = BannerStyle.of(context);

    return mainBanner
        ? Positioned(
            top: 12,
            right: 12,
            child: Opacity(
              opacity: .4,
              child: IconButton(
                color: bannerStyle.foregroundColor,
                constraints: BoxConstraints.tight(const Size(32, 32)),
                iconSize: 16,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                style: IconButton.styleFrom(backgroundColor: Palette.lightBlack),
                onPressed: onPressed,
                icon: const Icon(Icons.close_sharp),
              ),
            ),
          )
        : Positioned(
            top: 7,
            right: 7,
            child: IconButton(
              color: bannerStyle.foregroundColor,
              style: IconButton.styleFrom(
                backgroundColor: context.c.isDarkMode ? Palette.mediumBlack : Palette.lightBlack,
                splashFactory: NoSplash.splashFactory,
                iconSize: 12,
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.compact,
                minimumSize: const Size(15, 15),
                elevation: 0,
              ),
              onPressed: onPressed,
              icon: const Icon(Icons.close_sharp),
            ).width(15).height(15),
          );
  }
}

class _DefaultBannerStyle extends InheritedWidget {
  const _DefaultBannerStyle({required this.style, required super.child});

  final BannerStyle style;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    if (oldWidget is _DefaultBannerStyle) {
      return oldWidget.style != style;
    }
    return false;
  }
}

@immutable
class BannerStyle {
  const BannerStyle({
    required this.backgroundColor,
    required this.foregroundColor,
    required this.ctaBackgroundColor,
    required this.ctaForegroundColor,
    required this.border,
    required this.borderRadius,
    required this.padding,
  });

  static BannerStyle of(BuildContext context) {
    final inherited = context.dependOnInheritedWidgetOfExactType<_DefaultBannerStyle>();
    return inherited?.style ?? BannerStyle.info;
  }

  static const BannerStyle info = BannerStyle(
    backgroundColor: Palette.mediumBlack,
    foregroundColor: Palette.white,
    ctaBackgroundColor: Palette.purple,
    ctaForegroundColor: Palette.white,
    border: BorderSide(color: Palette.purple, width: 1.5),
    borderRadius: BorderRadius.all(Radius.circular(20)),
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
  );

  static const BannerStyle warningLight = BannerStyle(
    backgroundColor: Palette.paleYellow,
    foregroundColor: Palette.yellow,
    ctaBackgroundColor: Palette.yellow,
    ctaForegroundColor: Palette.white,
    border: BorderSide(color: Palette.yellow, width: 1.5),
    borderRadius: BorderRadius.all(Radius.circular(20)),
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
  );

  static const BannerStyle warningDark = BannerStyle(
    backgroundColor: Palette.darkOliveBrown,
    foregroundColor: Palette.white,
    ctaBackgroundColor: Palette.yellow,
    ctaForegroundColor: Palette.white,
    border: BorderSide(color: Palette.yellow, width: 1.5),
    borderRadius: BorderRadius.all(Radius.circular(20)),
    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
  );

  final Color backgroundColor;
  final Color foregroundColor;
  final Color ctaBackgroundColor;
  final Color ctaForegroundColor;
  final BorderSide border;
  final BorderRadius borderRadius;
  final EdgeInsets padding;

  BannerStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? ctaBackgroundColor,
    Color? ctaForegroundColor,
    BorderSide? border,
    BorderRadius? borderRadius,
    EdgeInsets? padding,
  }) => BannerStyle(
    backgroundColor: backgroundColor ?? this.backgroundColor,
    foregroundColor: foregroundColor ?? this.foregroundColor,
    ctaBackgroundColor: ctaBackgroundColor ?? this.ctaBackgroundColor,
    ctaForegroundColor: ctaForegroundColor ?? this.ctaForegroundColor,
    border: border ?? this.border,
    borderRadius: borderRadius ?? this.borderRadius,
    padding: padding ?? this.padding,
  );

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is BannerStyle &&
        other.backgroundColor == backgroundColor &&
        other.foregroundColor == foregroundColor &&
        other.ctaBackgroundColor == ctaBackgroundColor &&
        other.ctaForegroundColor == ctaForegroundColor &&
        other.border == border &&
        other.borderRadius == borderRadius &&
        other.padding == padding;
  }

  @override
  int get hashCode =>
      backgroundColor.hashCode ^
      foregroundColor.hashCode ^
      ctaBackgroundColor.hashCode ^
      ctaForegroundColor.hashCode ^
      border.hashCode ^
      borderRadius.hashCode ^
      padding.hashCode;

  @override
  String toString() =>
      'BannerStyle(backgroundColor: $backgroundColor, foregroundColor: $foregroundColor, ctaBackgroundColor: $ctaBackgroundColor, ctaForegroundColor: $ctaForegroundColor, border: $border, borderRadius: $borderRadius, padding: $padding)';
}
