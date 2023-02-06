import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/layout_builders/screen_type_builder.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/views/home/home_desktop_view.dart';
import 'package:mysterium_vpn/views/home/home_mobile_view.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredScaffold(
      body: ScreenTypeLayoutBuilder(
        mobile: (BuildContext context) => const HomeMobileView(),
        tablet: (BuildContext context) => const HomeDesktopView(),
        desktop: (BuildContext context) => const HomeDesktopView(),
      ),
    );
  }
}
