import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/ui/ui.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class UnauthenticatedHeader extends HookConsumerWidget {
  const UnauthenticatedHeader({this.backLabel, super.key});

  /// Shown next to the back arrow when back closes the auth flow. Ignored on a
  /// page stacked on another auth page, where back is a step back, not a close.
  final String? backLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    final authSessionStore = ref.read(authSessionStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);
    final canBrowseApp = useComputedValue(() => authSessionStore.canBrowseApp);
    // A page stacked on another auth page (check-your-email) steps back to it;
    // a root auth page closes the flow to home, when the app may be browsed.
    final canStepBack = Navigator.maybeOf(context)?.canPop() ?? false;
    final showBackButton = canStepBack || canBrowseApp;

    Future<void> handleBack() async {
      if (canStepBack) {
        await Navigator.of(context).maybePop();
        return;
      }
      Beamer.of(context).beamToNamed(Routes.main.path);
    }

    return Header(
      backgroundColor: palette.bgSidePanel,
      showBackButton: showBackButton,
      backLabel: canStepBack ? null : backLabel ?? S.current.back,
      onBackPressed: showBackButton ? handleBack : null,
      actions: [
        IconButton(
          onPressed: () => handleOnSupportPage(context: context, analyticsStore: analyticsStore),
          icon: Icon(UntitledUI.message_question_square, size: 24, color: palette.iconPrimary),
        ),
      ],
    );
  }
}
