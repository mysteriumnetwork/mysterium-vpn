import 'dart:async';

import 'package:flutter/material.dart' hide Tooltip;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/indicator_type.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class Tooltip extends HookConsumerWidget {
  const Tooltip({
    required this.type,
    required this.buildEntry,
    required this.child,
    this.autoDismissDuration = const Duration(seconds: 3),
    this.enabled = true,
    super.key,
  });

  final Widget child;
  final TooltipType type;
  final TooltipEntry Function(BuildContext) buildEntry;
  final Duration? autoDismissDuration;
  final bool enabled;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.watch(analyticsStorePOD);

    final visibility = useState(false);
    final autoHideTimer = useRef<Timer?>(null);

    Future<void> handleToggle() async {
      final visible = !visibility.value;
      visibility.value = visible;
      if (visible) {
        await analyticsStore.logTooltipClick(type);
      }
    }

    useEffect(
      () {
        if (visibility.value) {
          autoHideTimer.value?.cancel();
          final duration = autoDismissDuration;
          if (duration != null) {
            autoHideTimer.value = Timer(duration, () => visibility.value = false);
          }
        }

        return null;
      },
      [visibility.value, autoHideTimer, autoDismissDuration],
    );

    return PortalTarget(
      visible: visibility.value,
      portalFollower: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => visibility.value = false,
      ),
      child: PortalTarget(
        visible: visibility.value,
        anchor: const Aligned(
          follower: Alignment.topCenter,
          target: Alignment.bottomCenter,
          offset: Offset(14, 3),
          shiftToWithinBound: AxisFlag(x: true),
        ),
        portalFollower: _TooltipController(
          visible: visibility,
          child: buildEntry(context),
        ),
        child: MouseRegion(
          onEnter: (_) => visibility.value = true,
          onExit: (_) => visibility.value = false,
          child: GestureDetector(key: key, onTap: enabled ? handleToggle : null, child: child),
        ),
      ),
    );
  }
}

class TooltipEntry extends StatelessWidget {
  const TooltipEntry({
    required this.child,
    this.margin = const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
    this.padding = const EdgeInsets.all(8),
    this.constraints = const BoxConstraints(),
    super.key,
  });

  final Widget child;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = _TooltipController.of(context);
    return Padding(
      padding: margin,
      child: ConstrainedBox(
        constraints: constraints,
        child: Material(
          color: theme.palette.tooltipBackgroundColor,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: theme.palette.highlightColor),
          ),
          child: InkWell(
            onTap: () => controller.value = false,
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class TooltipTextEntry extends StatelessWidget {
  const TooltipTextEntry({
    required this.title,
    required this.message,
    this.constraints = const BoxConstraints(),
    super.key,
  });

  final String title;
  final String message;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) => TooltipEntry(
        constraints: constraints,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EasyText(
              title,
              color: Palette.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            const SizedBox(height: 4),
            EasyText(
              message,
              color: Palette.lightBlue,
              fontSize: 8,
              fontWeight: FontWeight.w400,
              maxLines: 6,
            ),
          ],
        ),
      );
}

class _TooltipController extends InheritedWidget {
  const _TooltipController({
    required this.visible,
    required super.child,
  });

  final ValueNotifier<bool> visible;

  static ValueNotifier<bool> of(BuildContext context) {
    final controller = context.dependOnInheritedWidgetOfExactType<_TooltipController>();
    return controller!.visible;
  }

  @override
  bool updateShouldNotify(_TooltipController oldWidget) => visible != oldWidget.visible;
}
