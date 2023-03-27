import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/routes.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/router/router.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class SignUpPage extends ConsumerWidget {
  const SignUpPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Beamer(
        routerDelegate: BeamerDelegate(
          initialPath: ref.read(isSignedInPOD) ? Routes.signIn.toRoute : Routes.signUp.toRoute,
          initializeFromParent: false,
          updateFromParent: false,
          updateParent: false,
          locationBuilder: (routeInformation, _) => AuthBeamerLocations(routeInformation),
        ),
      );
}
