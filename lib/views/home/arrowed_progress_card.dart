import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/models/tooltip_content.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/styles/colors/palette.dart';
import 'package:mysterium_vpn_design/widgets/progress_card.dart';
import 'package:showcaseview/showcaseview.dart';

class ArrowedProgressCard extends HookConsumerWidget {
  const ArrowedProgressCard({
    required this.globalKey,
    required this.child,
    required this.tooltipPosition,
    required this.tooltipContent,
    required this.tooltipIndex,
    required this.totalTooltips,
    super.key,
  });

  final Widget child;
  final GlobalKey<State<StatefulWidget>> globalKey;
  final TooltipPosition tooltipPosition;
  final TooltipContent tooltipContent;
  final int tooltipIndex;
  final int totalTooltips;

  int get _index => tooltipIndex + 1;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStore = ref.watch(themeStorePOD);
    final isDarkMode = useComputedValue(() => themeStore.isDarkMode);

    return Showcase.withWidget(
      key: globalKey,
      tooltipPosition: tooltipPosition,
      container: Container(
        margin: const EdgeInsets.only(top: 50),
        width: 343,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topRight,
          children: [
            Positioned(
              left: -10,
              top: -50,
              bottom: 50,
              child: Center(
                child: CustomPaint(
                  size: const Size(12, 20),
                  painter: _TooltipArrowPainter(
                    position: tooltipPosition,
                    color: isDarkMode ? Palette.grayLight.shade800 : Palette.grayLight.shade25,
                  ),
                ),
              ),
            ),
            ProgressCard(
              icon: Icons.search,
              progressLabel: '$_index/$totalTooltips',
              progressValue: _index / totalTooltips,
              title: tooltipContent.title,
              description: tooltipContent.description,
              actionLabel: tooltipContent.actionLabel.tr(),
              onActionPressed: () => tooltipContent.onActionPressed(),
            ),
          ],
        ),
      ),
      child: child,
    );
  }
}

class _TooltipArrowPainter extends CustomPainter {
  _TooltipArrowPainter({required this.color, required this.position});

  final TooltipPosition position;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;

    // Base: tip pointing right (tip at right edge)
    final path = Path()
      ..moveTo(size.width, size.height / 2)
      ..lineTo(0, 0)
      ..lineTo(0, size.height)
      ..close();

    final rotation = switch (position) {
      TooltipPosition.right => math.pi, // point left
      TooltipPosition.left => 0, // point right
      TooltipPosition.bottom => -math.pi / 2, // point up
      TooltipPosition.top => math.pi / 2, // point down
    };

    canvas
      ..save()
      ..translate(size.width / 2, size.height / 2)
      ..rotate(rotation.toDouble())
      ..translate(-size.width / 2, -size.height / 2)
      ..drawPath(path, paint)
      ..restore();
  }

  @override
  bool shouldRepaint(covariant _TooltipArrowPainter old) => old.color != color;
}
