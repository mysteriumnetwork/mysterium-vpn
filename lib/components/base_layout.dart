import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/page_header.dart';
import 'package:styled_widget/styled_widget.dart';

class BaseLayout extends StatelessWidget {
  const BaseLayout({
    required this.child,
    required this.headerTitle,
    super.key,
  });
  final Widget child;
  final String headerTitle;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          PageHeader(headerTitle: headerTitle).padding(bottom: 40),
          DecoratedBox(
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
