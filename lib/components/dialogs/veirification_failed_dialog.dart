import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/header_title.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:styled_widget/styled_widget.dart';

Future<void> shownVerificationFailedDialog(AsyncCallback onRetry, BuildContext context) async {
  await showBarModalBottomSheet(
    clipBehavior: Clip.none,
    expand: false,
    topControl: const SizedBox.shrink(),
    isDismissible: true,
    context: context,
    backgroundColor: Theme.of(context).primaryColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) => VerificationFailedDialog(onRetry: onRetry),
  );
}

class VerificationFailedDialog extends StatelessWidget {
  const VerificationFailedDialog({required this.onRetry, super.key});
  final AsyncCallback onRetry;
  @override
  Widget build(BuildContext context) => Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          const Positioned(
            top: -15,
            child: SvgIcon(
              asset: Assets.subscription,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              HeaderTitle(
                text: LocaleKeys.subscriptionVerificationFailed.tr(),
              ),
              EasyText(
                LocaleKeys.failedToVerifySubs.tr(),
                fontSize: 14,
                maxLines: 4,
                textAlign: TextAlign.center,
              ).padding(bottom: 30),
              EasyButton(
                useSystemColor: false,
                width: 200,
                color: Palette.purple,
                text: LocaleKeys.retryBtn.tr(),
                onPressed: () {
                  onRetry();
                  Beamer.of(context).popRoute();
                },
              ),
            ],
          ).padding(horizontal: 20, vertical: 40),
        ],
      );
}
