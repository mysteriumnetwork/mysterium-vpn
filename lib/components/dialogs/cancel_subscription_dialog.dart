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
Future<void> showCancelSubscriptionDialog(
  BuildContext context, {
  String entrypoint = 'account',
}) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final store = container.read(subscriptionCancellationStorePOD)..reset();
  final analyticsStore = container.read(analyticsStorePOD);
  analyticsStore.logCancellationStarted(entrypoint: entrypoint).ignore();
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

/// Hands the user off to cancel: store subs use the existing manage-subscription
/// purchase flow; web subs open [RemoteConfigStore.cancelSubscriptionPage]
/// (Env `CANCEL_SUBS_PAGE` when ConfigCat has no override).
Future<void> openCancelSubscriptionLink(
  BuildContext context, {
  required SubscriptionCancellationStore store,
  required AnalyticsStore analyticsStore,
}) async {
  final container = ProviderScope.containerOf(context, listen: false);
  final subscription = container.read(subscriptionStorePOD).subscriptionFuture.value;
  final subscriptionId = subscription?.id ?? '';

  if (store.isStoreSubscription()) {
    try {
      final navigator = Navigator.of(context);
      analyticsStore
          .logStoreSubscriptionManageClicked(
            store: subscription?.gateway?.toLowerCase() ?? 'store',
            subscriptionId: subscriptionId,
          )
          .ignore();
      await container.read(subscriptionPurchaseStorePOD).manageSubscription();
      // On iOS, the subscription page opens in-app and doesn't refresh the subscription after closing.
      // On Android, the same issue can happen if the user returns directly to the app.
      Future.delayed(const Duration(seconds: 2), () async {
        if (!navigator.mounted) {
          return;
        }
        try {
          await container.read(subscriptionStorePOD).refreshSubscription(force: true);
        } catch (_) {
          // Best-effort refresh after store handoff; resume refresh is the fallback.
        }
      });
    } catch (e) {
      analyticsStore
          .logCancellationRedirectFailed(
            subscriptionId: subscriptionId,
            failureReason: e.toString(),
          )
          .ignore();
      if (context.mounted) {
        showSnackbar(S.current.somethingWentWrong);
      }
    }
    return;
  }

  analyticsStore
      .logCancellationDashboardOpened(
        source: RedirectSource.cancelSubscription.formattedName,
        subscriptionId: subscriptionId,
        pauseOfferShown: store.pauseOfferShown,
      )
      .ignore();
  final cancelPage = container.read(remoteConfigStorePOD).cancelSubscriptionPage;
  final accessToken = container.read(authSessionStorePOD).accessToken;
  final uri = Uri.parse(cancelPage);
  final queryParameters = Map<String, String>.from(uri.queryParameters);
  if (accessToken != null && accessToken.isNotEmpty) {
    queryParameters['access_token'] = accessToken;
  }
  final cancelUri = uri.replace(queryParameters: queryParameters);
  final opened = await openUrlLink(cancelUri, source: RedirectSource.cancelSubscription);
  if (!opened) {
    analyticsStore
        .logCancellationRedirectFailed(
          subscriptionId: subscriptionId,
          failureReason: 'could_not_launch_url',
        )
        .ignore();
  }
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
