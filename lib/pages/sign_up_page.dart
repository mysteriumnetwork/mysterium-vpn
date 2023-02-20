import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/enum.dart';
import 'package:mysterium_vpn/common/router/router.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Beamer(
      routerDelegate: BeamerDelegate(
        initialPath: Routes.signUp.toRoute,
        initializeFromParent: false,
        updateFromParent: false,
        updateParent: false,
        locationBuilder: (routeInformation, _) => SignUpBeamerLocations(routeInformation),
      ),
    );
  }
}
