import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/components/unauthenticated_header.dart';
import 'package:mysterium_vpn/views/unauthenticated_page_view.dart';
import 'package:mysterium_vpn/views/verify_email_view.dart';
import 'package:mysterium_vpn_design/styles/styles.dart';

class VerifyEmailPage extends HookConsumerWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final designTheme = DesignSystemTheme.of(context);

    return Theme(
      data: designTheme,
      child: UnauthenticatedPageView(
        child: ColoredScaffold(
          backgroundColor: designTheme.palette.bgSidePanel,

          body: const SafeArea(
            child: Column(
              children: [
                UnauthenticatedHeader(backHeader: true),
                Expanded(child: VerifyEmailView()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
