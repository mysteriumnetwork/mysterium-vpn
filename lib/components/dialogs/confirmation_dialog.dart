// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

Future<void> shownConfirmationDialog(
  BuildContext context, {
  required String title,
  required Widget content,
  required VoidCallback onConfirm,
  required Widget icon,
  bool dismissible = true,
  String? confirmText,
  String? cancelText,
}) async {
  showDialog(
    context: context,
    barrierDismissible: dismissible,
    builder: (context) => _SuggestLoginDialog(
      title: title,
      content: content,
      onConfirm: onConfirm,
      icon: icon,
      confirmText: confirmText,
      cancelText: cancelText,
    ),
  );
}

class _SuggestLoginDialog extends StatelessWidget {
  const _SuggestLoginDialog({
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.icon,
    this.confirmText,
    this.cancelText,
  });
  final String title;
  final Widget content;
  final Widget icon;
  final VoidCallback onConfirm;
  final String? confirmText;
  final String? cancelText;
  @override
  Widget build(BuildContext context) => SizedBox(
        width: 200,
        child: AlertDialog(
          surfaceTintColor: Palette.white,
          titlePadding: const EdgeInsets.only(top: 4, left: 16, right: 16),
          contentPadding: const EdgeInsets.only(top: 4, bottom: 16, left: 16, right: 16),
          insetPadding: const EdgeInsets.symmetric(horizontal: 15),
          iconPadding: const EdgeInsets.only(top: 16, bottom: 8),
          backgroundColor: Palette.white,
          icon: icon,
          title: Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: Palette.black,
            ),
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.all(Palette.lightBlack),
              ),
              child: Text(cancelText ?? LocaleKeys.no.tr()),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(confirmText ?? LocaleKeys.yes.tr()),
              onPressed: () {
                Navigator.pop(context);
                onConfirm();
              },
            ),
          ],
          content: content,
        ),
      );
}
