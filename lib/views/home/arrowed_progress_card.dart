import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/subscription_onboarding_step.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/subscription_onboarding_store.dart';
import 'package:mysterium_vpn_design/styles/colors/palette.dart';
import 'package:mysterium_vpn_design/widgets/progress_card.dart';
import 'package:showcaseview/showcaseview.dart';

export 'package:mysterium_vpn/common/enums/subscription_onboarding_step.dart';

class ArrowedProgressCard extends HookConsumerWidget {
  const ArrowedProgressCard({
    required this.child,
    required this.globalKey,
    required this.step,
    required this.tooltipPosition,
    this.showcasePadding,
    super.key,
  });

  final Widget child;
  final GlobalKey globalKey;
  final SubscriptionOnboardingStep step;
  final TooltipPosition tooltipPosition;

  /// Padding applied to [child] only while the showcase tour is active.
  final EdgeInsetsGeometry? showcasePadding;

  // safety margin to keep the arrow away from the rounded corners of the ProgressCard
  static const double _cornerInset = 24;

  bool get _isLastStep => step.platformIndex == (SubscriptionOnboardingStep.values.length - 1);

  String get _actionLabel =>
      _isLastStep ? LocaleKeys.completeBtn.tr() : LocaleKeys.continueBtn.tr();

  bool get _isHorizontal =>
      tooltipPosition == TooltipPosition.left || tooltipPosition == TooltipPosition.right;

  EdgeInsets get _tooltipMargin => switch (tooltipPosition) {
    TooltipPosition.bottom => EdgeInsets.zero,
    _ => const EdgeInsets.only(top: 50),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStore = ref.watch(themeStorePOD);
    final isDarkMode = useComputedValue(() => themeStore.isDarkMode);
    final arrowColor = isDarkMode ? Palette.grayLight.shade800 : Palette.grayLight.shade25;

    // Attached to the tooltip Stack so we can measure the card in its own coordinates.
    final tooltipStackKey = useMemoized(GlobalKey.new);
    // Distance along the card edge facing the nav item to the arrow centre.
    // null until the first layout + target measurement completes.
    final arrowPosition = useState<double?>(null);

    // Checks if showcase tour is enabled otherwise returns the child
    final subscriptionOnboardingStore = ref.watch<SubscriptionOnboardingStore>(
      subscriptionOnboardingStorePOD,
    );
    final startTour = useComputedValue(() => subscriptionOnboardingStore.startTour);
    if (!startTour) {
      return child;
    }

    // targetRect is the widget rect that is being targeted by the tooltip.
    void updateArrowPosition(Rect targetRect) {
      if (targetRect.width <= 0 || targetRect.height <= 0) {
        return;
      }

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final tooltipBox = tooltipStackKey.currentContext?.findRenderObject() as RenderBox?;
        if (tooltipBox == null || !tooltipBox.hasSize) {
          return;
        }

        // gets the tooltip's offset to the target
        final tooltipOffsetToTarget = tooltipBox.globalToLocal(targetRect.center);
        if (!tooltipOffsetToTarget.dx.isFinite || !tooltipOffsetToTarget.dy.isFinite) {
          return;
        }

        // Position along the facing edge: vertical edge → dy, horizontal edge → dx.
        final positionOnActiveAxis = _isHorizontal
            ? tooltipOffsetToTarget.dy
            : tooltipOffsetToTarget.dx;

        final tooltipActiveSideLength = _isHorizontal
            ? tooltipBox.size.height
            : tooltipBox.size.width;

        const minArrowPositionOnActiveAxis = (_TooltipArrow.arrowBase / 2) + _cornerInset;

        final maxArrowPositionOnActiveAxis =
            tooltipActiveSideLength - (_TooltipArrow.arrowBase / 2) - _cornerInset;

        // clamp the arrow position to the min and max values
        final clampedArrowPosition = minArrowPositionOnActiveAxis <= maxArrowPositionOnActiveAxis
            ? positionOnActiveAxis.clamp(minArrowPositionOnActiveAxis, maxArrowPositionOnActiveAxis)
            : tooltipActiveSideLength / 2;

        if (arrowPosition.value == null ||
            (arrowPosition.value! - clampedArrowPosition).abs() > 0.5) {
          arrowPosition.value = clampedArrowPosition;
        }
      });
    }

    return Showcase.withWidget(
      key: globalKey,
      tooltipPosition: tooltipPosition,
      onTargetRectUpdate: updateArrowPosition,
      disposeOnTap: false,
      onTargetClick: () {},
      container: Container(
        margin: _tooltipMargin,
        width: 343,
        child: Stack(
          key: tooltipStackKey,
          clipBehavior: Clip.none,
          children: [
            ProgressCard(
              icon: step.icon,
              progressLabel: '${step.platformIndex + 1}/${step.totalSteps}',
              progressValue: (step.platformIndex + 1) / step.totalSteps,
              title: step.title.tr(),
              description: step.description.tr(),
              actionLabel: _actionLabel,
              onActionPressed: () => ShowcaseView.get().next(),
            ),
            _TooltipArrow(
              color: arrowColor,
              tooltipPosition: tooltipPosition,
              arrowPosition: arrowPosition.value,
            ),
          ],
        ),
      ),
      child: showcasePadding != null ? Padding(padding: showcasePadding!, child: child) : child,
    );
  }
}

class _TooltipArrow extends StatelessWidget {
  const _TooltipArrow({required this.color, required this.tooltipPosition, this.arrowPosition});

  static const double arrowBase = 20;
  static const double arrowHeight = 12;
  static const double overlap = 1;

  final Color color;
  final TooltipPosition tooltipPosition;
  final double? arrowPosition;

  bool get _isHorizontal =>
      tooltipPosition == TooltipPosition.left || tooltipPosition == TooltipPosition.right;

  @override
  Widget build(BuildContext context) {
    final size = _isHorizontal
        ? const Size(arrowHeight, arrowBase)
        : const Size(arrowBase, arrowHeight);

    final painter = CustomPaint(
      size: size,
      painter: _TooltipArrowPainter(position: tooltipPosition, color: color),
    );

    if (arrowPosition == null) {
      final alignment = switch (tooltipPosition) {
        TooltipPosition.right => Alignment.centerLeft,
        TooltipPosition.left => Alignment.centerRight,
        TooltipPosition.bottom => Alignment.topCenter,
        TooltipPosition.top => Alignment.bottomCenter,
      };
      final offset = switch (tooltipPosition) {
        TooltipPosition.right => const Offset(-arrowHeight + overlap, 0),
        TooltipPosition.left => const Offset(arrowHeight - overlap, 0),
        TooltipPosition.bottom => const Offset(0, -arrowHeight + overlap),
        TooltipPosition.top => const Offset(0, arrowHeight - overlap),
      };
      return Positioned.fill(
        child: Align(
          alignment: alignment,
          child: Transform.translate(offset: offset, child: painter),
        ),
      );
    }

    // Positioned top/left is the arrow widget's top-left, not its centre.
    final arrowOffsetFromEdgeStart = arrowPosition! - (arrowBase / 2);
    return switch (tooltipPosition) {
      TooltipPosition.right => Positioned(
        left: -arrowHeight + overlap,
        top: arrowOffsetFromEdgeStart,
        child: painter,
      ),
      TooltipPosition.left => Positioned(
        right: -arrowHeight + overlap,
        top: arrowOffsetFromEdgeStart,
        child: painter,
      ),
      TooltipPosition.bottom => Positioned(
        top: -arrowHeight + overlap,
        left: arrowOffsetFromEdgeStart,
        child: painter,
      ),
      TooltipPosition.top => Positioned(
        bottom: -arrowHeight + overlap,
        left: arrowOffsetFromEdgeStart,
        child: painter,
      ),
    };
  }
}

class _TooltipArrowPainter extends CustomPainter {
  _TooltipArrowPainter({required this.color, required this.position});

  final TooltipPosition position;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final w = size.width;
    final h = size.height;

    final path = switch (position) {
      TooltipPosition.right =>
        Path()
          ..moveTo(0, h / 2)
          ..lineTo(w, 0)
          ..lineTo(w, h),
      TooltipPosition.left =>
        Path()
          ..moveTo(w, h / 2)
          ..lineTo(0, 0)
          ..lineTo(0, h),
      TooltipPosition.bottom =>
        Path()
          ..moveTo(w / 2, 0)
          ..lineTo(0, h)
          ..lineTo(w, h),
      TooltipPosition.top =>
        Path()
          ..moveTo(w / 2, h)
          ..lineTo(0, 0)
          ..lineTo(w, 0),
    }..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _TooltipArrowPainter old) =>
      (old.color != color) || (old.position != position);
}
