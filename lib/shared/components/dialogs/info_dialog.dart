import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/shared/components/easy_button.dart';
import 'package:mysterium_vpn/shared/components/easy_text.dart';
import 'package:mysterium_vpn/shared/components/svg_icon.dart';
import 'package:styled_widget/styled_widget.dart';

Future<void> shownInfoDialog(
  BuildContext context,
  String title, {
  required bool isDismissible,
  List<String>? messages,
  AsyncCallback? onConfirm,
  String? confirmText,
}) async {
  await showModalBottomSheet(
    clipBehavior: Clip.none,
    isScrollControlled: true,
    isDismissible: isDismissible,
    constraints: const BoxConstraints.tightFor(width: double.infinity),
    context: context,
    backgroundColor: Theme.of(context).primaryColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) => Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: _InfoDialog(
        title: title,
        messages: messages,
        onConfirm: onConfirm,
        confirmText: confirmText,
      ),
    ),
  );
}

class _InfoDialog extends StatelessWidget {
  const _InfoDialog({required this.title, this.messages, this.onConfirm, this.confirmText});

  final String title;
  final List<String>? messages;
  final AsyncCallback? onConfirm;
  final String? confirmText;

  @override
  Widget build(BuildContext context) => Stack(
    clipBehavior: Clip.none,
    alignment: Alignment.center,
    children: [
      Positioned(top: -15, child: SvgIcon(asset: Asset.icons.warning)),
      Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          EasyText(
            title,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            maxLines: 3,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          if (messages != null && messages!.isNotEmpty) ...[
            for (final message in messages!)
              EasyText(
                message,
                fontSize: 14,
                maxLines: 4,
                textAlign: TextAlign.center,
              ).padding(bottom: 6),
            const SizedBox(height: 30),
          ],
          EasyButton(
            useSystemColor: false,
            width: 160,
            color: Palette.pink,
            onPressed: onConfirm ?? () => Beamer.of(context).popRoute(),
            text: confirmText ?? LocaleKeys.continueBtn.tr(),
          ),
        ],
      ).padding(horizontal: 20, vertical: 40),
    ],
  );
}
