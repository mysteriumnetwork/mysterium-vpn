import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/features/auth/store/auth_store.dart';
import 'package:mysterium_vpn/features/auth/views/login_form.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class SignInView extends StatelessWidget {
  const SignInView({super.key});

  @override
  Widget build(BuildContext context) {
    final authStore = getIt<AuthStore>();

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
            LoadingBarrier(color: Theme.of(context).palette.bgPopover),
        ],
      ),
    );
  }
}
