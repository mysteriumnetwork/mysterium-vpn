import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';

MapController useMapController() => use(const _MapControllerHook());

class _MapControllerHook extends Hook<MapController> {
  const _MapControllerHook();

  @override
  _MapControllerState createState() => _MapControllerState();
}

class _MapControllerState extends HookState<MapController, _MapControllerHook> {
  late final MapController _controller = MapController();

  @override
  MapController build(BuildContext context) => _controller;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
