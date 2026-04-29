import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/login/login_view.dart';
import 'package:mysterium_vpn_design/styles/styles.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authSessionStore = ref.read(authSessionStorePOD);
    final theme = Theme.of(context);
    useReaction(() => authSessionStore.authShown, (authShown) {
      if (authShown) {
        return;
      }
      Future.microtask(() async {
        authSessionStore.authShown = true;
      });
    }, fireImmediately: true);

    return ColoredScaffold(
      backgroundColor: theme.palette.bgSidePanel,
      body: const SafeArea(child: SignInView()),
    );
  }
}
