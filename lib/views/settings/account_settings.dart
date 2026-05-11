import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/hooks/future_status_hook.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/settings/settings_action_button.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class AccountSettings extends HookConsumerWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authSessionStore = ref.watch(authSessionStorePOD);
    final authStatus = useComputedValue(() => authSessionStore.status);

    return switch (authStatus) {
      AuthStatus.authenticated => const _Authenticated(),
      AuthStatus.unauthenticated => const _Unauthenticated(),
      _ => const SizedBox.shrink(),
    };
  }
}

class _Unauthenticated extends HookConsumerWidget {
  const _Unauthenticated();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;
    final spacing = theme.spacing;
    void handleSignIn() => context.beamToNamed(Routes.platformLogin.path);

    return Padding(
      padding: EdgeInsets.fromLTRB(
        isDesktop ? spacing.xl3 : spacing.md,
        isDesktop ? spacing.xl7 : spacing.xl6,
        isDesktop ? spacing.xl3 : spacing.md,
        spacing.xl3, // same in both cases
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: spacing.xl5,
              height: spacing.xl5,
              decoration: BoxDecoration(
                color: theme.palette.bgSecondarySelected,
                shape: BoxShape.circle,
              ),
              child: Icon(UntitledUI.user_02, size: 24, color: theme.palette.textBrandPrimary),
            ),
            SizedBox(height: spacing.md),
            Text(
              LocaleKeys.unauthenticatedSettingTitle.tr(),
              style: theme.textStyles.textLg.semibold.copyWith(color: theme.palette.textPrimary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.lg),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 343),
              child: Text(
                LocaleKeys.unauthenticatedSettingSubtitle.tr(),
                style: theme.textStyles.textSm.regular.copyWith(color: theme.palette.textSecondary),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: spacing.xl3),
            SizedBox(
              width: isDesktop ? null : double.infinity,
              child: ButtonPrimary(
                onPressed: handleSignIn,
                size: ButtonSize.large,
                child: Text(LocaleKeys.signInBtn.tr()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Authenticated extends HookConsumerWidget {
  const _Authenticated();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionStore = ref.read(subscriptionStorePOD);
    final authStore = ref.watch(authStorePOD);
    final authSessionStore = ref.watch(authSessionStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);
    final remoteConfigStore = ref.read(remoteConfigStorePOD);
    final vpnStore = ref.read(vpnStorePOD);

    final handleSubscribe = useHandleSubscribe();
    final (notifier, subscribeStatus) = useFutureStatus();

    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;
    final theme = Theme.of(context);

    useValueChanged<AsyncSnapshot<void>, void>(subscribeStatus, (_, _) {
      if (subscribeStatus.hasError) {
        showSnackbar(LocaleKeys.somethingWentWrong.tr());
      }
    });

    void handleLogout() {
      analyticsStore.logEvent(AnalyticsEvent.logOutPopup);
      showLogoutConfirmationDialog(
        context,
        supportingText: vpnStore.isConnected
            ? LocaleKeys.logoutVPNConnectedDesc.tr()
            : LocaleKeys.logoutConfirmationDesc.tr(),
        onConfirm: () async {
          analyticsStore.logEvent(AnalyticsEvent.logOutConfirm);
          await vpnStore.disconnectTunnel();
          authStore.logout();
        },
        onCancel: () {
          analyticsStore.logEvent(AnalyticsEvent.logOutCancel);
        },
      );
    }

    void handleDeleteAccount() {
      analyticsStore.logEvent(AnalyticsEvent.deleteAccount);
      shownDeleteAccountDialog(
        context,
        authStore: authStore,
        analyticsStore: analyticsStore,
        vpnStore: vpnStore,
      );
    }

    Future<void> onSubscribePress({required bool manageSubscription}) async {
      await notifier.runAndAwait(
        () async => handleSubscribe(manageSubscription: manageSubscription),
      );
    }

    final email = authSessionStore.user?.username ?? '';
    final showDeleteAccount = !remoteConfigStore.hideDeleteAccount;

    final cards = Column(
      children: [
        SettingsCard(
          title: email.isEmpty ? LocaleKeys.account.tr() : email,
          position: SettingsCardPosition.top,
          trailing: isDesktop
              ? SettingsActionButton(
                  onPressed: handleLogout,
                  foregroundColor: theme.palette.textErrorPrimary,
                  child: Text(LocaleKeys.logout.tr()),
                )
              : null,
        ),
        _SubscriptionCard(
          subscriptionStore: subscriptionStore,
          analyticsStore: analyticsStore,
          position: showDeleteAccount ? SettingsCardPosition.middle : SettingsCardPosition.bottom,
          isSubscribing: subscribeStatus.isLoading,
          isDesktop: isDesktop,
          onSubscribePress: onSubscribePress,
        ),
        if (showDeleteAccount)
          SettingsCard(
            title: LocaleKeys.deleteAccount.tr(),
            position: SettingsCardPosition.bottom,
            trailing: SettingsActionButton(
              onPressed: handleDeleteAccount,
              child: Text(LocaleKeys.deleteBtn.tr()),
            ),
          ),
      ],
    );

    if (isDesktop) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: theme.spacing.xl3),
        child: cards,
      );
    }

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
          sliver: SliverToBoxAdapter(child: cards),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ButtonSecondary(
                  onPressed: handleLogout,
                  child: Text(
                    LocaleKeys.logout.tr(),
                    style: theme.textStyles.textMd.semibold.copyWith(
                      color: theme.palette.textErrorPrimary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SubscriptionCard extends StatelessWidget {
  const _SubscriptionCard({
    required this.subscriptionStore,
    required this.analyticsStore,
    required this.position,
    required this.isSubscribing,
    required this.isDesktop,
    required this.onSubscribePress,
  });

  final SubscriptionStore subscriptionStore;
  final AnalyticsStore analyticsStore;
  final SettingsCardPosition position;
  final bool isSubscribing;
  final bool isDesktop;
  final Future<void> Function({required bool manageSubscription}) onSubscribePress;

  @override
  Widget build(BuildContext context) => Observer(
    builder: (_) {
      final subscription = subscriptionStore.subscriptionFuture.value;
      final isLoading = subscriptionStore.subscriptionFuture.status == FutureStatus.pending;
      final isSubscriptionActive = subscription?.active ?? false;

      Widget trailing;
      if (isLoading) {
        trailing = const LoadingIndicator();
      } else if (subscriptionStore.subscriptionFuture.status == FutureStatus.rejected) {
        trailing = SettingsActionButton(
          onPressed: subscriptionStore.refreshSubscription,
          child: Text(LocaleKeys.retryBtn.tr()),
        );
      } else if (!isSubscriptionActive) {
        trailing = SettingsActionButton(
          onPressed: isSubscribing
              ? null
              : () {
                  analyticsStore.logEvent(AnalyticsEvent.clickSeeAllPlans);
                  onSubscribePress(manageSubscription: false);
                },
          child: isSubscribing
              ? const LoadingIndicator()
              : Text(LocaleKeys.pricingPlanSeePlansBtn.tr()),
        );
      } else {
        final manageButton = SettingsActionButton(
          onPressed: isSubscribing
              ? null
              : () async {
                  analyticsStore.logEvent(AnalyticsEvent.manageSubscription);
                  await onSubscribePress(manageSubscription: true);
                },
          child: Text(LocaleKeys.settingManageBtn.tr()),
        );
        final cancelButton = SettingsActionButton(
          onPressed: isSubscribing
              ? null
              : () async {
                  final shouldProceed = await showCancelSubscriptionSurveyDialog(context);
                  if (shouldProceed ?? false) {
                    await onSubscribePress(manageSubscription: true);
                  }
                },
          child: Text(LocaleKeys.cancelBtn.tr()),
        );
        final spacing = Theme.of(context).spacing;
        trailing = isDesktop
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  manageButton,
                  SizedBox(width: spacing.md),
                  cancelButton,
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  manageButton,
                  SizedBox(height: spacing.xs),
                  cancelButton,
                ],
              );
      }

      final planTitle = isSubscriptionActive
          ? (subscription!.planId?.tr() ?? LocaleKeys.subscripton.tr())
          : LocaleKeys.subscripton.tr();
      final planSubtitle = isSubscriptionActive
          ? LocaleKeys.nextBilling.tr(
              namedArgs: {'date': subscription!.activeUntil?.toLocal().formatWithDay() ?? ''},
            )
          : LocaleKeys.noActiveSubsDesc.tr();

      return SettingsCard(
        title: planTitle,
        subtitle: planSubtitle,
        position: position,
        trailing: trailing,
      );
    },
  );
}
