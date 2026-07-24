import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:shimmer/shimmer.dart';

/// Shimmer skeleton shown during the News Center initial load: a title, the
/// filter row, and three feed cards, mirroring the loaded layout.
class NewsCenterLoadingView extends StatelessWidget {
  const NewsCenterLoadingView({super.key});

  /// Card radius matches `NewsCard` (intentional off-scale 14).
  static const _cardRadius = 14.0;
  static const _cardCount = 3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final surface = theme.palette.bgPrimary;
    final block = surface.darken(20).withValues(alpha: 150);

    Widget box(double width, double height, {double radius = 6}) => Container(
      width: width,
      height: height,
      decoration: BoxDecoration(color: block, borderRadius: BorderRadius.circular(radius)),
    );

    return Shimmer.fromColors(
      baseColor: surface,
      highlightColor: surface.darken(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          Padding(
            padding: EdgeInsets.symmetric(vertical: theme.spacing.s),
            child: box(160, 24),
          ),
          // Filters
          Padding(
            padding: EdgeInsets.symmetric(vertical: theme.spacing.md),
            child: Row(
              children: [
                for (var i = 0; i < NewsFilter.values.length; i++)
                  Padding(
                    padding: EdgeInsets.only(right: theme.spacing.s),
                    child: box(72, 36, radius: 18),
                  ),
              ],
            ),
          ),
          // Cards
          for (var i = 0; i < _cardCount; i++)
            Padding(
              padding: EdgeInsets.only(bottom: theme.spacing.md),
              child: _card(theme, surface, box),
            ),
        ],
      ),
    );
  }

  Widget _card(
    ThemeData theme,
    Color surface,
    Widget Function(double, double, {double radius}) box,
  ) => Container(
    width: double.infinity,
    padding: EdgeInsets.all(theme.spacing.md),
    decoration: BoxDecoration(
      color: surface,
      borderRadius: BorderRadius.circular(_cardRadius),
      border: Border.all(color: theme.palette.borderQuaternary),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category pill + timestamp
        Row(children: [box(64, 20, radius: 10), const Spacer(), box(48, 12)]),
        SizedBox(height: theme.spacing.lg),
        // Title line
        box(double.infinity, 16),
        SizedBox(height: theme.spacing.s),
        // Message preview (two lines)
        box(double.infinity, 12),
        SizedBox(height: theme.spacing.xs),
        box(180, 12),
      ],
    ),
  );
}
