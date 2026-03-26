import 'dart:math';

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
    this.sheetColor,
    this.scaffoldColor,
    super.key,
  });

  final Widget sliver;
  final String headerTitle;
  final Widget? header;
  final Widget? subheaderSliver;
  final Color? sheetColor;
  final Color? scaffoldColor;

  @override
  Widget build(BuildContext context) {
    final scrollController = useScrollController();
    final header = this.header ?? PageHeader(headerTitle: headerTitle);
    final sheetColor = this.sheetColor ?? (context.c.isDarkMode ? Palette.darkBlue : Palette.white);
    final scaffoldColor =
        this.scaffoldColor ?? (context.c.isDarkMode ? Palette.deepPurple : Palette.grayScaffold);

    return ColoredBox(
      color: scaffoldColor,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _ColoredScrollGapFiller(color: sheetColor, controller: scrollController),
          ),
          CustomScrollView(
            controller: scrollController,
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
                backgroundColor: scaffoldColor,
                flexibleSpace: Container(color: scaffoldColor),
              ),
              ?subheaderSliver,
              // Content below the header
              DecoratedSliver(
                decoration: BoxDecoration(
                  color: sheetColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                sliver: SliverPadding(padding: const EdgeInsets.only(top: 20), sliver: sliver),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ColoredScrollGapFiller extends HookWidget {
  const _ColoredScrollGapFiller({required this.color, required this.controller});

  final Color color;
  final ScrollController controller;

  @override
  Widget build(BuildContext context) {
    final offset = useListenableSelector<double>(controller, () {
      if (!controller.hasClients || controller.positions.isEmpty) {
        return 0.0;
      }

      final position = controller.positions.first;
      return max(0, position.pixels - position.maxScrollExtent);
    });

    return Container(height: offset + 4, width: double.infinity, color: color);
  }
}
