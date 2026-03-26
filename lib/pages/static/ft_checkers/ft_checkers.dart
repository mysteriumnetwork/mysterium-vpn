import 'package:flutter/material.dart';
import 'package:mysterium_vpn/pages/static/ft_checkers/min_app_version_checker.dart';
import 'package:mysterium_vpn/pages/static/ft_checkers/service_availability_checker.dart';

class FTCheckers extends StatelessWidget {
  const FTCheckers({required this.child, super.key});

  final Widget child;
  @override
  Widget build(BuildContext context) =>
      ServiceAvailabilityChecker(child: MinAppVersionChecker(child: child));
}
