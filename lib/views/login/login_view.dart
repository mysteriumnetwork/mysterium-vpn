import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/components/loading_barrier.dart';
import 'package:mysterium_vpn/components/unauthenticated_header.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/auth/auth_status.dart';
import 'package:mysterium_vpn/views/login/login_form.dart';
import 'package:styled_widget/styled_widget.dart';

class SignInView extends ConsumerWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authSessionStore = ref.read(authSessionStorePOD);
    return Observer(
      builder: (context) => Stack(
        children: [
          Column(
            children: [
              const UnauthenticatedHeader().padding(horizontal: 30, top: 30, bottom: 40),
              const SignInForm()
                  .decorated(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  )
                  .expanded(),
            ],
          ),
          if (authSessionStore.status == AuthStatus.authenticating)
            LoadingBarrier(color: Theme.of(context).primaryColor),
        ],
      ),
    );
  }
}
