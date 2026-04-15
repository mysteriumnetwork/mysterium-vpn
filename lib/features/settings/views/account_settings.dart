import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/exceptions/exceptions.dart';
import 'package:mysterium_vpn/core/extensions/asset.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/features/settings/views/action_button.dart';
import 'package:mysterium_vpn/features/settings/views/purchased_plan.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_purchase_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_store.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_store.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/service_locator.dart';

class AccountSettings extends StatelessWidget {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final authSessionStore = getIt<AuthSessionStore>();

    return Observer(
      builder: (_) {
        final authStatus = authSessionStore.status;

        return switch (authStatus) {
          AuthStatus.authenticated => const _Authenticated(),
          AuthStatus.unauthenticated => const _Unauthenticated(),
          _ => const SizedBox.shrink(),
        };
      },
    );
  }
}

class _Unauthenticated extends StatelessWidget {
  const _Unauthenticated();

  @override
  Widget build(BuildContext context) {
    void handleSignIn() {
      context.beamToNamed(Routes.platformLogin.path);
    }

    return SettingItem(
      asset: Asset.icons.accountName(context),
      title: LocaleKeys.accountSignInTitle.tr(),
      actionWidget: EasyButton(text: LocaleKeys.accountSignIn.tr(), onPressed: handleSignIn),
    );
  }
}

class _Authenticated extends StatelessWidget {
  const _Authenticated();

  @override
  Widget build(BuildContext context) {
    final subscriptionStore = getIt<SubscriptionStore>();
    final authStore = getIt<AuthStore>();
    final authSessionStore = getIt<AuthSessionStore>();
    final analyticsStore = getIt<AnalyticsStore>();
    final remoteConfigStore = getIt<RemoteConfigStore>();
    final vpnStore = getIt<VpnStore>();
    return Observer(
      builder: (ctx) {
        final subscription = subscriptionStore.subscriptionFuture.value;
        final isLoading = subscriptionStore.subscriptionFuture.status == FutureStatus.pending;
        return Column(
          children: [
            SettingItem(
              asset: Asset.icons.billing(context),
              title: LocaleKeys.myBillingPackage.tr(),
              description: subscription != null && subscription.active
                  ? PurchasedPlan(subscription: subscription)
                  : null,
              actionWidget: _BillingActionWidget(
                subscription: subscription,
                isLoading: isLoading,
                subscriptionStore: subscriptionStore,
                analyticsStore: analyticsStore,
              ),
            ),
            SettingItem(
              asset: Asset.icons.accountName(context),
              title: authSessionStore.user?.username ?? '',
              actionWidget: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 250),
                child: SizedBox(
                  width: double.infinity,
                  child: SettingActionButton(
                    child: EasyText(LocaleKeys.logout.tr(), color: Palette.white),
                    action: () {
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
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Palette.black,
                          ),
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
                    },
                  ),
                ),
              ),
            ),
            if (!remoteConfigStore.hideDeleteAccount)
              SettingItem(
                asset: Asset.icons.deleteAccount(context),
                title: LocaleKeys.cancelMyAccount.tr(),
                actionWidget: SettingActionButton(
                  child: EasyText(LocaleKeys.deleteAccount.tr(), color: Palette.white),
                  action: () {
                    analyticsStore.logEvent(AnalyticsEvent.deleteAccount);
                    shownDeleteAccountDialog(
                      context,
                      authStore: authStore,
                      analyticsStore: analyticsStore,
                      vpnStore: vpnStore,
                    );
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}

class _BillingActionWidget extends StatefulWidget {
  const _BillingActionWidget({
    required this.subscription,
    required this.isLoading,
    required this.subscriptionStore,
    required this.analyticsStore,
  });

  final Subscription? subscription;
  final bool isLoading;
  final SubscriptionStore subscriptionStore;
  final AnalyticsStore analyticsStore;

  @override
  State<_BillingActionWidget> createState() => _BillingActionWidgetState();
}

class _BillingActionWidgetState extends State<_BillingActionWidget> {
  AsyncSnapshot<void> _subscribeStatus = const AsyncSnapshot.nothing();

  void _updateSubscribeStatus(AsyncSnapshot<void> newStatus) {
    if (!mounted) {
      return;
    }
    final oldStatus = _subscribeStatus;
    setState(() => _subscribeStatus = newStatus);
    if (newStatus.hasError && !oldStatus.hasError) {
      showSnackbar(LocaleKeys.somethingWentWrong.tr());
    }
  }

  Future<void> _runSubscribe(Future<void> Function() fn) async {
    final future = fn();
    setState(() {
      _subscribeStatus = const AsyncSnapshot.waiting();
    });
    try {
      await future;
      _updateSubscribeStatus(const AsyncSnapshot.withData(ConnectionState.done, null));
    } catch (e, st) {
      _updateSubscribeStatus(AsyncSnapshot.withError(ConnectionState.done, e, st));
    }
  }

  Future<void> _onSubscribePress() async {
    await _runSubscribe(
      () => _handleSubscribe(context, manageSubscription: widget.subscription?.active ?? false),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const LoadingIndicator();
    }

    if (widget.subscriptionStore.subscriptionFuture.status == FutureStatus.rejected) {
      return SettingActionButton(
        action: widget.subscriptionStore.refreshSubscription,
        child: EasyText(LocaleKeys.retryBtn.tr(), color: Palette.white),
      );
    }

    if (widget.subscription == null || !widget.subscription!.active) {
      return SettingActionButton(
        action: _subscribeStatus.isLoading ? null : _onSubscribePress,
        child: _subscribeStatus.isLoading
            ? const LoadingIndicator()
            : EasyText(LocaleKeys.pricingPlanSeePlansBtn.tr(), color: Palette.white),
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 250),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        spacing: 16,
        children: [
          SettingActionButton(
            backgroundColor: Palette.purple,
            action: () async {
              widget.analyticsStore.logEvent(AnalyticsEvent.manageSubscription);
              await _onSubscribePress();
            },
            child: EasyText(LocaleKeys.goToBillingPage.tr(), color: Palette.white),
          ),
          SettingActionButton(
            action: () async {
              final shouldProceed = await showCancelSubscriptionSurveyDialog(context);
              if (shouldProceed ?? false) {
                await _onSubscribePress();
              }
            },
            child: EasyText(LocaleKeys.cancelSubscriptionBtn.tr(), color: Palette.white),
          ),
        ],
      ),
    );
  }
}

Future<void> _handleSubscribe(BuildContext context, {bool manageSubscription = false}) async {
  final sessionStore = getIt<AuthSessionStore>();
  final subscriptionStore = getIt<SubscriptionStore>();
  final subscriptionPurchaseStore = getIt<SubscriptionPurchaseStore>();
  final remoteConfigStore = getIt<RemoteConfigStore>();

  final accessToken = sessionStore.accessToken;

  try {
    final subscription = await subscriptionStore.subscriptionFuture;
    if (!context.mounted) {
      return;
    }
    await handleOnBillingPage(
      context: context,
      manageSubscriptionPage: remoteConfigStore.manageSubscriptionPage,
      upgradeSubscriptionPage: remoteConfigStore.upgradeSubscriptionPage,
      gateway: subscription.gateway,
      subscriptionActive: subscription.active,
      accessToken: accessToken,
      onManageSubscription: subscriptionPurchaseStore.manageSubscription,
      manageSubscription: manageSubscription,
    );
  } on SubscriptionRequiredException catch (_) {
    // ignore and let the flow continue
  }
}

extension _AsyncSnapshotExtension<T> on AsyncSnapshot<T> {
  bool get isLoading => connectionState == ConnectionState.waiting;
}
