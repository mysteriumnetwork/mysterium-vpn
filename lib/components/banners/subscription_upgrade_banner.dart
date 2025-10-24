import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';

class SubscriptionUpgradeBanner extends HookConsumerWidget {
  const SubscriptionUpgradeBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<void> handleUpgrade() async {}
    return RawMaterialButton(
      onPressed: handleUpgrade,
      visualDensity: VisualDensity.compact,
      elevation: 0,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fillColor: Palette.lavenderPink,
      constraints: const BoxConstraints(minHeight: 40, maxHeight: 40),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 48),
            child: Row(
              spacing: 8,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Asset.icons.diamond.svg(width: 24, height: 24),
                const Flexible(
                  flex: 3,
                  child: EasyText(
                    'Save 48% with 1-year plan',
                    color: Palette.midnightCharcoal,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: IconButton(
              onPressed: handleUpgrade,
              icon: const Icon(Icons.chevron_right),
            ),
          ),
        ],
      ),
    );
  }
}
