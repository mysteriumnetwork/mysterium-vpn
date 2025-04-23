import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';

class BannerCTA extends StatelessWidget {
  const BannerCTA({
    required this.text,
    required this.onPressed,
    this.color = Palette.purple,
    super.key,
  });

  final String text;
  final VoidCallback onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minimumSize: const Size(130, 32),
        foregroundColor: Palette.white,
        visualDensity: VisualDensity.comfortable,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelMedium!.copyWith(
          fontWeight: FontWeight.w700,
          color: Palette.white,
          fontSize: 12,
        ),
      ),
    );
  }
}
