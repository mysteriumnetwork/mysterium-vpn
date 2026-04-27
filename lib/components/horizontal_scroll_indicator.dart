import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/hooks/render_object_hook.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class HorizontalScrollIndicator extends HookWidget {
  const HorizontalScrollIndicator({
    required this.controller,
    required this.child,
    this.offset = Offset.zero,
    super.key,
  });

  final ScrollController controller;
  final Widget child;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    const animationDuration = Duration(milliseconds: 250);
    final (stackKey, stackBox) = useRenderObject<RenderBox>();

    final canScrollLeft = useListenableSelector(controller, () {
      if (!controller.hasClients) {
        return false;
      }
      return controller.offset > controller.position.minScrollExtent;
    });

    final canScrollRight = useListenableSelector(controller, () {
      if (!controller.hasClients) {
        return false;
      }
      return controller.offset < controller.position.maxScrollExtent;
    });

    void handleScrollToStart() {
      if (controller.hasClients) {
        final stackWidth = stackBox?.size.width ?? 0;
        final currentPosition = controller.positions.isNotEmpty ? controller.position.pixels : 0.0;
        controller.animateTo(
          max(0, currentPosition - stackWidth),
          duration: animationDuration,
          curve: Curves.easeInOut,
        );
      }
    }

    void handleScrollToEnd() {
      if (controller.hasClients && controller.positions.isNotEmpty) {
        final stackWidth = stackBox?.size.width ?? 0;
        final currentPosition = controller.positions.isNotEmpty ? controller.position.pixels : 0.0;
        controller.animateTo(
          min(currentPosition + stackWidth, controller.position.maxScrollExtent),
          duration: animationDuration,
          curve: Curves.easeInOut,
        );
      }
    }

    useEffect(() {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        /// This is a workaround to force the scroll controller to recalculate. Otherwise, listener is not called on first frame.
        if (controller.hasClients) {
          controller
            ..jumpTo(0.1)
            ..jumpTo(0);
        }
      });
      return null;
    }, [controller]);

    return Stack(
      key: stackKey,
      clipBehavior: Clip.none,
      children: [
        child,
        if (canScrollLeft)
          AnimatedPositioned(
            duration: animationDuration,
            top: offset.dy,
            left: offset.dx,
            bottom: offset.dy,
            child: InkWell(
              onTap: handleScrollToStart,
              child: const _Indicator(scrollDirection: ScrollDirection.forward),
            ),
          ),
        if (canScrollRight)
          AnimatedPositioned(
            duration: animationDuration,
            top: offset.dy,
            right: offset.dx,
            bottom: offset.dy,
            child: InkWell(
              onTap: handleScrollToEnd,
              child: const _Indicator(scrollDirection: ScrollDirection.reverse),
            ),
          ),
      ],
    );
  }
}

class _Indicator extends HookWidget {
  const _Indicator({required this.scrollDirection});

  final ScrollDirection scrollDirection;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final gradientColor = theme.palette.bgPrimary;
    return Transform.rotate(
      angle: switch (scrollDirection) {
        ScrollDirection.forward => pi,
        _ => 0,
      },
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              gradientColor.withValues(alpha: .1),
              gradientColor.withValues(alpha: .6),
              gradientColor.withValues(alpha: .95),
              gradientColor,
            ],
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: Theme.of(context).spacing.xl2,
            right: Theme.of(context).spacing.s,
          ),
          child: Icon(UntitledUI.chevron_right, color: Theme.of(context).palette.iconPrimary),
        ),
      ),
    );
  }
}
