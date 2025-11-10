import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/page_header.dart';

class SheetScaffold extends HookWidget {
  const SheetScaffold({
    required this.sliver,
    this.headerTitle = '',
    this.header,
    this.subheaderSliver,
    super.key,
  });

  final Widget sliver;
  final String headerTitle;
  final Widget? header;
  final Widget? subheaderSliver;

  @override
  Widget build(BuildContext context) {
    final header = this.header ?? PageHeader(headerTitle: headerTitle);

    return CustomScrollView(
      slivers: [
        // Sticky header with background
        SliverAppBar(
          titleSpacing: 0,
          automaticallyImplyLeading: false,
          stretch: true,
          pinned: true,
          title: header,
          expandedHeight: 80,
          collapsedHeight: 60,
          backgroundColor: context.c.isDarkMode ? Palette.deepPurple : Palette.grayScaffold,
          flexibleSpace: Container(
            color: context.c.isDarkMode ? Palette.deepPurple : Palette.grayScaffold,
          ),
        ),
        if (subheaderSliver != null) subheaderSliver!,
        // Content below the header
        SliverToBoxAdapter(
          child: Container(
            color: context.c.isDarkMode ? Palette.deepPurple : Palette.grayScaffold,
            height: 20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Container(
                  height: 20,
                  decoration: BoxDecoration(
                    color: context.c.isDarkMode ? Palette.darkBlue : Palette.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        sliver,
      ],
    );
  }
}
