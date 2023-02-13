import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/stores/vpn_store.dart';
import 'package:styled_widget/styled_widget.dart';

class KillSwitchItem extends StatelessWidget {
  const KillSwitchItem({
    super.key,
    required this.asset,
    required this.title,
    required this.subtitle,
    required this.store,
  });

  final String asset;
  final String title;
  final String subtitle;
  final VpnStore store;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(
          Radius.circular(20),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgIcon(asset: asset).padding(right: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              EasyText(title, fontSize: 14).padding(bottom: 8),
              EasyText(
                subtitle,
                color: Palette.lightBlack,
              ).padding(bottom: 8),
            ],
          ).expanded(),
          Observer(builder: (context) {
            return Switch(
                value: store.killSwitch,
                onChanged: (val) {
                  store.toggleKillSwitch();
                });
          }),
        ],
      ),
    ).paddingDirectional(bottom: 10, horizontal: 20);
  }
}
