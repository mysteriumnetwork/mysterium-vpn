import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer placeholder matching the [SavedIpCard] layout, shown while the
/// saved favorite IPs are loading.
class FavoriteIpItemLoading extends StatelessWidget {
  const FavoriteIpItemLoading({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.palette.bgPrimary;
    final barColor = color.darken(20).withValues(alpha: 150);

    Widget bar(double width, double height) =>
        Container(width: width, height: height, color: barColor);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: theme.spacing.md, vertical: theme.spacing.ms),
      decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.all(Radius.kS)),
      child: Shimmer.fromColors(
        baseColor: color,
        highlightColor: color.darken(20),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(color: barColor, shape: BoxShape.circle),
            ),
            SizedBox(width: theme.spacing.ms),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: theme.spacing.xs,
                children: [bar(96, 16), bar(64, 8)],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                spacing: theme.spacing.xs,
                children: [bar(88, 8), bar(96, 20)],
              ),
            ),
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(color: barColor, shape: BoxShape.circle),
            ),
          ],
        ),
      ),
    );
  }
}
