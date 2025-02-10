import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/ab_test_hook.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/base_app_bar.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class SubscriptionMobileHeader extends HookWidget {
  const SubscriptionMobileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final subscriptionStore = useProvider(subscriptionStorePOD);
    final shouldAllowBack = useComputedValue(
      () => subscriptionStore.subscriptonStatus != SubscriptionStatus.verifying,
    );

    final variant = useABTest((store) => store.subscriptionFlowVariant);
    final router = Beamer.of(context);

    final canGoBack = shouldAllowBack && router.canBeamBack;

    return switch (variant) {
      'E' => _CloseButton(onPressed: router.beamBack),
      _ => BaseAppBar(
          showBackButton: canGoBack,
          onBackButtonPressed: router.beamBack,
        ),
    };
  }
}

class _CloseButton extends HookWidget {
  const _CloseButton({
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SvgIconButton(
              asset: Assets.closeDark,
              onPressed: onPressed,
            ),
          ],
        ),
      );
}
