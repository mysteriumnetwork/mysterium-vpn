import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class RefreshConnection extends HookConsumerWidget {
  const RefreshConnection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);
    final analyticsStore = ref.watch(analyticsStorePOD);
    return Observer(
      builder: (context) => Visibility(
        visible: vpnStore.isConnected,
        replacement: SizedBox.fromSize(size: const Size.fromHeight(36)),
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Palette.blue,
            padding: const EdgeInsets.all(8),
            visualDensity: VisualDensity.compact,
            minimumSize: const Size(0, 36),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          onPressed: () async {
            analyticsStore.logEvent(AnalyticsEvent.refreshIp);
            ref.read(selectedLocationStorePOD).value = null;
            await vpnStore.manageConnection(refreshIP: true);
          },
          label: EasyText(LocaleKeys.refreshIP.tr(), fontSize: 12, color: Palette.white),
          icon: SvgIcon(asset: Asset.icons.refresh),
        ),
      ),
    );
  }
}
