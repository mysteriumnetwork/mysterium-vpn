// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

Future<void> shownConfirmationDialog(
  BuildContext context, {
  required String title,
  required Widget content,
  required VoidCallback onConfirm,
  Widget? icon,
  VoidCallback? onCancel,
  bool dismissible = true,
  String? confirmText,
  String? cancelText,
}) => showDialog(
  context: context,
  barrierDismissible: dismissible,
  builder: (context) => _ConfirmDialog(
    title: title,
    content: content,
    onConfirm: onConfirm,
    icon: icon,
    confirmText: confirmText,
    cancelText: cancelText,
    onCancel: onCancel,
  ),
);

class _ConfirmDialog extends StatelessWidget {
  const _ConfirmDialog({
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.icon,
    this.confirmText,
    this.cancelText,
    this.onCancel,
  });
  final String title;
  final Widget content;
  final Widget? icon;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;
  final String? confirmText;
  final String? cancelText;
  @override
  Widget build(BuildContext context) => AlertDialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    surfaceTintColor: Palette.white,
    titlePadding: EdgeInsets.only(top: icon != null ? 4 : 30, left: 16, right: 16, bottom: 8),
    contentPadding: const EdgeInsets.only(top: 4, bottom: 16, left: 16, right: 16),
    insetPadding: const EdgeInsets.symmetric(horizontal: 15),
    iconPadding: const EdgeInsets.only(top: 16, bottom: 8),
    backgroundColor: Palette.white,
    actionsAlignment: MainAxisAlignment.spaceAround,
    icon: icon,
    title: Text(
      title,
      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: Palette.black),
      textAlign: TextAlign.center,
    ),
    actions: [
      TextButton(
        style: ButtonStyle(foregroundColor: WidgetStateProperty.all(Palette.lightBlack)),
        child: Text(cancelText ?? LocaleKeys.no.tr()),
        onPressed: () {
          Navigator.pop(context);
          onCancel?.call();
        },
      ),
      TextButton(
        child: Text(confirmText ?? LocaleKeys.yes.tr()),
        onPressed: () {
          Navigator.pop(context);
          onConfirm();
        },
      ),
    ],
    content: SizedBox(width: getMediaWidth(context) > 750 ? 500 : 300, child: content),
  );
}
