import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/enums/indicator_type.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/indicator.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

class KillSwitchIndicator extends HookWidget {
  const KillSwitchIndicator({
    required this.constraints,
    super.key,
  });
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final isConnected = useIsConnected();

    return Indicator(
      type: IndicatorType.killSwitch,
      asset: isConnected ? Assets.killSwitchOn : Assets.killSwitchOff,
      buildEntry: (context) => IndicatorEntry(
        title: LocaleKeys.killSwitchIndicatorTitle.tr(),
        message: LocaleKeys.killSwitchIndicatorMessage.tr(),
        constraints: constraints.widthConstraints(),
      ),
    );
  }
}
