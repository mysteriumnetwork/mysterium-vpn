import 'package:beamer/beamer.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/platform.dart';
import 'package:mysterium_vpn/components/dialogs/dialogs.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/l10n/tr_bridge.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/subscription/subscription_pause_view.dart';
import 'package:mysterium_vpn/views/subscription/widgets/cancel_subscription_action_footer.dart';
import 'package:mysterium_vpn/views/subscription/widgets/cancel_subscription_app_bar.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:url_launcher/url_launcher_string.dart';

part 'widgets/cancel_subscription_form.dart';
part 'widgets/cancel_subscription_reasons_field.dart';

/// Cancellation survey. After continue/skip it should ask the store whether
/// pause is available otherwise it opens the web confirmation prompt.
class CancelSubscriptionSurveyView extends HookConsumerWidget {
  const CancelSubscriptionSurveyView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final remoteConfigStore = ref.watch(remoteConfigStorePOD);
    final cancelSubscriptionStore = ref.read(subscriptionCancellationStorePOD);

    final reasons = useComputedValue(() {
      final keys = remoteConfigStore.cancelSubscriptionReasonKeys?.shuffled();
      keys?.remove(kCancelReasonOther);
      return {...?keys, kCancelReasonOther};
    });

    final form = _useForm();

    void handleDismiss() {
      cancelSubscriptionStore.reset();
      if (isDesktop()) {
        Navigator.of(context).pop();
        return;
      }
      final beamer = Beamer.of(context);
      if (beamer.canBeamBack) {
        beamer.beamBack();
      } else {
        beamer.beamToNamed(Routes.main.path);
      }
    }

    Future<void> proceed() async {
      final canPause = await cancelSubscriptionStore.canPauseSubscription();
      if (!context.mounted) {
        return;
      }

      if (canPause) {
        if (isDesktop()) {
          final navigator = Navigator.of(context, rootNavigator: true)..pop();
          WidgetsBinding.instance.addPostFrameCallback((_) async {
            if (!navigator.mounted) {
              cancelSubscriptionStore.reset();
              return;
            }
            await showModal(navigator.context, builder: (_) => const SubscriptionPauseView());
          });
          return;
        }
        Beamer.of(context).beamToReplacementNamed(Routes.cancelSubscriptionPause.path);
        return;
      }

      final link = cancelSubscriptionStore.linkToCancelSubscription;
      final navigator = Navigator.of(context, rootNavigator: true);
      if (isDesktop()) {
        navigator.pop();
      } else {
        final beamer = Beamer.of(context);
        if (beamer.canBeamBack) {
          beamer.beamBack();
        } else {
          beamer.beamToNamed(Routes.main.path);
        }
      }

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        if (!navigator.mounted) {
          cancelSubscriptionStore.reset();
          return;
        }
        await showContinueToWebPrompt(
          context: navigator.context,
          onContinuePressed: () => launchUrlString(link),
        );
        cancelSubscriptionStore.reset();
      });
    }

    Future<void> handleSkip() async {
      await proceed();
    }

    Future<void> handleSubmit() async {
      await cancelSubscriptionStore.setSurvey(
        reasons: form.reasons.value ?? {},
        feedback: form.feedback.value?.trim(),
      );
      if (!context.mounted) {
        return;
      }
      await proceed();
    }

    return Scaffold(
      appBar: isDesktop()
          ? CancelSubscriptionAppBar(
              title: '${S.current.cancelSurveyTitle} (${S.current.optional})',
              onClose: handleDismiss,
            )
          : null,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            if (!isDesktop())
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Header(
                      showBackButton: true,
                      backgroundColor: theme.palette.bgPopover,
                      backLabel: S.current.back,
                      onBackPressed: handleDismiss,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: S.current.cancelSurveyTitle,
                              style: theme.textStyles.textLg.semibold.copyWith(fontSize: 24),
                            ),
                            TextSpan(
                              text: ' (${S.current.optional})',
                              style: theme.textStyles.textMd.medium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(theme.spacing.xl2),
                child: _Form(form: form, items: reasons),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CancelSubscriptionActionFooter(
                  primaryButtonLabel: S.current.continueBtn,
                  onPrimaryButtonPressed: handleSubmit,
                  secondaryButtonLabel: S.current.skipBtn,
                  onSecondaryButtonPressed: handleSkip,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
