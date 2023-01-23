import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/views/login_desktop_view.dart';
import 'package:mysterium_vpn/views/login_mobile_view.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredScaffold(body: LayoutBuilder(
      builder: (ctx, constaints) {
        return constaints.maxWidth > 650 ? const LoginDesktopView() : const LoginMobileView();
      },
    ));
  }
}
