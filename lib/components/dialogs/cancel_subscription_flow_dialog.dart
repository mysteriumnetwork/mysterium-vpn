import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/platform.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/subscription/cancel_subscription_flow_view.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Opens the CancelSubscription flow.
///
/// Shows a confirmation prompt first. On continue:
/// - Desktop: full multi-step flow in a modal
/// - Mobile: Navigates to CancelSubscriptionPage
Future<void> showCancelSubscriptionFlowDialog(BuildContext context) async {
  final store = ProviderScope.containerOf(
    context,
    listen: false,
  ).read(subscriptionCancellationStorePOD)..reset();

  final didProceed = await showModal<bool>(
    context,
    builder: (modalContext) =>
        _CancelPrompt(onContinuePressed: () => Navigator.pop(modalContext, true)),
  );

  if (didProceed != true) {
    store.reset();
    return;
  }

  if (!context.mounted) {
    store.reset();
    return;
  }

  store.onCancellationConfirmed();

  if (isDesktop()) {
    await showModal(context, builder: (_) => const CancelSubscriptionFlowView());
    store.reset();
    return;
  }

  Beamer.of(context).beamToNamed(Routes.cancelSubscription.path);
}

class _CancelPrompt extends StatelessWidget {
  const _CancelPrompt({required this.onContinuePressed});

  final VoidCallback onContinuePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 343),
        child: AlertModal(
          title: S.current.cancelSubscriptionTitle,
          supportingText: S.current.cancelSubscriptionPromptDesc,
          type: AlertModalType.warning,
          screenType: ScreenType.mobile,
          onClose: () => Navigator.pop(context),
          primaryButton: ButtonPrimary(
            onPressed: onContinuePressed,
            child: Text(S.current.continueBtn),
          ),
          secondaryButton: ButtonTertiary(
            onPressed: () async => Navigator.pop(context),
            child: Text(
              S.current.keepSubscriptionBtn,
              style: theme.textStyles.textMd.semibold.copyWith(color: theme.palette.textSecondary),
            ),
          ),
        ),
      ),
    );
  }
}
