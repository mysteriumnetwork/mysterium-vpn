import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/platform.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/icons/untitled_ui.dart';
import 'package:mysterium_vpn_design/styles/colors/palette.dart';
import 'package:mysterium_vpn_design/widgets/progress_card.dart';
import 'package:showcaseview/showcaseview.dart';

abstract interface class OnboardingStep {
  int get desktopIndex;
  int get mobileIndex;
  int get platformIndex;
  int get totalSteps;
}

enum SubscriptionOnboardingStep implements OnboardingStep {
  connectButton(desktopIndex: 3, mobileIndex: 4),
  locations(desktopIndex: 5, mobileIndex: 1),
  map(desktopIndex: 0, mobileIndex: 0),
  products(desktopIndex: 1, mobileIndex: 2),
  search(desktopIndex: 4, mobileIndex: 5),
  settings(desktopIndex: 2, mobileIndex: 3);

  const SubscriptionOnboardingStep({required this.desktopIndex, required this.mobileIndex});

  @override
  final int desktopIndex;
  @override
  final int mobileIndex;
  @override
  int get totalSteps => SubscriptionOnboardingStep.values.length;
  @override
  int get platformIndex => isDesktop() ? desktopIndex : mobileIndex;
}

class ArrowedProgressCard extends HookConsumerWidget {
  const ArrowedProgressCard({
    required this.child,
    required this.globalKey,
    required this.step,
    required this.tooltipPosition,
    super.key,
  });

  final Widget child;
  final GlobalKey globalKey;
  final SubscriptionOnboardingStep step;
  final TooltipPosition tooltipPosition;

  // safety margin to keep the arrow away from the rounded corners of the ProgressCard
  static const double _cornerInset = 24;

  int get _index => isDesktop() ? step.desktopIndex : step.mobileIndex;

  bool get _isLastStep =>
      (isDesktop() ? step.desktopIndex : step.mobileIndex) ==
      SubscriptionOnboardingStep.values.length - 1;

  String get _actionLabel => _isLastStep ? LocaleKeys.completeBtn : LocaleKeys.continueBtn;

  bool get _isHorizontal =>
      tooltipPosition == TooltipPosition.left || tooltipPosition == TooltipPosition.right;

  EdgeInsets get _tooltipMargin => switch (tooltipPosition) {
    TooltipPosition.bottom => EdgeInsets.zero,
    _ => const EdgeInsets.only(top: 50),
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStore = ref.watch(themeStorePOD);
    final shouldShowShowcase = ref
        .watch(shouldShowSubscriptionOnboardingShowcasePOD)
        .maybeWhen(data: (value) => value, orElse: () => true);
    final isDarkMode = useComputedValue(() => themeStore.isDarkMode);
    final arrowColor = isDarkMode ? Palette.grayLight.shade800 : Palette.grayLight.shade25;

    if (!shouldShowShowcase) {
      return child;
    }

    // Attached to the tooltip Stack so we can measure the card in its own coordinates.
    final tooltipStackKey = useMemoized(GlobalKey.new);
    // Distance along the card edge facing the nav item to the arrow centre.
    // null until the first layout + target measurement completes.
    final arrowPosition = useState<double?>(null);

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

        const minArrowPositionOnActiveAxis = _TooltipArrow.arrowBase / 2 + _cornerInset;

        final maxArrowPositionOnActiveAxis =
            tooltipActiveSideLength - _TooltipArrow.arrowBase / 2 - _cornerInset;

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
      container: Container(
        margin: _tooltipMargin,
        width: 343,
        child: Stack(
          key: tooltipStackKey,
          clipBehavior: Clip.none,
          children: [
            ProgressCard(
              icon: iconData,
              progressLabel: '${_index + 1}/${step.totalSteps}',
              progressValue: _index / step.totalSteps,
              title: title.tr(),
              description: description.tr(),
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
      child: child,
    );
  }

  String get title => switch (step) {
    SubscriptionOnboardingStep.map =>
      isDesktop()
          ? LocaleKeys.subscriptionOnboardingMapDesktopTitle
          : LocaleKeys.subscriptionOnboardingMapMobileTitle,
    SubscriptionOnboardingStep.locations => LocaleKeys.subscriptionOnboardingVPNLocationsTitle,
    SubscriptionOnboardingStep.products => LocaleKeys.subscriptionOnboardingManagePlanTitle,
    SubscriptionOnboardingStep.connectButton => LocaleKeys.subscriptionOnboardingConnectTitle,
    SubscriptionOnboardingStep.search => LocaleKeys.subscriptionOnboardingSearchTitle,
    SubscriptionOnboardingStep.settings => LocaleKeys.subscriptionOnboardingBoostProtectionTitle,
  };

  String get description => switch (step) {
    SubscriptionOnboardingStep.map =>
      isDesktop()
          ? LocaleKeys.subscriptionOnboardingMapDesktopDescription
          : LocaleKeys.subscriptionOnboardingMapMobileDescription,
    SubscriptionOnboardingStep.locations =>
      isDesktop()
          ? LocaleKeys.subscriptionOnboardingVPNLocationsDesktopDescription
          : LocaleKeys.subscriptionOnboardingVPNLocationsMobileDescription,
    SubscriptionOnboardingStep.products => LocaleKeys.subscriptionOnboardingManagePlanDescription,
    SubscriptionOnboardingStep.connectButton => LocaleKeys.subscriptionOnboardingConnectDescription,
    SubscriptionOnboardingStep.search => LocaleKeys.subscriptionOnboardingSearchDescription,
    SubscriptionOnboardingStep.settings =>
      LocaleKeys.subscriptionOnboardingBoostProtectionDescription,
  };

  IconData get iconData => switch (step) {
    SubscriptionOnboardingStep.map => UntitledUI.map_01,
    SubscriptionOnboardingStep.locations => UntitledUI.flag_01,
    SubscriptionOnboardingStep.products => UntitledUI.star_06,
    SubscriptionOnboardingStep.connectButton => UntitledUI.rocket_02,
    SubscriptionOnboardingStep.search => UntitledUI.search_sm,
    SubscriptionOnboardingStep.settings => UntitledUI.lock_01,
  };
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
    final arrowOffsetFromEdgeStart = arrowPosition! - arrowBase / 2;
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
      old.color != color || old.position != position;
}
