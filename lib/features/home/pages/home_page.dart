import 'dart:async';

import 'package:beamer/beamer.dart';
import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/exceptions/exceptions.dart';
import 'package:mysterium_vpn/core/extensions/navigation_extensions.dart';
import 'package:mysterium_vpn/core/layout_builders/screen_type_builder.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/home/views/home_desktop_view.dart';
import 'package:mysterium_vpn/features/home/views/home_mobile_view.dart';
import 'package:mysterium_vpn/features/home/views/home_state.dart';
import 'package:mysterium_vpn/features/notifications/store/push_notifications_store.dart';
import 'package:mysterium_vpn/features/settings/store/user_preferences_store.dart';
import 'package:mysterium_vpn/features/subscription/pages/subscription_upgrade_modal_page.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_store.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn/services/services.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _authSessionStore = getIt<AuthSessionStore>();
  late final HomeState _homeState;

  StreamController<Future<Object?> Function()>? _dialogController;
  StreamSubscription<Object?>? _dialogSubscription;
  final List<ReactionDisposer> _homeDisposers = [];

  @override
  void initState() {
    super.initState();
    _homeState = HomeState(SharedPreferenceService.instance, getIt());
    InAppReviewObserver().monitor();
    _setupHomeAutorun();
  }

  void _setupHomeAutorun() {
    _dialogController = StreamController<Future<Object?> Function()>(sync: true);
    _dialogSubscription = _dialogController!.stream
        .asyncMap((it) async {
          await Future.microtask(() {});
          return it();
        })
        .listen((_) {});

    final vpnStore = getIt<VpnStore>();
    final authSessionStore = getIt<AuthSessionStore>();
    final userPreferencesStore = getIt<UserPreferencesStore>();
    final pushNotificationsStore = getIt<PushNotificationsStore>();

    _homeDisposers.addAll([
      autorun((_) {
        if (!authSessionStore.isAuthenticated) {
          return;
        }
        final value = userPreferencesStore.nextPromptToShow;
        if (value == UserPromptType.none) {
          return;
        }
        if (!userPreferencesStore.isPromptShown(value)) {
          userPreferencesStore.markPromptAsShown(value);
          if (value case UserPromptType.marketingConsent) {
            _dialogController!.add(() => showMarketingConsentDialog(context));
          } else if (value case UserPromptType.pushNotifications) {
            _dialogController!.add(() => showPushNotificationsPermissionDialog(context));
          }
        }
      }),
      autorun((_) {
        final error = vpnStore.fetchConfigFuture?.error;
        if (error is DeviceLimitReachedException && !vpnStore.isDeviceLimitErrorShown) {
          vpnStore.markDeviceLimitErrorAsShown();
          _dialogController!.add(() => showDeviceLimitDialog(context));
        }
      }),
      autorun((_) {
        final notification = pushNotificationsStore.lastNotification;
        if (notification?.id == pushNotificationsStore.lastShownPushNotificationId) {
          return;
        }
        pushNotificationsStore.lastShownPushNotificationId = notification?.id;
        if (notification?.additionalData != null) {
          if (notification!.additionalData!.containsKey('redirect_url')) {
            final redirectUrl = notification.additionalData!['redirect_url'];
            if (redirectUrl is! String || redirectUrl.isEmpty) {
              return;
            }
            Beamer.of(context).navigateToUrl(
              url: redirectUrl,
              context: context,
              isAuthenticated: authSessionStore.isAuthenticated,
              accessToken: authSessionStore.accessToken,
            );
          } else if (notification.additionalData!.containsKey('coupon_code')) {
            final couponCode = notification.additionalData!['coupon_code'];
            if (couponCode is! String || couponCode.isEmpty) {
              return;
            }
            if (!authSessionStore.isAuthenticated) {
              return;
            }
            FlutterClipboard.copy(couponCode).then((_) {
              showSnackbar(
                LocaleKeys.couponCodeCopied.tr(namedArgs: {'couponCode': '"$couponCode"'}),
                type: MessageType.success,
              );
              if (mounted) {
                showSubscriptionUpgradeModalPage(context);
              }
            });
          }
        }
      }),
    ]);
  }

  @override
  void dispose() {
    for (final d in _homeDisposers) {
      d();
    }
    _dialogSubscription?.cancel();
    _dialogController?.close();
    _homeState.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => HomeStateScope(
    notifier: _homeState,
    child: Theme(
      data: DesignSystemTheme.of(context),
      child: ColoredScaffold(
        extendBodyBehindAppBar: true,
        body: Observer(
          builder: (context) {
            final isLoading = _authSessionStore.status == AuthStatus.unknown;
            return Stack(
              children: [
                ScreenTypeLayoutBuilder(
                  mobile: (BuildContext context) => const HomeMobileView(),
                  tablet: (BuildContext context) => const HomeDesktopView(),
                  desktop: (BuildContext context) => const HomeDesktopView(),
                ),
                if (isLoading)
                  Positioned.fill(child: LoadingBarrier(color: Theme.of(context).primaryColor)),
              ],
            );
          },
        ),
      ),
    ),
  );
}
