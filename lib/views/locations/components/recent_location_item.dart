import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/components/connect_text_button.dart';
import 'package:mysterium_vpn/components/flag.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

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
    final theme = Theme.of(context);
    final vpnStore = ref.watch(vpnStorePOD);
    final onTap = useComputedValue(() => vpnStore.isLoading ? null : this.onTap, [this.onTap]);
    final countryName = location.getName(context);
    return RawMaterialButton(
      onPressed: null,
      elevation: 0,
      hoverElevation: 0,
      highlightElevation: 0,
      focusElevation: 0,
      fillColor: theme.colorScheme.tertiaryContainer,
      constraints: const BoxConstraints(maxWidth: 360, minHeight: 82),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              spacing: 12,
              children: [
                Flag(countryCode: location.countryCode, size: 30),
                Flexible(
                  child: AutoSizeText(
                    countryName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                ConnectTextButton(
                  onPressed: onTap,
                  location: location,
                  size: const Size(90, 30),
                  loadingIndicatorRadius: 15,
                  outlinedButton: true,
                  fontStyle: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            Visibility(
              visible: location.ipType == IPType.datacenter,
              maintainSize: true,
              maintainState: true,
              maintainAnimation: true,
              child: Opacity(
                opacity: .75,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 12,
                  children: [
                    const SizedBox(width: 30),
                    Flexible(
                      child: Text(
                        LocaleKeys.ipTypeDataCenter.tr(),
                        maxLines: 1,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
