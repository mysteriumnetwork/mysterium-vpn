import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class _HomeState extends ChangeNotifier {
  _HomeState(this._ipType);

  final typeSwitcherKey = GlobalKey();
  IPType _ipType;
  bool _isPanelOpen = false;
  ScrollPhysics? _tempScrollPhysics;

  PanelController? panelController;
  ScrollController? _scrollController;

  bool get isPanelOpen => _isPanelOpen;

  bool get isDraggable => isMobile();

  bool get isPadded => isMobile();

  IPType get ipType => _ipType;

  set ipType(IPType value) {
    if (_ipType != value) {
      _ipType = value;
      notifyListeners();
    }
  }

  set tempScrollPhysics(ScrollPhysics? value) {
    _tempScrollPhysics = value;
    notifyListeners();
  }

  ScrollPhysics? get tempScrollPhysics => _tempScrollPhysics;

  ScrollController? get scrollController => _scrollController;

  set scrollController(ScrollController? value) {
    _scrollController?.removeListener(_scrollListener);
    _scrollController = value?..addListener(_scrollListener);
  }

  Future<void> openPanel() async {
    _isPanelOpen = true;
    await panelController?.open();
    notifyListeners();
  }

  Future<void> closePanel() async {
    _isPanelOpen = false;
    await panelController?.close();
    notifyListeners();
  }

  Future<void> togglePanel() async {
    if (_isPanelOpen) {
      await closePanel();
    } else {
      await openPanel();
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

    final offset = box.localToGlobal(Offset.zero).dy;

    if (scrollController == null) {
      return;
    }

    final target = scrollController!.offset + offset - kToolbarHeight;
    final position = scrollController!.positions.firstOrNull?.viewportDimension ?? 0;

    if (target <= position) {
      return;
    }

    tempScrollPhysics = const ClampingScrollPhysics();
    scrollController!.jumpTo(scrollController!.offset + offset - kToolbarHeight);
    tempScrollPhysics = null;
  }

  Future<void> show(GlobalKey key) async {
    await openPanel();
    await scrollTo(key);
  }

  FutureOr<void> _scrollListener() async {
    final scrollController = _scrollController;
    final panelController = this.panelController;

    if (scrollController == null) {
      return;
    }

    if (panelController == null) {
      return;
    }

    if (_isPanelOpen &&
        scrollController.offset <= 0 &&
        scrollController.position.userScrollDirection == ScrollDirection.forward) {
      // user tries to scroll up
      scrollController.jumpTo(0);
      await closePanel();
    } else if (!_isPanelOpen &&
        scrollController.offset > 0 &&
        scrollController.position.userScrollDirection == ScrollDirection.reverse) {
      // user tries to scroll down
      scrollController.jumpTo(0);
      await openPanel();
    }
  }

  @override
  void dispose() {
    _scrollController?.removeListener(_scrollListener);
    super.dispose();
  }
}

final homeStateProvider = ChangeNotifierProvider.autoDispose(
  (ref) {
    final vpnStore = ref.watch(vpnStorePOD);
    return _HomeState(
      vpnStore.connectingLocation?.ipType ?? vpnStore.location?.ipType ?? IPType.residential,
    );
  },
);
