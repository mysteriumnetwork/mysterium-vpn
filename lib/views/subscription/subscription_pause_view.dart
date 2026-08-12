import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/dialogs/dialogs.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/subscription/widgets/cancel_subscription_action_footer.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Optional pause offer. "Continue to cancel" opens the web confirmation prompt.
class SubscriptionPauseView extends HookConsumerWidget {
  const SubscriptionPauseView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final cancelSubscriptionStore = ref.read(subscriptionCancellationStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);
    final selectedPauseDuration = useState<String?>(null);

    useEffect(() {
      analyticsStore.logCancellationPauseOfferViewed().ignore();
      return null;
    }, const []);

    void handleDismiss() {
      cancelSubscriptionStore.reset();
      Navigator.of(context).pop();
    }

    Future<void> handleSubmit() async {
      final paused = await cancelSubscriptionStore.pauseSubscription(selectedPauseDuration.value!);
      if (!context.mounted) {
        return;
      }
      if (paused) {
        handleDismiss();
        return;
      }
      showSnackbar(S.current.pauseSubscriptionFailed);
    }

    Future<void> handleContinueOnWeb() async {
      analyticsStore.logCancellationPauseDeclined().ignore();
      final navigator = Navigator.of(context, rootNavigator: true);
      Navigator.of(context).pop();

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!navigator.mounted) {
          cancelSubscriptionStore.reset();
          return;
        }
        await showContinueToWebPrompt(
          context: navigator.context,
          onContinuePressed: () => openCancelSubscriptionLink(
            navigator.context,
            store: cancelSubscriptionStore,
            analyticsStore: analyticsStore,
          ),
        );
        cancelSubscriptionStore.reset();
      });
    }

    return ModalScaffold(
      showGradient: false,
      onModalClose: handleDismiss,
      appbar: ModalAppbar(title: S.current.notReadyToCancelTitle, onModalClose: handleDismiss),
      footer: Observer(
        builder: (context) => CancelSubscriptionActionFooter(
          primaryButtonLabel: S.current.pauseSubscriptionBtn,
          isProcessing: cancelSubscriptionStore.isProcessing,
          onPrimaryButtonPressed: handleSubmit,
          secondaryButtonLabel: S.current.continueToCancelBtn,
          onSecondaryButtonPressed: handleContinueOnWeb,
          primaryButtonEnabled: selectedPauseDuration.value != null,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: theme.spacing.xl2),
            Observer(
              builder: (context) => RadioGroup(
                groupValue: selectedPauseDuration.value,
                onChanged: (value) => selectedPauseDuration.value = value,
                child: Column(
                  children: cancelSubscriptionStore.availablePauseDurations
                      .where((it) => it.numeric != null)
                      .map(
                        (periodCode) => RadioListTile(
                          value: periodCode,
                          title: Text(S.current.pauseForMonths(periodCode.numeric!)),
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacing.md,
                vertical: theme.spacing.md,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: theme.palette.bgPrimary,
                  borderRadius: BorderRadius.circular(theme.spacing.md),
                  border: Border.all(color: theme.palette.borderPrimary),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                        theme.spacing.ms,
                        theme.spacing.ms,
                        theme.spacing.s,
                        theme.spacing.ms,
                      ),
                      child: CircleAvatar(
                        radius: theme.spacing.ms,
                        backgroundColor: theme.palette.bgSecondary,
                        child: Icon(
                          UntitledUI.info_circle,
                          size: theme.spacing.md,
                          color: theme.palette.iconTertiary,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: theme.spacing.md),
                        child: Text(
                          S.current.pauseSubscriptionInfoDesc,
                          style: theme.textStyles.textXs.medium.copyWith(
                            color: theme.palette.textTertiary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
