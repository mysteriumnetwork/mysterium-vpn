import 'package:flutter/material.dart';
import 'package:mysterium_vpn/pages/static/ft_checkers/min_app_version_checker.dart';
import 'package:mysterium_vpn/pages/static/ft_checkers/service_availability_checker.dart';
import 'package:mysterium_vpn/pages/static/ft_checkers/terms_conditions_checker.dart';

class FTCheckers extends StatelessWidget {
  const FTCheckers({required this.child, super.key});

  final Widget child;
  @override
  // Terms sit innermost: maintenance and a forced update outrank them, and the
  // accept call would fail anyway while the service is down.
  Widget build(BuildContext context) => ServiceAvailabilityChecker(
    child: MinAppVersionChecker(child: TermsConditionsChecker(child: child)),
  );
}
