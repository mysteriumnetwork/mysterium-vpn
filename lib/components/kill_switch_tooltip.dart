import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Tooltip;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/enums/indicator_type.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/tooltip.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

class KillSwitchTooltip extends HookWidget {
  const KillSwitchTooltip({
    required this.constraints,
    super.key,
  });

  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final isConnected = useIsConnected();

    return Tooltip(
      type: TooltipType.killSwitch,
      asset: isConnected ? Assets.killSwitchOn : Assets.killSwitchOff,
      buildEntry: (context) => TooltipEntry(
        title: LocaleKeys.killSwitchTooltipTitle.tr(),
        message: LocaleKeys.killSwitchTooltipMessage.tr(),
        constraints: constraints.widthConstraints(),
      ),
    );
  }
}
