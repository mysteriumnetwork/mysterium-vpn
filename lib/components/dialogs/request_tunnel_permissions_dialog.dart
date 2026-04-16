import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/header_title.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/components/agreements.dart';
import 'package:styled_widget/styled_widget.dart';

Future<bool?> showRequestTunnelPermissionsDialog(
  BuildContext context,
  String dialogVariant,
) async => showBarModalBottomSheet<bool>(
  clipBehavior: Clip.none,
  topControl: const SizedBox.shrink(),
  context: context,
  backgroundColor: Theme.of(context).primaryColor,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
  ),
  builder: (context) => const _RequestTunnelPermissionsOptionB(),
);

class _RequestTunnelPermissionsOptionB extends HookConsumerWidget {
  const _RequestTunnelPermissionsOptionB();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final height = getMediaHeight(context);
    final analyticsStore = ref.read(analyticsStorePOD);

    return Column(
      children: [
        HeaderTitle(text: LocaleKeys.weNeedPermission.tr()).padding(bottom: height * 0.01),
        Column(
          children: [
            SvgIcon(asset: Asset.images.settings).padding(bottom: height * 0.02),
            EasyText(
              LocaleKeys.installVpnProfile.tr(),
              fontSize: 16,
              fontWeight: FontWeight.w700,
              maxLines: 3,
              textAlign: TextAlign.center,
            ).padding(bottom: height * 0.03),
            EasyText(
              LocaleKeys.anonymityIsSafe.tr(),
              fontSize: 16,
              maxLines: 3,
              textAlign: TextAlign.center,
            ).padding(bottom: height * 0.03),
          ],
        ).scrollable().expanded(),
        Agreements(analyticsStore: analyticsStore).padding(vertical: height * 0.02),
        EasyButton(
          useSystemColor: false,
          color: Palette.purple,
          width: 250,
          onPressed: () async {
            analyticsStore.logEvent(AnalyticsEvent.permissionsAcceptClick);
            Navigator.pop(context, true);
          },
          child: EasyText(LocaleKeys.acceptAndContinue.tr(), color: Palette.white),
        ).padding(bottom: height * 0.045),
      ],
    ).padding(horizontal: 20).height(getMediaHeight(context) * 0.85);
  }
}
