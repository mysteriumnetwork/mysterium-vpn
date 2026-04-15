import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/auth/views/login_view.dart';
import 'package:mysterium_vpn/features/auth/views/unauthenticated_page_view.dart';
import 'package:mysterium_vpn/service_locator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _authSessionStore = getIt<AuthSessionStore>();
  late final ReactionDisposer _disposer;

  @override
  void initState() {
    super.initState();
    _disposer = reaction((_) => _authSessionStore.authShown, (authShown) {
      if (authShown) {
        return;
      }
      Future.microtask(() async {
        _authSessionStore.authShown = true;
      });
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    _disposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => UnauthenticatedPageView(
    child: Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: const SafeArea(child: SignInView()),
    ),
  );
}
