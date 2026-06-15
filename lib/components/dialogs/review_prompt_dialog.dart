import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/utils/url_launcher.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

enum _SatisfactionAction { yes, no, dismiss }

enum _PositiveAction { review, dismiss }

/// Entry point for the review/feedback flow. Records the display, shows the
/// satisfaction modal, then routes to the positive (native review) or negative
/// (support) flow based on the user's choice. Dismissal starts a cooldown.
Future<void> showReviewPromptDialog(BuildContext context) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final store = container.read(reviewPromptStorePOD);
  final analyticsStore = container.read(analyticsStorePOD);

  await store.onShown();
  if (!context.mounted) {
    return;
  }

  final action = await _showSatisfactionModal(context);

  switch (action ?? _SatisfactionAction.dismiss) {
    case _SatisfactionAction.yes:
      await store.onSatisfactionYes();
      if (context.mounted) {
        await _showPositiveModal(context, store);
      }
    case _SatisfactionAction.no:
      await store.onSatisfactionNo();
      if (context.mounted) {
        handleOnSupportPage(context: context, analyticsStore: analyticsStore);
      }
    case _SatisfactionAction.dismiss:
      await store.onDismiss();
  }
}

/// Wraps a modal body in a transparent, compact, centred dialog (max 360 wide,
/// 16px inset). Both review modals pass [ScreenType.mobile] to their
/// [AlertModal] so the layout is identical on mobile and desktop.
Widget _reviewDialog({required Widget child}) => Dialog(
  backgroundColor: Colors.transparent,
  elevation: 0,
  insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
  constraints: const BoxConstraints(maxWidth: 360),
  child: child,
);

Future<_SatisfactionAction?> _showSatisfactionModal(BuildContext context) =>
    showDialog<_SatisfactionAction>(
      context: context,
      builder: (context) => _reviewDialog(
        child: AlertModal(
          screenType: ScreenType.mobile,
          showIcon: false,
          title: LocaleKeys.reviewSatisfactionTitle.tr(),
          onClose: () => Navigator.of(context).pop(_SatisfactionAction.dismiss),
          // Figma: 40 top / 32 bottom / 16 sides.
          padding: EdgeInsets.fromLTRB(
            Theme.of(context).spacing.md,
            Theme.of(context).spacing.xl4,
            Theme.of(context).spacing.md,
            Theme.of(context).spacing.xl3,
          ),
          primaryButton: Row(
            spacing: Theme.of(context).spacing.s,
            children: [
              Expanded(
                child: ButtonSecondary(
                  onPressed: () => Navigator.of(context).pop(_SatisfactionAction.yes),
                  leading: const Icon(UntitledUI.thumbs_up, size: 16),
                  child: Text(LocaleKeys.yes.tr()),
                ),
              ),
              Expanded(
                child: ButtonSecondary(
                  onPressed: () => Navigator.of(context).pop(_SatisfactionAction.no),
                  leading: const Icon(UntitledUI.thumbs_down, size: 16),
                  child: Text(LocaleKeys.no.tr()),
                ),
              ),
            ],
          ),
        ),
      ),
    );

Future<void> _showPositiveModal(BuildContext context, ReviewPromptStore store) async {
  final action = await showDialog<_PositiveAction>(
    context: context,
    builder: (context) => _reviewDialog(
      child: AlertModal(
        screenType: ScreenType.mobile,
        icon: UntitledUI.thumbs_up,
        title: LocaleKeys.reviewPositiveTitle.tr(),
        onClose: () => Navigator.of(context).pop(_PositiveAction.dismiss),
        primaryButton: ButtonPrimary(
          onPressed: () => Navigator.of(context).pop(_PositiveAction.review),
          child: Text(LocaleKeys.reviewLeaveReviewBtn.tr()),
        ),
        secondaryButton: ButtonSecondary(
          onPressed: () => Navigator.of(context).pop(_PositiveAction.dismiss),
          child: Text(LocaleKeys.notNowBtn.tr()),
        ),
      ),
    ),
  );

  switch (action ?? _PositiveAction.dismiss) {
    case _PositiveAction.review:
      await store.onLeaveReview();
      // Best-effort: open the native review, falling back to the store page.
      // Never let a failed launch (unsupported platform, missing store id,
      // no browser) crash the flow — the cooldown is already recorded.
      try {
        final requested = await InAppReviewService().requestReview();
        if (!requested) {
          await openAppStorePage();
        }
      } catch (_) {
        // Swallowed intentionally; nothing actionable for the user here.
      }
    case _PositiveAction.dismiss:
      await store.onDismiss();
  }
}
