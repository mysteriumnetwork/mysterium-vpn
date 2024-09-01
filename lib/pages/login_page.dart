import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/layout_builders/screen_type_builder.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/components/dialogs/confirmation_dialog.dart';
import 'package:mysterium_vpn/components/loading_barrier.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/pages/auth_page.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/auth_store.dart';
import 'package:mysterium_vpn/views/login/login_desktop_view.dart';
import 'package:mysterium_vpn/views/login/login_mobile_view.dart';
import 'package:styled_widget/styled_widget.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStore = ref.watch(authStorePOD);
    final analyticsStore = ref.watch(analyticsStorePOD);
    useEffect(
      () {
        _suggestLogin(context, authStore, analyticsStore);
        return null;
      },
      [],
    );

    return ColoredScaffold(
      body: Observer(
        builder: (context) => Stack(
          children: [
            ScreenTypeLayoutBuilder(
              mobile: (BuildContext context) => LoginMobileView(
                onSignInPressed: () => handleOnSignIn(context, authStore),
              ),
              tablet: (BuildContext context) => LoginDesktopView(
                onSignIn: () {
                  analyticsStore.logEvent(AnalyticsEvent.signInButton);
                  handleOnSignIn(context, authStore);
                },
                onReport: () =>
                    handleOnReportPage(context: context, intetcomStore: ref.read(intercomStorePOD)),
              ),
              desktop: (BuildContext context) => LoginDesktopView(
                onSignIn: () {
                  analyticsStore.logEvent(AnalyticsEvent.signInButton);
                  handleOnSignIn(context, authStore);
                },
                onReport: () =>
                    handleOnReportPage(context: context, intetcomStore: ref.read(intercomStorePOD)),
              ),
            ),
            if (authStore.authStatus == AuthStatus.authenticating)
              const LoadingBarrier(
                color: Palette.darkBlue,
              ),
          ],
        ),
      ),
    );
  }

  void _suggestLogin(BuildContext context, AuthStore authStore, AnalyticsStore analyticsStore) {
    if (authStore.temporaryEmail.isEmpty) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authStore.temporaryEmail != authStore.email) {
        authStore.email = authStore.temporaryEmail;
        handleOnSignIn(context, authStore);
      } else {
        analyticsStore.logEvent(AnalyticsEvent.loginPopup);
        _showConfirmationDialog(context, authStore, analyticsStore);
      }
      authStore.temporaryEmail = '';
    });
  }

  Future<void> _showConfirmationDialog(
    BuildContext context,
    AuthStore authStore,
    AnalyticsStore analyticsStore,
  ) async {
    shownConfirmationDialog(
      context,
      content: Text(
        authStore.email,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Palette.black,
        ),
        maxLines: 2,
        textAlign: TextAlign.center,
      ),
      title: LocaleKeys.isThisYou.tr(),
      onConfirm: () {
        analyticsStore.logEvent(AnalyticsEvent.loginPopupYes);
        handleOnSignIn(context, authStore);
      },
      onCancel: () {
        analyticsStore.logEvent(AnalyticsEvent.loginPopupNo);
      },
      icon: const Icon(
        Icons.info,
        color: Palette.black,
        size: 30,
      ),
    );
  }

  void handleOnSignIn(
    BuildContext context,
    AuthStore store,
  ) {
    if (isWindowsOrLinux()) {
      store.loginDesktop();
      return;
    }
    showBarModalBottomSheet(
      context: context,
      animationCurve: Curves.easeInOut,
      backgroundColor: Palette.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          controller: ModalScrollController.of(context),
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: const SignUpPage().height(getMediaHeight(context) * 0.85),
        ),
      ),
    );
  }
}
