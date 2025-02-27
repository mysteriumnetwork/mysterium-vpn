import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class _HomeState extends ChangeNotifier {
  _HomeState();

  final typeSwitcherKey = GlobalKey();

  PanelState get _panelState => PanelState.fromPosition(_panelController?.panelPosition ?? 0.0);

  PanelController? _panelController;
  ScrollController? _scrollController;
  double _scrollOffset = 0;

  bool get isDraggable => isMobile();

  bool get isPadded => isMobile();

  PanelController? get panelController => _panelController;
  set panelController(PanelController? value) {
    if (_panelController == value) {
      return;
    }
    _panelController = value;
    Future.microtask(() => _setPanelState(PanelState.snap));
  }

  ScrollController? get scrollController => _scrollController;

  set scrollController(ScrollController? value) {
    _scrollController?.removeListener(_scrollListener);
    _scrollController = value?..addListener(_scrollListener);
  }

  Future<void> _setPanelState(PanelState state) async {
    await switch (state) {
      PanelState.closed => _panelController?.close(),
      PanelState.snap => _panelController?.animatePanelToSnapPoint(),
      PanelState.open => _panelController?.open(),
    };
    notifyListeners();
  }

  Future<void> togglePanel() async {
    final next = _panelState.next(circular: true);
    if (next != null) {
      await _setPanelState(next);
    }
  }

  Future<void> scrollTo(GlobalKey key) async {
    final context = key.currentContext;
    if (context == null) {
      return;
    }

    final box = context.findRenderObject();
    if (box is! RenderBox) {
      return;
    }

    if (scrollController == null) {
      return;
    }
    final offset = box.localToGlobal(Offset.zero).dy;
    final height = box.size.height;

    final target = (offset - height) * _panelState.extent;
    final scrollPosition = scrollController!.position;

    await scrollPosition.moveTo(target);
  }

  Future<void> show(GlobalKey key) async {
    await _setPanelState(PanelState.open);
    await scrollTo(key);
  }

  FutureOr<void> _scrollListener() async {
    if (!isDesktop()) {
      return;
    }
    final scrollController = _scrollController;
    final panelController = _panelController;

    if (scrollController == null) {
      return;
    }

    if (panelController == null) {
      return;
    }

    if (panelController.isPanelAnimating) {
      return;
    }

    final offset = scrollController.offset;
    if (_scrollOffset != 0 && offset != 0) {
      return;
    }
    _scrollOffset = offset;
    final direction = scrollController.position.userScrollDirection;

    if (offset < 0 && direction == ScrollDirection.forward) {
      final state = _panelState.previous();
      if (state != null) {
        await scrollController.position.moveTo(0);
        await _setPanelState(state);
      }
    }
    if (offset > 0 && direction == ScrollDirection.reverse) {
      final state = _panelState.next();
      if (state != null) {
        await scrollController.position.moveTo(0);
        await _setPanelState(state);
      }
    }
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    super.dispose();
  }
}

enum PanelState {
  closed._(.1),
  snap._(.5),
  open._(.8);

  const PanelState._(this.extent);

  static PanelState fromPosition(double panelPosition) {
    if (panelPosition == PanelState.snap.extent) {
      return PanelState.snap;
    }
    if (panelPosition > PanelState.snap.extent) {
      return PanelState.open;
    }
    return PanelState.closed;
  }

  final double extent;

  PanelState? next({bool circular = false}) {
    final nextIndex = index + 1;
    if (nextIndex >= values.length) {
      return circular ? values.first : null;
    }
    return values[nextIndex];
  }

  PanelState? previous({bool circular = false}) {
    final previousIndex = index - 1;
    if (previousIndex < 0) {
      return circular ? values.last : null;
    }
    return values[previousIndex];
  }
}

final homeStateProvider = ChangeNotifierProvider.autoDispose(
  (ref) => _HomeState(),
);
