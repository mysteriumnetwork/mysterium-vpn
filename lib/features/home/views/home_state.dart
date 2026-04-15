import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/packages/sliding_up_panel/panel.dart';
import 'package:mysterium_vpn/services/services.dart';

class HomeStateScope extends InheritedNotifier<HomeState> {
  const HomeStateScope({required super.notifier, required super.child, super.key});

  /// Reactive: rebuilds when HomeState notifies.
  static HomeState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<HomeStateScope>();
    assert(scope != null, 'No HomeStateScope found in context');
    return scope!.notifier!;
  }

  /// Non-reactive: use in callbacks.
  static HomeState read(BuildContext context) {
    final scope = context.findAncestorWidgetOfExactType<HomeStateScope>();
    assert(scope != null, 'No HomeStateScope found in context');
    return scope!.notifier!;
  }
}

class HomeState extends ChangeNotifier {
  HomeState(this._prefs, this._analytics) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animatePanelState(initialState).ignore();
    });
  }

  final SharedPreferenceService _prefs;
  final AnalyticsStore _analytics;
  final PanelController panelController = PanelController();
  final typeSwitcherKey = GlobalKey();
  final locationsKey = GlobalKey();

  late final PanelState initialState = _prefs.getPanelState() ?? PanelState.snap;

  ScrollController? _scrollController;
  double _scrollOffset = 0;

  PanelState get _panelState => panelController.isAttached
      ? PanelState.fromPosition(panelController.panelPosition)
      : initialState;
  PanelState get panelState => _panelState;
  PanelState? _previousState;

  bool get isPadded => isMobile();

  double get extent =>
      panelController.isAttached ? panelController.panelPosition : initialState.extent;

  int get panelFlex {
    final value = (extent * 10).round();
    if (value <= 0) {
      return 1;
    }
    if (value >= 5) {
      return 4;
    }
    return value;
  }

  ScrollController? get scrollController => _scrollController;

  set scrollController(ScrollController? value) {
    _scrollController?.removeListener(_scrollListener);
    _scrollController = value?..addListener(_scrollListener);
  }

  Future<void> _animatePanelState(PanelState state) async {
    if (!panelController.isAttached) {
      return;
    }
    await switch (state) {
      PanelState.closed => panelController.close(),
      PanelState.snap => panelController.animatePanelToSnapPoint(),
      PanelState.open => panelController.open(),
    };
  }

  Future<void> _setPanelState(PanelState state) async {
    await _animatePanelState(state);
    await _notifyPanelState(state);
  }

  Future<void> _notifyPanelState(PanelState state) async {
    if (state != _previousState) {
      await _prefs.setPanelState(state);
      _previousState = state;
      _analytics.logPanelMoved(state).ignore();
    }
    notifyListeners();
  }

  Future<void> togglePanel() async {
    final next = _panelState.next(circular: true);
    if (next != null) {
      await _setPanelState(next);
    }
  }

  Future<void> collapsePanel() async {
    if (!panelController.isAttached) {
      return;
    }
    await _setPanelState(PanelState.closed);
    _scrollController?.jumpTo(0);
  }

  Future<void> scrollToLocations() async {
    if (!panelController.isAttached) {
      return;
    }
    await _setPanelState(PanelState.open);
    final context = locationsKey.currentContext;
    if (context == null || !context.mounted) {
      return;
    }

    final box = context.findRenderObject();
    if (box is! RenderBox) {
      return;
    }

    if (scrollController == null) {
      return;
    }

    // Calculate the offset of the target widget
    final offset = box.localToGlobal(Offset.zero).dy;

    // Scroll to the exact position of the widget
    await scrollController!.animateTo(
      scrollController!.offset + offset,
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
    );
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
    final panelController = this.panelController;

    if (scrollController == null) {
      return;
    }

    if (!panelController.isAttached || panelController.isPanelAnimating) {
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

  /// Tracks the country code that was already scrolled to, so the
  /// scroll-to-selected logic fires only once per selection.
  String? lastScrolledCountryCode;

  void onPanelSlide([double? value]) {
    if (!panelController.isAttached) {
      return;
    }
    value ??= panelController.panelPosition;
    final slide = PanelState.fromPosition(value);
    _notifyPanelState(slide);
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    super.dispose();
  }
}

enum PanelState {
  closed._(.25),
  snap._(.5),
  open._(1);

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

  static PanelState fromName(String name) =>
      values.firstWhere((element) => element.name == name, orElse: () => PanelState.snap);

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
