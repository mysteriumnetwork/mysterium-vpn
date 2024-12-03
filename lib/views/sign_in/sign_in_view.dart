import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/components/app_logo.dart';
import 'package:mysterium_vpn/components/loading_barrier.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/sign_in/sign_in_form.dart';
import 'package:styled_widget/styled_widget.dart';

class SignInView extends ConsumerWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStore = ref.watch(authStorePOD);
    return Observer(
      builder: (context) => Stack(
        children: [
          Column(
            children: [
              const AppLogo().padding(top: 40, bottom: 30),
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
          if (authStore.signInFeatureFeature.status == FutureStatus.pending)
            LoadingBarrier(color: Theme.of(context).primaryColor),
        ],
      ),
    );
  }
}
