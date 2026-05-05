import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn_design/widgets/loading_indicator.dart';

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) => const ColoredScaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [Brand(height: 72), SizedBox(height: 12), LoadingIndicator()],
      ),
    ),
  );
}
