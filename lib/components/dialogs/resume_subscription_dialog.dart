import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Confirms resume, runs it in-place with a button spinner, then pops.
///
/// Returns `true` when resume succeeds, `false` when dismissed. On failure the
/// dialog stays open and a toast is shown so the user can retry or go back.
Future<bool?> showResumeSubscriptionPrompt(BuildContext context) async => await showModal<bool?>(
  context,
  allowDismiss: false,
  screenType: ScreenType.mobile,
  builder: (context) => const _ResumeSubscriptionPrompt(),
);

class _ResumeSubscriptionPrompt extends HookConsumerWidget {
  const _ResumeSubscriptionPrompt();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isLoading = useState(false);

    Future<void> onResume() async {
      if (isLoading.value) {
        return;
      }
      isLoading.value = true;
      final analyticsStore = ref.read(analyticsStorePOD);
      final subscriptionStore = ref.read(subscriptionStorePOD);
      final before = subscriptionStore.subscriptionFuture.value;
      final subscriptionId = before?.id ?? '';
      final statusBefore = before?.analyticsStatus ?? 'paused';
      analyticsStore
          .logSubscriptionResumeStarted(
            subscriptionId: subscriptionId,
            pauseEndDate: before?.pausedUntil?.toIso8601String(),
          )
          .ignore();
      try {
        await subscriptionStore.resumeSubscription();
        final after = subscriptionStore.subscriptionFuture.value;
        analyticsStore
            .logSubscriptionResumeCompleted(
              subscriptionId: after?.id ?? subscriptionId,
              subscriptionStatusBefore: statusBefore,
              subscriptionStatusAfter: after?.analyticsStatus ?? 'active',
              billingResumeDate: after?.activeUntil?.toIso8601String(),
            )
            .ignore();
        showSnackbar(S.current.subscriptionResumed, type: SnackbarType.success);
        if (context.mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        analyticsStore
            .logSubscriptionResumeFailed(
              subscriptionId: subscriptionId,
              failureReason: e.toString(),
            )
            .ignore();
        showSnackbar(S.current.resumeSubscriptionFailed);
        if (context.mounted) {
          isLoading.value = false;
        }
      }
    }

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 343),
        child: Material(
          type: MaterialType.transparency,
          child: AlertModal(
            icon: UntitledUI.star_06,
            title: S.current.resumeSubscriptionTitle,
            supportingText: S.current.resumeSubscriptionPromptDesc,
            screenType: ScreenType.mobile,
            onClose: isLoading.value ? null : () => Navigator.pop(context, false),
            primaryButton: ButtonPrimary(
              onPressed: isLoading.value ? null : onResume,
              loading: isLoading.value ? const ButtonLoading() : null,
              child: Text(S.current.resumeBtn),
            ),
            secondaryButton: ButtonTertiary(
              onPressed: isLoading.value ? null : () => Navigator.pop(context, false),
              child: Text(
                S.current.back,
                style: theme.textStyles.textMd.semibold.copyWith(color: theme.palette.textPrimary),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
