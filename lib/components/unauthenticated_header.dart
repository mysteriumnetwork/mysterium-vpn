import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/app_logo.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class UnauthenticatedHeader extends HookConsumerWidget {
  const UnauthenticatedHeader({
    super.key,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            width: 40,
          ),
          const AppLogo(),
          SvgIconButton(
            asset: Assets.messageSvg,
            onPressed: () {
              handleOnReportPage(
                context: context,
                intetcomStore: ref.read(intercomStorePOD),
                analyticsStore: ref.read(analyticsStorePOD),
              );
            },
          ),
        ],
      );
}
