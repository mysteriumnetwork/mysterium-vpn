import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/layout_builders/screen_type_builder.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/views/login/login_desktop_view.dart';
import 'package:mysterium_vpn/views/login/login_mobile_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredScaffold(
      body: ScreenTypeLayoutBuilder(
        mobile: (BuildContext context) => const LoginMobileView(),
        tablet: (BuildContext context) => const LoginDesktopView(),
        desktop: (BuildContext context) => const LoginDesktopView(),
      ),
    );
  }
}
