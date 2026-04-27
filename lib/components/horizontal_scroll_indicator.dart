import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class HorizontalScrollIndicator extends StatefulWidget {
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
  State<HorizontalScrollIndicator> createState() => _HorizontalScrollIndicatorState();
}

class _HorizontalScrollIndicatorState extends State<HorizontalScrollIndicator> {
  static const _animationDuration = Duration(milliseconds: 250);

  final _stackKey = GlobalKey();
  RenderBox? _stackBox;

  bool _canScrollLeft = false;
  bool _canScrollRight = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Resolve the render box after first frame.
      final context = _stackKey.currentContext;
      final object = context?.findRenderObject();
      if (object is RenderBox) {
        setState(() => _stackBox = object);
      }
      // Force scroll controller to recalculate so listener fires on first frame.
      if (widget.controller.hasClients) {
        widget.controller
          ..jumpTo(0.1)
          ..jumpTo(0);
      }
    });
  }

  @override
  void didUpdateWidget(HorizontalScrollIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onScroll);
      widget.controller.addListener(_onScroll);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final controller = widget.controller;
    if (!controller.hasClients) {
      if (_canScrollLeft || _canScrollRight) {
        setState(() {
          _canScrollLeft = false;
          _canScrollRight = false;
        });
      }
      return;
    }
    final newLeft = controller.offset > controller.position.minScrollExtent;
    final newRight = controller.offset < controller.position.maxScrollExtent;
    if (newLeft != _canScrollLeft || newRight != _canScrollRight) {
      setState(() {
        _canScrollLeft = newLeft;
        _canScrollRight = newRight;
      });
    }
  }

  void _handleScrollToStart() {
    final controller = widget.controller;
    if (controller.hasClients) {
      final stackWidth = _stackBox?.size.width ?? 0;
      final currentPosition = controller.positions.isNotEmpty ? controller.position.pixels : 0.0;
      controller.animateTo(
        max(0, currentPosition - stackWidth),
        duration: _animationDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  void _handleScrollToEnd() {
    final controller = widget.controller;
    if (controller.hasClients && controller.positions.isNotEmpty) {
      final stackWidth = _stackBox?.size.width ?? 0;
      final currentPosition = controller.positions.isNotEmpty ? controller.position.pixels : 0.0;
      controller.animateTo(
        min(currentPosition + stackWidth, controller.position.maxScrollExtent),
        duration: _animationDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) => Stack(
    key: _stackKey,
    clipBehavior: Clip.none,
    children: [
      widget.child,
      if (_canScrollLeft)
        AnimatedPositioned(
          duration: _animationDuration,
          top: widget.offset.dy,
          left: widget.offset.dx,
          bottom: widget.offset.dy,
          child: InkWell(
            onTap: _handleScrollToStart,
            child: const _Indicator(scrollDirection: ScrollDirection.forward),
          ),
        ),
      if (_canScrollRight)
        AnimatedPositioned(
          duration: _animationDuration,
          top: widget.offset.dy,
          right: widget.offset.dx,
          bottom: widget.offset.dy,
          child: InkWell(
            onTap: _handleScrollToEnd,
            child: const _Indicator(scrollDirection: ScrollDirection.reverse),
          ),
        ),
    ],
  );
}

class _Indicator extends StatelessWidget {
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
          padding: EdgeInsets.only(left: theme.spacing.xl2, right: theme.spacing.s),
          child: Icon(UntitledUI.chevron_right, color: theme.palette.iconPrimary),
        ),
      ),
    );
  }
}
