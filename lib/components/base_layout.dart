import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/page_header.dart';
import 'package:styled_widget/styled_widget.dart';

class BaseLayout extends StatelessWidget {
  final Widget child;
  final String headerTitle;
  const BaseLayout({super.key, required this.child, required this.headerTitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PageHeader(headerTitle: headerTitle).padding(bottom: 40),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          ),
          child: child,
        ).expanded(),
      ],
    );
  }
}
