import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/banners/banner.dart';

class BannerCTA extends StatelessWidget {
  const BannerCTA({required this.text, required this.onPressed, super.key});

  final String text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bannerStyle = BannerStyle.of(context);

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: bannerStyle.ctaBackgroundColor,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minimumSize: const Size(130, 32),
        foregroundColor: bannerStyle.ctaForegroundColor,
        visualDensity: VisualDensity.comfortable,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelMedium!.copyWith(
          fontWeight: FontWeight.w700,
          color: bannerStyle.ctaForegroundColor,
          fontSize: 12,
        ),
      ),
    );
  }
}
