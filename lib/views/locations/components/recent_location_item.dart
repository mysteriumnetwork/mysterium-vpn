import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/connect_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/flag.dart';
import 'package:mysterium_vpn/components/ripple.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

class RecentLocationItem extends HookConsumerWidget {
  const RecentLocationItem({
    required this.location,
    required this.onTap,
    super.key,
  });

  final VPNLocation location;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);
    final isLoading = useComputedValue(() => vpnStore.isLoading);
    final isConnected = useComputedValue(
      () => vpnStore.isConnected && vpnStore.location == location,
      [location],
    );

    return RippleWidget(
      radius: 20,
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Flag(countryCode: location.code),
                const Spacer(),
                Transform.translate(
                  offset: const Offset(8, -8),
                  child: ConnectButton(
                    onPressed: onTap,
                    location: location,
                  ),
                ),
              ],
            ),
            EasyText(
              location.code.tr(),
              fontWeight: FontWeight.w700,
              maxLines: 2,
            ),
            const SizedBox(height: 4),
            if (isConnected)
              EasyText(
                LocaleKeys.connected.tr(),
                color: Palette.purple,
                fontSize: 10,
              ),
            if (location.ipType == IPType.datacenter)
              EasyText(
                LocaleKeys.ipTypeDataCenter.tr(),
                fontSize: 10,
              ),
          ],
        ),
      ),
    )
        .card(
          elevation: 1,
          margin: EdgeInsets.zero,
          color: isLoading ? Theme.of(context).disabledColor : Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        )
        .constrained(maxWidth: 130);
  }
}
