import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/indicator_type.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class Indicator extends HookConsumerWidget {
  const Indicator({
    required this.type,
    required this.buildEntry,
    required this.asset,
    this.autoDismissDuration = const Duration(seconds: 3),
    super.key,
  });

  final IndicatorType type;
  final IndicatorEntry Function(BuildContext) buildEntry;
  final String asset;
  final Duration? autoDismissDuration;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.watch(analyticsStorePOD);

    final visibility = useState(false);
    final autoHideTimer = useRef<Timer?>(null);

    Future<void> handleToggle() async {
      final visible = !visibility.value;
      visibility.value = visible;
      if (visible) {
        await analyticsStore.logIndicatorClick(type);
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
          follower: Alignment.topLeft,
          target: Alignment.bottomLeft,
          offset: Offset(14, 3),
          shiftToWithinBound: AxisFlag(x: true),
        ),
        portalFollower: _IndicatorController(
          visible: visibility,
          child: buildEntry(context),
        ),
        child: SvgIconButton(key: key, onPressed: handleToggle, asset: asset),
      ),
    );
  }
}

class IndicatorEntry extends StatelessWidget {
  const IndicatorEntry({
    required this.title,
    required this.message,
    this.constraints = const BoxConstraints(),
    super.key,
  });

  final String title;
  final String message;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final controller = _IndicatorController.of(context);
    return ConstrainedBox(
      constraints: constraints,
      child: Material(
        color: Palette.lightBlack,
        borderRadius: BorderRadius.circular(8),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => controller.value = false,
          child: Padding(
            padding: const EdgeInsets.all(6),
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
          ),
        ),
      ),
    );
  }
}

class _IndicatorController extends InheritedWidget {
  const _IndicatorController({
    required this.visible,
    required super.child,
  });

  final ValueNotifier<bool> visible;

  static ValueNotifier<bool> of(BuildContext context) {
    final controller = context.dependOnInheritedWidgetOfExactType<_IndicatorController>();
    return controller!.visible;
  }

  @override
  bool updateShouldNotify(_IndicatorController oldWidget) => visible != oldWidget.visible;
}
