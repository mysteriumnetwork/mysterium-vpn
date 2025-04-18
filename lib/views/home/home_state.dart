import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/data/local/shared_preferences_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class _HomeState extends ChangeNotifier {
  _HomeState(this._prefs, this._analytics) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animatePanelState(initialState).ignore();
    });
  }

  final SharedPreferenceService _prefs;
  final AnalyticsStore _analytics;
  final PanelController panelController = PanelController();
  final typeSwitcherKey = GlobalKey();

  late final PanelState initialState = _prefs.getPanelState() ?? PanelState.snap;

  ScrollController? _scrollController;
  double _scrollOffset = 0;

  PanelState get _panelState => PanelState.fromPosition(panelController.panelPosition);
  PanelState get panelState => _panelState;
  PanelState? _previousState;

  bool get isDraggable => isMobile();

  bool get isPadded => isMobile();

  double get extent =>
      panelController.isAttached ? panelController.panelPosition : initialState.extent;

  ScrollController? get scrollController => _scrollController;

  set scrollController(ScrollController? value) {
    _scrollController?.removeListener(_scrollListener);
    _scrollController = value?..addListener(_scrollListener);
  }

  Future<void> _animatePanelState(PanelState state) async {
    await switch (state) {
      PanelState.closed => panelController.close(),
      PanelState.snap => panelController.animatePanelToSnapPoint(),
      PanelState.open => panelController.open(),
    };
  }

  Future<void> _setPanelState(PanelState state) async {
    await _animatePanelState(state);
    await _prefs.setPanelState(state);
    _previousState = state;
    _analytics.logPanelMoved(state).ignore();
    notifyListeners();
  }

  Future<void> togglePanel() async {
    final next = _panelState.next(circular: true);
    if (next != null) {
      await _setPanelState(next);
    }
  }

  Future<void> collapsePanel() async {
    if (panelController.isAttached) {
      _scrollController?.jumpTo(0);
      _setPanelState(PanelState.closed);
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

  void onPanelSlide(double value) {
    final slide = PanelState.fromPosition(value);
    if (slide != _previousState) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    super.dispose();
  }
}

enum PanelState {
  closed._(.2),
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

  static PanelState fromName(String name) => values.firstWhere(
        (element) => element.name == name,
        orElse: () => PanelState.snap,
      );

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
  (ref) {
    final analyticsStore = ref.watch(analyticsStorePOD);
    return _HomeState(SharedPreferenceService.instance, analyticsStore);
  },
);

final homePanelFlexProvider = Provider.autoDispose((ref) {
  final homeState = ref.watch(homeStateProvider);
  final value = (homeState.extent * 10).round();
  if (value <= 0) {
    return 1;
  }
  if (value >= 5) {
    return 4;
  }
  return value;
});
