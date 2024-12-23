import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/connect_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/flag.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

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
    final brightness = Theme.of(context).brightness;
    final vpnStore = ref.watch(vpnStorePOD);
    final isLoading = useComputedValue(() => vpnStore.isLoading);

    return RawMaterialButton(
      elevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      focusElevation: 0,
      fillColor: switch (brightness) {
        Brightness.light => Colors.white,
        Brightness.dark => Palette.darkBlue,
      },
      onPressed: isLoading ? null : onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Flag(countryCode: location.code).paddingDirectional(end: 20),
          EasyText(
            location.code.tr(),
            fontWeight: FontWeight.w700,
          ).expanded(),
          ConnectButton(
            onPressed: onTap,
            location: location,
          ),
        ],
      ).padding(horizontal: 20, vertical: 4),
    );
  }
}
