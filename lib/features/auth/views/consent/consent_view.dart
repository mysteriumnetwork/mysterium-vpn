import 'package:flutter/material.dart';
import 'package:mysterium_vpn/shared/components/base_app_bar.dart';
import 'package:mysterium_vpn/shared/components/base_layout.dart';

class ConsentView extends StatelessWidget {
  const ConsentView({required this.child, super.key});
  final Widget child;
  @override
  Widget build(BuildContext context) => BaseLayout(
    header: const BaseAppBar(),
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: child,
    ),
  );
}
