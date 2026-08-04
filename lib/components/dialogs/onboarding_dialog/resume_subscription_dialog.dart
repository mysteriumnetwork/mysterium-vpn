import 'package:flutter/material.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

Future<bool?> showResumeSubscriptionPrompt(BuildContext context) async =>
    await showModal<bool?>(context, builder: (context) => const _ResumeSubscriptionPrompt());

class _ResumeSubscriptionPrompt extends StatelessWidget {
  const _ResumeSubscriptionPrompt();

  @override
  Widget build(BuildContext context) => ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 343),
    child: AlertModal(
      icon: UntitledUI.star_06,
      title: S.current.resumeSubscriptionTitle,
      supportingText: S.current.resumeSubscriptionPromptDesc,
      screenType: ScreenType.mobile,
      onClose: () => Navigator.pop(context, false),
      primaryButton: ButtonPrimary(
        onPressed: () => Navigator.pop(context, true),
        child: Text(S.current.resumeBtn),
      ),
      secondaryButton: ButtonTertiary(
        onPressed: () => Navigator.pop(context, false),
        child: Text(S.current.back),
      ),
    ),
  );
}
