import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/styles/style.dart';

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
    brightness = Scaffold.maybeOf(context)?.widget.backgroundColor.brightness;
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
    final brightness = Scaffold.maybeOf(context)?.widget.backgroundColor.brightness;
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

extension _ColorBrightnessExtension on Color? {
  Brightness? get brightness => switch (this) {
    Palette.white => Brightness.light,
    Palette.darkBlue => Brightness.dark,
    _ => null,
  };
}
