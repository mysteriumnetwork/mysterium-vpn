import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/header_title.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:styled_widget/styled_widget.dart';

Future<void> showRetryDialog({
  required FutureOr<void> Function(BuildContext context) onRetry,
  required BuildContext context,
  required String title,
  required String subtitle,
  required SvgGenImage asset,
  FutureOr<void> Function(BuildContext context)? onDismiss,
  String? dismissText,
  bool? isDismissible,
}) async {
  await showBarModalBottomSheet(
    clipBehavior: Clip.none,
    topControl: const SizedBox.shrink(),
    isDismissible: isDismissible ?? true,
    context: context,
    backgroundColor: Theme.of(context).primaryColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) => VerificationFailedDialog(
      onRetry: onRetry,
      title: title,
      subtitle: subtitle,
      asset: asset,
      onDismiss: onDismiss,
      dismissText: dismissText,
    ),
  );
}

class VerificationFailedDialog extends StatelessWidget {
  const VerificationFailedDialog({
    required this.onRetry,
    required this.title,
    required this.subtitle,
    required this.asset,
    this.onDismiss,
    this.dismissText,
    super.key,
  });

  final FutureOr<void> Function(BuildContext context) onRetry;
  final FutureOr<void> Function(BuildContext context)? onDismiss;
  final String title;
  final String subtitle;
  final SvgGenImage asset;
  final String? dismissText;

  @override
  Widget build(BuildContext context) => SafeArea(
        top: false,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned(
              top: -15,
              child: SvgIcon(asset: asset),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HeaderTitle(
                  text: title,
                ),
                EasyText(
                  subtitle,
                  fontSize: 14,
                  maxLines: 4,
                  textAlign: TextAlign.center,
                ).padding(bottom: 30),
                Row(
                  mainAxisAlignment:
                      onDismiss != null ? MainAxisAlignment.spaceEvenly : MainAxisAlignment.center,
                  children: [
                    if (onDismiss != null)
                      EasyButton(
                        useSystemColor: false,
                        color: Palette.lightBlack,
                        text: dismissText ?? LocaleKeys.goBackButton.tr(),
                        onPressed: () => onDismiss!(context),
                        width: 160,
                      ),
                    EasyButton(
                      useSystemColor: false,
                      color: Palette.purple,
                      text: LocaleKeys.retryBtn.tr(),
                      onPressed: () async {
                        onRetry(context);
                        Beamer.of(context).popRoute();
                      },
                      width: onDismiss != null ? 160 : 200,
                    ),
                  ],
                ),
              ],
            ).padding(horizontal: 20, top: 40, bottom: 24),
          ],
        ),
      );
}
