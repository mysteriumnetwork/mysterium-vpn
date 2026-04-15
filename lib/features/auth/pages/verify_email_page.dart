import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/auth/views/unauthenticated_page_view.dart';
import 'package:mysterium_vpn/features/auth/views/verify_email_view.dart';

class VerifyEmailPage extends StatelessWidget {
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenType = getScreenType(MediaQuery.sizeOf(context));
    final viewDecoration = screenType >= ScreenType.desktop
        ? const BoxDecoration()
        : BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          );

    return UnauthenticatedPageView(
      child: Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: SafeArea(
          child: Column(
            children: [
              const UnauthenticatedHeader(),
              Expanded(
                child: DecoratedBox(decoration: viewDecoration, child: const VerifyEmailView()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
