import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/subscription_cancellation_store.dart';
import 'package:mysterium_vpn/views/subscription/cancel_subscription_survey_view.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Shows the cancel confirmation prompt, then the survey (web) or store handoff.
Future<void> showCancelSubscriptionDialog(BuildContext context) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final store = container.read(subscriptionCancellationStorePOD)..reset();
  final analyticsStore = container.read(analyticsStorePOD);
  analyticsStore.logCancellationConfirmViewed().ignore();

  final didProceed = await showModal<bool>(
    context,
    // Keep alert chrome (not the desktop panel wrapper) on all form factors.
    screenType: ScreenType.mobile,
    builder: (modalContext) =>
        _CancelPrompt(onContinuePressed: () => Navigator.pop(modalContext, true)),
  );

  if (didProceed != true || !context.mounted) {
    store.reset();
    return;
  }

  analyticsStore.logCancellationStarted().ignore();

  // Store-managed: skip survey/pause and open the same manage-subscription flow
  // used by Settings (Play sku deep-link / StoreKit re-purchase of current plan).
  if (store.isStoreSubscription()) {
    await openCancelSubscriptionLink(context, store: store, analyticsStore: analyticsStore);
    store.reset();
    return;
  }

  await showCancelSubscriptionSurveyDialog(context);
}

Future<void> showCancelSubscriptionSurveyDialog(BuildContext context) async => showModal(
  context,
  builder: (ctx) => const ModalMessengerScope(child: CancelSubscriptionSurveyView()),
);

/// Hands the user off to cancel/manage: store subs use the existing manage-subscription
/// purchase flow; web subs open the billing manage page (same URL as Settings → Manage).
Future<void> openCancelSubscriptionLink(
  BuildContext context, {
  required SubscriptionCancellationStore store,
  required AnalyticsStore analyticsStore,
}) async {
  final container = ProviderScope.containerOf(context, listen: false);

  if (store.isStoreSubscription()) {
    try {
      await container.read(subscriptionPurchaseStorePOD).manageSubscription();
    } catch (_) {
      if (context.mounted) {
        showSnackbar(S.current.somethingWentWrong);
      }
    }
    return;
  }

  analyticsStore.logCancellationDashboardOpened().ignore();
  final managePage = container.read(remoteConfigStorePOD).manageSubscriptionPage;
  final accessToken = container.read(authSessionStorePOD).accessToken;
  final uri = Uri.parse(managePage);
  final httpsUri = Uri(
    scheme: uri.scheme,
    host: uri.host,
    path: uri.path,
    queryParameters: {'access_token': accessToken ?? ''},
  );
  await openUrlLink(httpsUri, source: RedirectSource.cancelSubscription);
}

/// Shows the continue to web prompt.
Future<void> showContinueToWebPrompt({
  required BuildContext context,
  required VoidCallback onContinuePressed,
}) async {
  await showModal(
    context,
    // Keep alert chrome (not the desktop panel wrapper) on all form factors.
    screenType: ScreenType.mobile,
    builder: (_) => _ContinueToWebPrompt(onContinuePressed: onContinuePressed),
  );
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
        child: Material(
          type: MaterialType.transparency,
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
                style: theme.textStyles.textMd.semibold.copyWith(
                  color: theme.palette.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ContinueToWebPrompt extends StatelessWidget {
  const _ContinueToWebPrompt({required this.onContinuePressed});

  final VoidCallback onContinuePressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 343),
        child: Material(
          type: MaterialType.transparency,
          child: AlertModal(
            icon: UntitledUI.link_external_02,
            title: S.current.continueCancellationOnWebTitle,
            supportingText: S.current.continueCancellationOnWebDesc,
            type: AlertModalType.warning,
            screenType: ScreenType.mobile,
            onClose: () => Navigator.pop(context),
            primaryButton: ButtonPrimary(
              onPressed: () {
                Navigator.pop(context);
                onContinuePressed();
              },
              child: Text(S.current.continueToWebBtn),
            ),
            secondaryButton: ButtonTertiary(
              onPressed: () => Navigator.pop(context),
              child: Text(
                S.current.stayOnAppBtn,
                style: theme.textStyles.textMd.semibold.copyWith(
                  color: theme.palette.textSecondary,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
