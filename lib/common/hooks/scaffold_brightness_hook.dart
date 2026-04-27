import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

Brightness useScaffoldBrightness() {
  final themeBrightness = Theme.of(useContext()).brightness;
  return use(const _ScaffoldBrightnessHook()) ?? themeBrightness;
}

class _ScaffoldBrightnessHook extends Hook<Brightness?> {
  const _ScaffoldBrightnessHook();

  @override
  _ScaffoldBrightnessHookState createState() => _ScaffoldBrightnessHookState();
}

class _ScaffoldBrightnessHookState extends HookState<Brightness?, _ScaffoldBrightnessHook>
    with WidgetsBindingObserver {
  Brightness? brightness;

  @override
  void initHook() {
    super.initHook();
    brightness = Scaffold.maybeOf(context)?.widget.backgroundColor._estimatedBrightness;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Brightness? build(BuildContext context) => brightness;

  void _reEvaluate() {
    final brightness = Scaffold.maybeOf(context)?.widget.backgroundColor._estimatedBrightness;
    if (brightness != this.brightness) {
      setState(() {
        this.brightness = brightness;
      });
    }
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _reEvaluate();
  }

  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    _reEvaluate();
  }
}

extension on Color? {
  Brightness? get _estimatedBrightness =>
      this == null ? null : ThemeData.estimateBrightnessForColor(this!);
}
