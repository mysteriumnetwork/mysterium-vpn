import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/views/sign_in/sign_in_view.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: const SafeArea(
          child: SignInView(),
        ),
      );
}
