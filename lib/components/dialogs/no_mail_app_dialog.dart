import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide Radius;
import 'package:styled_widget/styled_widget.dart';

Future<void> shownNoMailAppDialog(BuildContext context) async {
  await showBarModalBottomSheet(
    clipBehavior: Clip.none,
    topControl: const SizedBox.shrink(),
    context: context,
    backgroundColor: Theme.of(context).primaryColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) => const NoMailAppDialog(),
  );
}

class NoMailAppDialog extends StatelessWidget {
  const NoMailAppDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned(top: -15, child: SvgIcon(asset: Asset.icons.message)),
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            HeaderTitle(text: LocaleKeys.openEmailApp.tr()),
            Text(
              LocaleKeys.noEmailApp.tr(),
              maxLines: 4,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              style: theme.textStyles.textSm.regular,
            ).padding(bottom: 30),
            ButtonPrimary(
              onPressed: () {
                Beamer.of(context).popRoute();
              },
              decoration: const ButtonDecoration(minimumSize: Size(200, 50)),
              child: Text(LocaleKeys.goBackButton.tr()),
            ),
          ],
        ).padding(horizontal: 20, vertical: 40),
      ],
    );
  }
}
