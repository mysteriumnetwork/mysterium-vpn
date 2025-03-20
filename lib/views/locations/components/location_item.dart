import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/components/connect_text_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/flag.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class LocationItem extends HookConsumerWidget {
  const LocationItem({
    required this.location,
    required this.onTap,
    super.key,
  });

  final VPNLocation location;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final vpnStore = ref.watch(vpnStorePOD);
    final onTap = useComputedValue(() => vpnStore.isLoading ? null : this.onTap, [this.onTap]);

    return RawMaterialButton(
      elevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      focusElevation: 0,
      fillColor: theme.colorScheme.surfaceContainerHighest,
      constraints: const BoxConstraints(minHeight: 64),
      onPressed: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 20,
          children: [
            Flag(countryCode: location.code, size: 30),
            Expanded(
              child: EasyText(
                location.code.tr(),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            ConnectTextButton(
              onPressed: onTap,
              location: location,
            ),
          ],
        ),
      ),
    );
  }
}
