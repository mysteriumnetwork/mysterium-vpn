import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/page_header.dart';
import 'package:styled_widget/styled_widget.dart';

class BaseLayout extends StatelessWidget {
  const BaseLayout({required this.child, this.headerTitle = '', this.header, super.key});
  final Widget child;
  final String headerTitle;
  final Widget? header;
  @override
  Widget build(BuildContext context) => Column(
    children: [
      if (header != null) header! else PageHeader(headerTitle: headerTitle),
      child
          .decorated(
            color: Theme.of(context).primaryColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30),
              topRight: Radius.circular(30),
            ),
          )
          .padding(top: 20)
          .expanded(),
    ],
  );
}
