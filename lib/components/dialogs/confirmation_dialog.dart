// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

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
    titlePadding: EdgeInsets.only(top: icon != null ? 4 : 30, left: 16, right: 16, bottom: 8),
    contentPadding: const EdgeInsets.only(top: 4, bottom: 16, left: 16, right: 16),
    insetPadding: const EdgeInsets.symmetric(horizontal: 15),
    iconPadding: const EdgeInsets.only(top: 16, bottom: 8),
    actionsAlignment: MainAxisAlignment.spaceAround,
    icon: icon,
    title: Text(
      title,
      style: Theme.of(context).textTheme.headlineSmall,
      textAlign: TextAlign.center,
    ),
    actions: [
      ButtonTertiary(
        decoration: ButtonDecoration(foregroundColor: Theme.of(context).palette.textTertiary),
        child: Text(cancelText ?? LocaleKeys.no.tr()),
        onPressed: () {
          Navigator.pop(context);
          onCancel?.call();
        },
      ),
      ButtonTertiary(
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
