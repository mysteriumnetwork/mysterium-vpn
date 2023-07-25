import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:styled_widget/styled_widget.dart';

Future<void> shownInfoDialog(
  BuildContext context,
  String title, {
  required bool isDismissible,
  List<String>? messages,
  AsyncCallback? onConfirm,
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
      ),
    ),
  );
}

class _InfoDialog extends HookWidget {
  const _InfoDialog({
    required this.title,
    this.messages,
    this.onConfirm,
  });
  final String title;
  final List<String>? messages;
  final AsyncCallback? onConfirm;
  @override
  Widget build(BuildContext context) => Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          const Positioned(
            top: -15,
            child: SvgIcon(
              asset: Assets.warning,
            ),
          ),
          Observer(
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                EasyText(
                  title,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  maxLines: 3,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                if (messages != null && messages!.isNotEmpty) ...[
                  for (var message in messages!)
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
                  text: LocaleKeys.continueBtn.tr(),
                ),
              ],
            ).padding(horizontal: 20, vertical: 40),
          ),
        ],
      );
}
