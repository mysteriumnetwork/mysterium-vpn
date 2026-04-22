import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/components/loading_barrier.dart';
import 'package:mysterium_vpn/components/unauthenticated_header.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/login/login_form.dart';

class SignInView extends HookConsumerWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStore = ref.read(authStorePOD);

    return Observer(
      builder: (context) => Stack(
        children: [
          const Column(
            children: [
              UnauthenticatedHeader(),
              Expanded(child: SignInForm()),
            ],
          ),
          if (authStore.authenticateFeature?.status == FutureStatus.pending)
            LoadingBarrier(color: Theme.of(context).primaryColor),
        ],
      ),
    );
  }
}
