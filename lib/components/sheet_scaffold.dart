import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/styles/style.dart';

class SheetScaffold extends StatefulWidget {
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
  State<SheetScaffold> createState() => _SheetScaffoldState();
}

class _SheetScaffoldState extends State<SheetScaffold> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final header = widget.header ?? PageHeader(headerTitle: widget.headerTitle);
    final sheetColor =
        widget.sheetColor ?? (context.c.isDarkMode ? Palette.darkBlue : Palette.white);
    final scaffoldColor =
        widget.scaffoldColor ?? (context.c.isDarkMode ? Palette.deepPurple : Palette.grayScaffold);

    return ColoredBox(
      color: scaffoldColor,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _ColoredScrollGapFiller(color: sheetColor, controller: _scrollController),
          ),
          CustomScrollView(
            controller: _scrollController,
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
              ?widget.subheaderSliver,
              // Content below the header
              DecoratedSliver(
                decoration: BoxDecoration(
                  color: sheetColor,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                ),
                sliver: SliverPadding(
                  padding: const EdgeInsets.only(top: 20),
                  sliver: widget.sliver,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ColoredScrollGapFiller extends StatefulWidget {
  const _ColoredScrollGapFiller({required this.color, required this.controller});

  final Color color;
  final ScrollController controller;

  @override
  State<_ColoredScrollGapFiller> createState() => _ColoredScrollGapFillerState();
}

class _ColoredScrollGapFillerState extends State<_ColoredScrollGapFiller> {
  double _offset = 0;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onScroll);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onScroll);
    super.dispose();
  }

  void _onScroll() {
    final controller = widget.controller;
    if (!controller.hasClients || controller.positions.isEmpty) {
      if (_offset != 0.0) {
        setState(() => _offset = 0.0);
      }
      return;
    }
    final position = controller.positions.first;
    final newOffset = max(0, position.pixels - position.maxScrollExtent).toDouble();
    if (newOffset != _offset) {
      setState(() => _offset = newOffset);
    }
  }

  @override
  Widget build(BuildContext context) =>
      Container(height: _offset + 4, width: double.infinity, color: widget.color);
}
