import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/layout_builders/screen_type_builder.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/components/dialogs/confirmation_dialog.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/auth_store.dart';
import 'package:mysterium_vpn/views/login/login_desktop_view.dart';
import 'package:mysterium_vpn/views/login/login_mobile_view.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStore = ref.watch(authStorePOD);
    useEffect(
      () {
        _suggestLogin(context, authStore);
        return null;
      },
      [],
    );

    return ColoredScaffold(
      body: ScreenTypeLayoutBuilder(
        mobile: (BuildContext context) => const LoginMobileView(),
        tablet: (BuildContext context) => const LoginDesktopView(),
        desktop: (BuildContext context) => const LoginDesktopView(),
      ),
    );
  }

  void _suggestLogin(BuildContext context, AuthStore authStore) {
    if (authStore.temporaryEmail.isEmpty) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authStore.temporaryEmail != authStore.email) {
        authStore.email = authStore.temporaryEmail;
        handleOnSignIn(context, authStore);
      } else {
        _showConfirmationDialog(context, authStore);
      }
      authStore.temporaryEmail = '';
    });
  }

  Future<void> _showConfirmationDialog(BuildContext context, AuthStore authStore) =>
      shownConfirmationDialog(
        context,
        content: Text(
          authStore.email,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
        title: LocaleKeys.isThisYou.tr(),
        onConfirm: () => handleOnSignIn(context, authStore),
        icon: const Icon(
          Icons.info,
          color: Palette.black,
          size: 30,
        ),
      );
}
