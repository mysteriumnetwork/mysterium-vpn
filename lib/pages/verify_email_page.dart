import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/views/unauthenticated_page_view.dart';
import 'package:mysterium_vpn/views/verify_email_view.dart';
import 'package:mysterium_vpn_design/styles/styles.dart';

class VerifyEmailPage extends HookConsumerWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return UnauthenticatedPageView(
      child: ColoredScaffold(
        backgroundColor: theme.palette.bgSidePanel,

        body: const SafeArea(
          child: Column(
            children: [
              UnauthenticatedHeader(backHeader: true),
              Expanded(child: VerifyEmailView()),
            ],
          ),
        ),
      ),
    );
  }
}
