import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/shared/components/easy_button.dart';
import 'package:mysterium_vpn/shared/components/easy_text.dart';
import 'package:mysterium_vpn/shared/components/header_title.dart';
import 'package:mysterium_vpn/shared/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:styled_widget/styled_widget.dart';

Future<bool?> shownDismissPageDialog(BuildContext context) async => showBarModalBottomSheet<bool>(
  clipBehavior: Clip.none,
  topControl: const SizedBox.shrink(),
  context: context,
  backgroundColor: Theme.of(context).primaryColor,
  shape: const RoundedRectangleBorder(
    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
  ),
  builder: (context) => const _DismissPageDialog(),
);

class _DismissPageDialog extends StatelessWidget {
  const _DismissPageDialog();

  @override
  Widget build(BuildContext context) => Stack(
    clipBehavior: Clip.none,
    alignment: Alignment.center,
    children: [
      Positioned(top: -15, child: SvgIcon(asset: Asset.icons.warning)),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          HeaderTitle(text: LocaleKeys.areYouSure.tr()),
          EasyText(
            LocaleKeys.logoutDescription.tr(),
            fontSize: 14,
            textAlign: TextAlign.center,
          ).padding(bottom: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              EasyButton(
                useSystemColor: false,
                width: 160,
                color: Palette.lightBlack,
                text: LocaleKeys.goBackButton.tr(),
                onPressed: () => Navigator.pop(context, true),
              ),
              EasyButton(
                useSystemColor: false,
                width: 160,
                color: Palette.purple,
                text: LocaleKeys.stayButton.tr(),
                onPressed: () => Navigator.pop(context, false),
              ),
            ],
          ),
        ],
      ).padding(horizontal: 20, vertical: 40),
    ],
  );
}
