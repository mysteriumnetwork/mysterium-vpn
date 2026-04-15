import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/shared/components/easy_button.dart';
import 'package:mysterium_vpn/shared/components/easy_text.dart';
import 'package:mysterium_vpn/shared/components/header_title.dart';
import 'package:mysterium_vpn/shared/components/svg_icon.dart';
import 'package:styled_widget/styled_widget.dart';

Future<void> shownNoInternetConnectionDialog(BuildContext context) async {
  await showBarModalBottomSheet(
    clipBehavior: Clip.none,
    topControl: const SizedBox.shrink(),
    context: context,
    backgroundColor: Theme.of(context).primaryColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) => const NoInternetConnectionDialog(),
  );
}

class NoInternetConnectionDialog extends StatelessWidget {
  const NoInternetConnectionDialog({super.key});

  @override
  Widget build(BuildContext context) => Stack(
    clipBehavior: Clip.none,
    alignment: Alignment.center,
    children: [
      Positioned(top: -15, child: SvgIcon(asset: Asset.icons.noInternetConnection)),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeaderTitle(text: LocaleKeys.noInternetConnection.tr()),
          EasyText(LocaleKeys.noInternetConnectionSub.tr(), fontSize: 14).padding(bottom: 30),
          EasyButton(
            useSystemColor: false,
            width: 200,
            color: Palette.purple,
            text: LocaleKeys.retryBtn.tr(),
            onPressed: Beamer.of(context).popRoute,
          ),
        ],
      ).padding(horizontal: 20, vertical: 40),
    ],
  );
}
