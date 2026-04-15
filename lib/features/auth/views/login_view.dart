import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/auth/store/auth_store.dart';
import 'package:mysterium_vpn/features/auth/views/login_form.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn/shared/components/loading_barrier.dart';
import 'package:mysterium_vpn/shared/components/unauthenticated_header.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final authStore = getIt<AuthStore>();
    final screenType = getScreenType(MediaQuery.sizeOf(context));
    final formDecoration = screenType >= ScreenType.desktop
        ? const BoxDecoration()
        : BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          );

    return Observer(
      builder: (context) => Stack(
        children: [
          Column(
            children: [
              const UnauthenticatedHeader(),
              Expanded(
                child: DecoratedBox(decoration: formDecoration, child: const SignInForm()),
              ),
            ],
          ),
          if (authStore.authenticateFeature?.status == FutureStatus.pending)
            LoadingBarrier(color: Theme.of(context).primaryColor),
        ],
      ),
    );
  }
}
