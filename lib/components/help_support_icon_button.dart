import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// The standard help-icon `IconButton` used in app headers. Opens the support
/// page via [handleOnSupportPage].
class HelpSupportIconButton extends ConsumerWidget {
  const HelpSupportIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => IconButton(
    icon: const Icon(UntitledUI.message_question_square, size: 24),
    onPressed: () =>
        handleOnSupportPage(context: context, analyticsStore: ref.read(analyticsStorePOD)),
  );
}
