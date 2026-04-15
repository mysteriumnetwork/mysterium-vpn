import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/views/consent/agreements.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn/shared/components/easy_button.dart';
import 'package:mysterium_vpn/shared/components/easy_text.dart';
import 'package:mysterium_vpn/shared/components/header_title.dart';
import 'package:mysterium_vpn/shared/components/svg_icon.dart';
import 'package:styled_widget/styled_widget.dart';

Future<bool?> showRequestTunnelPermissionsDialog(BuildContext context, String dialogVariant) async {
  if (dialogVariant == 'A') {
    return showDialog<bool>(
      context: context,
      builder: (context) => const _RequestTunnelPermissionsOptionA(),
    );
  } else {
    return showBarModalBottomSheet<bool>(
      clipBehavior: Clip.none,
      topControl: const SizedBox.shrink(),
      context: context,
      backgroundColor: Theme.of(context).primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => const _RequestTunnelPermissionsOptionB(),
    );
  }
}

class _RequestTunnelPermissionsOptionA extends StatelessWidget {
  const _RequestTunnelPermissionsOptionA();

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Palette.black,
    surfaceTintColor: Palette.black,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    child: Container(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EasyText(
            LocaleKeys.setupTunnerPermissionsDialogTitle.tr(),
            fontSize: 20,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
            maxLines: 2,
            color: Palette.white,
          ).padding(bottom: 16),
          EasyText(
            LocaleKeys.setupTunnerPermissionsDialogDesc.tr(),
            fontSize: 14,
            textAlign: TextAlign.center,
            maxLines: 4,
            color: Palette.white,
          ).padding(bottom: 16),
          EasyText(
            LocaleKeys.setupTunnerPermissionsDialogDisclaimer.tr(),
            fontSize: 14,
            textAlign: TextAlign.center,
            color: const Color(0xffC4C1DD),
            maxLines: 4,
          ).padding(bottom: 40),
          EasyButton(
            useSystemColor: false,
            width: 160,
            color: Palette.purple,
            text: 'Allow',
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ).padding(horizontal: 20, vertical: 40),
    ),
  );
}

class _RequestTunnelPermissionsOptionB extends StatelessWidget {
  const _RequestTunnelPermissionsOptionB();

  @override
  Widget build(BuildContext context) {
    final height = getMediaHeight(context);
    final analyticsStore = getIt<AnalyticsStore>();

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
