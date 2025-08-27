import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/hooks/responsive_value_hook.dart';
import 'package:mysterium_vpn/components/unauthenticated_header.dart';
import 'package:mysterium_vpn/views/unauthenticated_page_view.dart';
import 'package:mysterium_vpn/views/verify_email_view.dart';

class VerifyEmailPage extends HookConsumerWidget {
  const VerifyEmailPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final viewDecoration = useResponsiveValue(
      BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      desktop: const BoxDecoration(),
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
