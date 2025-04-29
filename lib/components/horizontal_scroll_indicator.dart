import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';

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
        final extent = controller.positions.isNotEmpty ? controller.position.minScrollExtent : 0.0;
        controller.animateTo(extent - 16, duration: animationDuration, curve: Curves.easeInOut);
      }
    }

    void handleScrollToEnd() {
      if (controller.hasClients && controller.positions.isNotEmpty) {
        final extent = controller.position.maxScrollExtent;
        controller.animateTo(extent + 16, duration: animationDuration, curve: Curves.easeInOut);
      }
    }

    useEffect(
      () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          /// This is a workaround to force the scroll controller to recalculate. Otherwise, listener is not called on first frame.
          if (controller.hasClients) {
            controller
              ..jumpTo(0.1)
              ..jumpTo(0);
          }
        });
        return null;
      },
      [controller],
    );

    return Stack(
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
  Widget build(BuildContext context) => Transform.rotate(
        angle: switch (scrollDirection) {
          ScrollDirection.forward => pi,
          _ => 0,
        },
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Palette.white.withValues(alpha: .1),
                Palette.white.withValues(alpha: .6),
                Palette.white.withValues(alpha: .95),
                Palette.white,
              ],
            ),
          ),
          child: const Padding(
            padding: EdgeInsets.only(top: 25, bottom: 25, left: 25, right: 8),
            child: SvgIcon(asset: Assets.chevronRight),
          ),
        ),
      );
}
