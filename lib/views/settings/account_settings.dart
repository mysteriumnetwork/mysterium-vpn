import 'package:beamer/beamer.dart';
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
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/l10n/tr_bridge.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/settings/settings_action_button.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:sliver_tools/sliver_tools.dart';

class AccountSettings extends HookConsumerWidget {
  const AccountSettings({super.key, this.asSliver = false});

  /// When `true`, the widget returns slivers (for embedding inside a parent
  /// [CustomScrollView]) instead of a self-contained scrollable widget.
  final bool asSliver;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authSessionStore = ref.watch(authSessionStorePOD);
    final authStatus = useComputedValue(() => authSessionStore.status, [authSessionStore]);

    return switch (authStatus) {
      AuthStatus.authenticated => _Authenticated(asSliver: asSliver),
      AuthStatus.unauthenticated => _Unauthenticated(asSliver: asSliver),
      _ => asSliver ? const SliverToBoxAdapter(child: SizedBox.shrink()) : const SizedBox.shrink(),
    };
  }
}

class _Unauthenticated extends HookConsumerWidget {
  const _Unauthenticated({this.asSliver = false});

  final bool asSliver;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;
    final spacing = theme.spacing;
    void handleSignIn() => context.beamToNamed(Routes.platformLogin.path);

    final body = Padding(
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
              S.current.unauthenticatedSettingTitle,
              style: theme.textStyles.textLg.semibold.copyWith(color: theme.palette.textPrimary),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.lg),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 343),
              child: Text(
                S.current.unauthenticatedSettingSubtitle,
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
                child: Text(S.current.signInBtn),
              ),
            ),
          ],
        ),
      ),
    );

    if (asSliver) {
      return SliverFillRemaining(hasScrollBody: false, child: body);
    }
    return body;
  }
}

class _Authenticated extends HookConsumerWidget {
  const _Authenticated({this.asSliver = false});

  final bool asSliver;

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
        showSnackbar(S.current.somethingWentWrong);
      }
    });

    void handleLogout() {
      analyticsStore.logEvent(AnalyticsEvent.logOutPopup);
      showLogoutConfirmationDialog(
        context,
        supportingText: vpnStore.isConnected
            ? S.current.logoutVPNConnectedDesc
            : S.current.logoutConfirmationDesc,
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

    Future<void> onResumePress() async {
      await showResumeSubscriptionPrompt(context);
    }

    // `user` is populated asynchronously by fetchAuthUser after login, so read
    // it reactively — otherwise the email stays blank until the widget is
    // rebuilt for another reason (e.g. switching settings tabs).
    final email = useComputedValue(() => authSessionStore.user?.username ?? '', [authSessionStore]);
    final showDeleteAccount = !remoteConfigStore.hideDeleteAccount;

    final cards = Column(
      children: [
        SettingsCard(
          title: email.isEmpty ? S.current.account : email,
          position: SettingsCardPosition.top,
          trailing: isDesktop
              ? SettingsActionButton(
                  onPressed: handleLogout,
                  foregroundColor: theme.palette.textErrorPrimary,
                  child: Text(S.current.logout),
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
          onResumePress: onResumePress,
        ),
        if (showDeleteAccount)
          SettingsCard(
            title: S.current.deleteAccount,
            position: SettingsCardPosition.bottom,
            trailing: SettingsActionButton(
              onPressed: handleDeleteAccount,
              child: Text(S.current.deleteBtn),
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

    final cardsSliver = SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
      sliver: SliverToBoxAdapter(child: cards),
    );
    final logoutSliver = SliverFillRemaining(
      hasScrollBody: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(theme.spacing.md, 0, theme.spacing.md, theme.spacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ButtonSecondary(
              key: K.logoutButton,
              onPressed: handleLogout,
              child: Text(
                S.current.logout,
                style: theme.textStyles.textMd.semibold.copyWith(
                  color: theme.palette.textErrorPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (asSliver) {
      return MultiSliver(children: [cardsSliver, logoutSliver]);
    }

    return CustomScrollView(slivers: [cardsSliver, logoutSliver]);
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
    required this.onResumePress,
  });

  final SubscriptionStore subscriptionStore;
  final AnalyticsStore analyticsStore;
  final SettingsCardPosition position;
  final bool isSubscribing;
  final bool isDesktop;
  final Future<void> Function({required bool manageSubscription}) onSubscribePress;
  final Future<void> Function() onResumePress;

  @override
  Widget build(BuildContext context) => Observer(
    builder: (_) {
      final subscription = subscriptionStore.subscriptionFuture.value;
      final isLoading = subscriptionStore.subscriptionFuture.status == FutureStatus.pending;
      final isSubscriptionActive = subscription?.active ?? false;
      final isSubscriptionInPauseState = isSubscriptionActive && (subscription?.paused ?? false);

      final planId = subscription?.planId;
      final planTitle = isSubscriptionActive && planId != null
          ? (Tr.byKeyOrNull(planId) ?? planId)
          : S.current.subscripton;

      late final String planSubtitle;
      String? badgeText;
      var badgeType = BadgeType.warning;

      // Active subscription can be recurring or cancelled
      if (isSubscriptionActive) {
        // subscription paused
        if (subscription?.paused ?? false) {
          planSubtitle = S.current.pausedUntil(
            subscription!.pausedUntil?.toLocal().formatWithDay() ?? '',
          );
          badgeText = S.current.paused;
          badgeType = BadgeType.warning;

          // subscription recurring
        } else if (subscription?.recurring ?? false) {
          planSubtitle = S.current.renewsOn(
            subscription!.activeUntil?.toLocal().formatWithDayMonthYear() ?? '',
          );
          // subscription cancelled
        } else {
          planSubtitle = S.current.accessUntil(
            subscription!.activeUntil?.toLocal().formatWithDayMonthYear() ?? '',
          );
          badgeText = S.current.cancelled;
          badgeType = BadgeType.error;
        }
        // Inactive subscription -> unsubscribed
      } else {
        planSubtitle = S.current.noActiveSubsDesc;
      }

      final spacing = Theme.of(context).spacing;

      Widget trailing;
      if (isLoading) {
        trailing = const LoadingIndicator();
      } else if (subscriptionStore.subscriptionFuture.status == FutureStatus.rejected) {
        trailing = SettingsActionButton(
          onPressed: subscriptionStore.refreshSubscription,
          child: Text(S.current.retryBtn),
        );
        // Paused Subscription
      } else if (isSubscriptionInPauseState) {
        final resumeButton = SettingsActionButton(
          onPressed: isSubscribing ? null : onResumePress,
          child: Text(S.current.resumeBtn),
        );
        final cancelButton = SettingsActionButton(
          onPressed: isSubscribing
              ? null
              : () async => showCancelSubscriptionDialog(context, entrypoint: 'account_paused'),
          child: Text(S.of(context).cancelBtn),
        );
        trailing = isDesktop
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  resumeButton,
                  SizedBox(width: spacing.md),
                  cancelButton,
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  resumeButton,
                  SizedBox(height: spacing.xs),
                  cancelButton,
                ],
              );
        // No subscription
      } else if (!isSubscriptionActive) {
        trailing = SettingsActionButton(
          onPressed: isSubscribing
              ? null
              : () {
                  analyticsStore.logEvent(AnalyticsEvent.clickSeeAllPlans);
                  onSubscribePress(manageSubscription: false);
                },
          child: isSubscribing ? const LoadingIndicator() : Text(S.current.pricingPlanSeePlansBtn),
        );
      } else {
        final getPlanButton = SettingsActionButton(
          onPressed: isSubscribing
              ? null
              : () {
                  analyticsStore.logEvent(AnalyticsEvent.clickSeeAllPlans);
                  if (isMobilePaymentGateway(subscription?.gateway)) {
                    ProviderScope.containerOf(
                      context,
                      listen: false,
                    ).read(homeTabsStorePOD).trySelect(HomeTab.products);
                  } else {
                    onSubscribePress(manageSubscription: false);
                  }
                },
          child: Text(S.current.getAPlanBtn),
        );
        final manageButton = SettingsActionButton(
          onPressed: isSubscribing
              ? null
              : () async {
                  analyticsStore.logEvent(AnalyticsEvent.manageSubscription);
                  await onSubscribePress(manageSubscription: true);
                },
          child: Text(S.current.settingManageBtn),
        );
        final cancelButton = SettingsActionButton(
          onPressed: isSubscribing
              ? null
              : () async => showCancelSubscriptionDialog(context, entrypoint: 'account'),
          child: Text(S.of(context).cancelBtn),
        );
        final isRecurring = subscription?.recurring ?? false;
        if (!isRecurring) {
          trailing = getPlanButton;
        } else {
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
      }

      return SettingsCard(
        title: planTitle,
        subtitle: planSubtitle,
        position: position,
        trailing: trailing,
        badgeText: badgeText,
        badgeType: badgeType,
      );
    },
  );
}
