import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_portal/flutter_portal.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';

class Indicator extends HookWidget {
  const Indicator({
    required this.buildEntry,
    required this.asset,
    super.key,
  });

  final IndicatorEntry Function(BuildContext) buildEntry;
  final String asset;

  @override
  Widget build(BuildContext context) {
    final visible = useState(false);
    final autoHideTimer = useRef<Timer?>(null);

    void handleToggle() {
      visible.value = !visible.value;
    }

    useEffect(
      () {
        if (visible.value) {
          autoHideTimer.value?.cancel();
          autoHideTimer.value = Timer(const Duration(seconds: 3), () => visible.value = false);
        }

        return null;
      },
      [visible.value, autoHideTimer],
    );

    return PortalTarget(
      visible: visible.value,
      anchor: const Aligned(
        follower: Alignment.topLeft,
        target: Alignment.bottomLeft,
        offset: Offset(14, 3),
        shiftToWithinBound: AxisFlag(x: true),
      ),
      portalFollower: buildEntry(context),
      child: SvgIconButton(key: key, onPressed: handleToggle, asset: asset),
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
  Widget build(BuildContext context) => ConstrainedBox(
        constraints: constraints,
        child: Material(
          color: Palette.lightBlack,
          borderRadius: BorderRadius.circular(8),
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
      );
}
