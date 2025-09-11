import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/login/login_view.dart';
import 'package:mysterium_vpn/views/unauthenticated_page_view.dart';

class LoginPage extends HookConsumerWidget {
  const LoginPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authSessionStore = ref.watch(authSessionStorePOD);

    useReaction(
      () => authSessionStore.authShown,
      (authShown) {
        if (authShown) {
          return;
        }
        Future.microtask(() async {
          authSessionStore.authShown = true;
        });
      },
      fireImmediately: true,
    );

    return UnauthenticatedPageView(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: const SafeArea(
          child: SignInView(),
        ),
      ),
    );
  }
}
