import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/connect_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/flag.dart';
import 'package:mysterium_vpn/components/ripple.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/stores/vpn_store.dart';
import 'package:styled_widget/styled_widget.dart';

class RecentLocationItem extends StatelessWidget {
  const RecentLocationItem({
    required this.location,
    required this.onTap,
    required this.vpnStore,
    super.key,
  });

  final Location location;
  final VoidCallback onTap;
  final VpnStore vpnStore;
  @override
  Widget build(BuildContext context) => Observer(
        builder: (context) => RippleWidget(
          radius: 20,
          onTap: vpnStore.isLoading ? null : onTap,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flag(countryCode: location.countryCode),
                  ConnectButton(
                    onPressed: onTap,
                    locationCode: location.countryCode,
                  ),
                ],
              ).padding(bottom: 4),
              EasyText(
                location.countryName,
                fontWeight: FontWeight.w700,
              ),
              if (location.countryCode == vpnStore.connectingLocationCode && vpnStore.isConnected)
                EasyText(
                  LocaleKeys.connected.tr(),
                  color: Palette.purple,
                )
              else
                EasyText(
                  const Duration(hours: 1, minutes: 30).toHoursMinutes(),
                ),
            ],
          ).padding(left: 12, right: 6, bottom: 4).width(110),
        )
            .card(
              elevation: 1,
              color: vpnStore.isLoading
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            )
            .paddingDirectional(end: 10),
      );
}
