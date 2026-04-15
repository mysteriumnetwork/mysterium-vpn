import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/locations/store/selected_location_store.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_store.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn/shared/components/easy_text.dart';
import 'package:mysterium_vpn/shared/components/svg_icon.dart';

class RefreshConnection extends StatelessWidget {
  const RefreshConnection({super.key});

  @override
  Widget build(BuildContext context) {
    final vpnStore = getIt<VpnStore>();
    final analyticsStore = getIt<AnalyticsStore>();
    final selectedLocationStore = getIt<SelectedLocationStore>();
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
            selectedLocationStore.value = null;
            await vpnStore.manageConnection(refreshIP: true);
          },
          label: EasyText(LocaleKeys.refreshIP.tr(), fontSize: 12, color: Palette.white),
          icon: SvgIcon(asset: Asset.icons.refresh),
        ),
      ),
    );
  }
}
