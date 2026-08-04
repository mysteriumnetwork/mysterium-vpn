import 'package:flutter/material.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class CancelSubscriptionAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CancelSubscriptionAppBar({required this.onClose, this.title, super.key});

  final VoidCallback onClose;
  final String? title;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleText = title;
    return AppBar(
      title: titleText != null ? Text(titleText) : null,
      elevation: 0,
      backgroundColor: theme.palette.bgPopover,
      leading: const SizedBox.shrink(),
      actions: [
        Padding(
          padding: EdgeInsets.only(right: theme.spacing.xl2),
          child: IconButton(onPressed: onClose, icon: const Icon(UntitledUI.x_close)),
        ),
      ],
    );
  }
}
