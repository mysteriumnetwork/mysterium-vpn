import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/connect_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/flag.dart';
import 'package:mysterium_vpn/components/ripple.dart';
import 'package:mysterium_vpn/stores/connectivity_store.dart';
import 'package:mysterium_vpn/stores/vpn_store.dart';
import 'package:styled_widget/styled_widget.dart';

class LocationItem extends StatelessWidget {
  const LocationItem({
    required this.location,
    required this.onTap,
    required this.vpnStore,
    required this.connectivityStore,
    super.key,
  });

  final String location;
  final VoidCallback onTap;
  final VpnStore vpnStore;
  final ConnectivityStore connectivityStore;
  @override
  Widget build(BuildContext context) => Observer(
        builder: (context) => RippleWidget(
          onTap: () => onConnectButtonPressed(
            connectivityStore.connectionStatus,
            vpnStore.connectionStatus,
            context,
            onTap,
          ),
          radius: 15,
          child: Row(
            children: [
              Flag(countryCode: location).paddingDirectional(end: 20),
              EasyText(
                location.tr(),
                fontWeight: FontWeight.w700,
              ).expanded(),
              ConnectButton(
                onPressed: onTap,
                locationCode: location,
              ),
            ],
          ).padding(horizontal: 20, vertical: 4),
        )
            .card(
              color: vpnStore.isLoading
                  ? Theme.of(context).disabledColor
                  : Theme.of(context).cardColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            )
            .paddingDirectional(bottom: 10),
      );
}
