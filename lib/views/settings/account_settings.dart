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
import 'package:mysterium_vpn/common/hooks/screen_type_hook.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/dialogs/confirmation_dialog.dart';
import 'package:mysterium_vpn/components/dialogs/delete_account_dialog.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide LoadingIndicator, ScreenType;

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
    final screenType = useScreenType();
    final isDesktop = screenType != ScreenType.mobile;

    void handleSignIn() => context.beamToNamed(Routes.platformLogin.path);

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: theme.palette.bgSecondarySelected,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Icon(UntitledUI.user_02, size: 24, color: theme.palette.textBrandPrimary),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          LocaleKeys.unauthenticatedSettingTitle.tr(),
          style: theme.textStyles.textLg.semibold.copyWith(color: theme.palette.textPrimary),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 343),
          child: Text(
            LocaleKeys.unauthenticatedSettingSubtitle.tr(),
            style: theme.textStyles.textSm.regular.copyWith(color: theme.palette.textSecondary),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: theme.spacing.xl3),
        SizedBox(
          width: isDesktop ? null : double.infinity,
          child: ButtonPrimary(onPressed: handleSignIn, child: Text(LocaleKeys.signIn.tr())),
        ),
      ],
    );

    return Padding(
      padding: EdgeInsets.only(top: isDesktop ? 80 : 60, bottom: theme.spacing.xl3),
      child: Center(child: content),
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

    final screenType = useScreenType();
    final handleSubscribe = useHandleSubscribe();
    final (notifier, subscribeStatus) = useFutureStatus();

    final isDesktop = screenType != ScreenType.mobile;
    final theme = Theme.of(context);
    final spacing = theme.spacing;

    useValueChanged<AsyncSnapshot<void>, void>(subscribeStatus, (_, _) {
      if (subscribeStatus.hasError) {
        showSnackbar(LocaleKeys.somethingWentWrong.tr());
      }
    });

    void handleLogout() {
      analyticsStore.logEvent(AnalyticsEvent.logOutPopup);
      shownConfirmationDialog(
        context,
        confirmText: LocaleKeys.confirm.tr(),
        cancelText: LocaleKeys.cancelBtn.tr(),
        icon: SvgIcon(asset: Asset.icons.warning),
        title: LocaleKeys.logoutConfirmationTitle.tr(),
        content: Text(
          vpnStore.isConnected
              ? LocaleKeys.logoutVPNConnectedDesc.tr()
              : LocaleKeys.logoutConfirmationDesc.tr(),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          maxLines: 5,
          textAlign: TextAlign.center,
        ),
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
              ? ButtonTertiary(
                  decoration: ButtonDecoration(
                    minimumSize: Size.zero,
                    padding: EdgeInsets.symmetric(horizontal: spacing.xs, vertical: spacing.xxs),
                  ),
                  size: ButtonSize.small,
                  onPressed: handleLogout,
                  child: Text(LocaleKeys.logout.tr()),
                )
              : null,
        ),
        _SubscriptionCard(
          subscriptionStore: subscriptionStore,
          analyticsStore: analyticsStore,
          position: showDeleteAccount ? SettingsCardPosition.middle : SettingsCardPosition.bottom,
          isSubscribing: subscribeStatus.isLoading,
          onSubscribePress: onSubscribePress,
        ),
        if (showDeleteAccount)
          SettingsCard(
            title: LocaleKeys.deleteAccount.tr(),
            position: SettingsCardPosition.bottom,
            trailing: ButtonTertiary(
              decoration: ButtonDecoration(
                minimumSize: Size.zero,
                padding: EdgeInsets.symmetric(horizontal: spacing.xs, vertical: spacing.xxs),
              ),
              size: ButtonSize.small,
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
    required this.onSubscribePress,
  });

  final SubscriptionStore subscriptionStore;
  final AnalyticsStore analyticsStore;
  final SettingsCardPosition position;
  final bool isSubscribing;
  final Future<void> Function({required bool manageSubscription}) onSubscribePress;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.spacing;

    return Observer(
      builder: (_) {
        final subscription = subscriptionStore.subscriptionFuture.value;
        final isLoading = subscriptionStore.subscriptionFuture.status == FutureStatus.pending;
        final isSubscriptionActive = subscription?.active ?? false;

        Widget trailing;
        if (isLoading) {
          trailing = const LoadingIndicator();
        } else if (subscriptionStore.subscriptionFuture.status == FutureStatus.rejected) {
          trailing = ButtonTertiary(
            decoration: ButtonDecoration(
              minimumSize: Size.zero,
              padding: EdgeInsets.symmetric(horizontal: spacing.xs, vertical: spacing.xxs),
            ),
            size: ButtonSize.small,
            onPressed: subscriptionStore.refreshSubscription,
            child: Text(LocaleKeys.retryBtn.tr()),
          );
        } else if (!isSubscriptionActive) {
          trailing = ButtonTertiary(
            decoration: ButtonDecoration(
              minimumSize: Size.zero,
              padding: EdgeInsets.symmetric(horizontal: spacing.xs, vertical: spacing.xxs),
            ),
            size: ButtonSize.small,
            onPressed: isSubscribing ? null : () => onSubscribePress(manageSubscription: false),
            child: isSubscribing
                ? const LoadingIndicator()
                : Text(LocaleKeys.pricingPlanSeePlansBtn.tr()),
          );
        } else {
          trailing = Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              ButtonTertiary(
                decoration: ButtonDecoration(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.symmetric(horizontal: spacing.xs, vertical: spacing.xxs),
                ),
                size: ButtonSize.small,
                onPressed: isSubscribing
                    ? null
                    : () async {
                        analyticsStore.logEvent(AnalyticsEvent.manageSubscription);
                        await onSubscribePress(manageSubscription: true);
                      },
                child: Text(LocaleKeys.settingManageBtn.tr()),
              ),
              SizedBox(height: spacing.xs),
              ButtonTertiary(
                decoration: ButtonDecoration(
                  minimumSize: Size.zero,
                  padding: EdgeInsets.symmetric(horizontal: spacing.xs, vertical: spacing.xxs),
                ),
                size: ButtonSize.small,
                onPressed: isSubscribing ? null : () => onSubscribePress(manageSubscription: true),
                child: Text(LocaleKeys.cancelBtn.tr()),
              ),
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
            : null;

        return SettingsCard(
          title: planTitle,
          subtitle: planSubtitle,
          position: position,
          trailing: trailing,
        );
      },
    );
  }
}
