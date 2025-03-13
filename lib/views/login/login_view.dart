import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/loading_barrier.dart';
import 'package:mysterium_vpn/components/unauthenticated_header.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/login/login_form.dart';
import 'package:styled_widget/styled_widget.dart';

class SignInView extends ConsumerWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStore = ref.read(authStorePOD);
    final size = Size(getMediaWidth(context), getMediaHeight(context));
    return Observer(
      builder: (context) => Stack(
        children: [
          Column(
            children: [
              const UnauthenticatedHeader().padding(
                horizontal: size.width * 0.05,
                top: size.height * 0.02,
                bottom: size.height * 0.03,
              ),
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
          if (authStore.authenticateFeature?.status == FutureStatus.pending)
            LoadingBarrier(color: Theme.of(context).primaryColor),
        ],
      ),
    );
  }
}
