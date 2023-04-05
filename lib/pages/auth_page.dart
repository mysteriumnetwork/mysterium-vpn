import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/routes.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/router/router.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) => Beamer(
        routerDelegate: BeamerDelegate(
          initialPath: Routes.signIn.toRoute,
          initializeFromParent: false,
          updateFromParent: false,
          updateParent: false,
          locationBuilder: (routeInformation, _) => AuthBeamerLocations(routeInformation),
        ),
      );
}
