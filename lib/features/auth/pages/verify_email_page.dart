import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/features/auth/views/unauthenticated_page_view.dart';
import 'package:mysterium_vpn/features/auth/views/verify_email_view.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    return UnauthenticatedPageView(
      child: ColoredScaffold(
        backgroundColor: palette.bgSidePanel,
        body: const SafeArea(
          child: Column(
            children: [
              UnauthenticatedHeader(),
              Expanded(child: VerifyEmailView()),
            ],
          ),
        ),
      ),
    );
  }
}
