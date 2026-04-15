import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';

class AppLogo extends StatefulWidget {
  const AppLogo({super.key, this.brightness});

  final Brightness? brightness;

  @override
  State<AppLogo> createState() => _AppLogoState();
}

class _AppLogoState extends State<AppLogo> with WidgetsBindingObserver {
  Brightness? _scaffoldBrightness;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reEvaluate();
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

  void _reEvaluate() {
    if (!mounted) {
      return;
    }
    final bg = Scaffold.maybeOf(context)?.widget.backgroundColor;
    final newBrightness = _colorBrightness(bg);
    if (newBrightness != _scaffoldBrightness) {
      setState(() {
        _scaffoldBrightness = newBrightness;
      });
    }
  }

  static Brightness? _colorBrightness(Color? color) => switch (color) {
    Palette.white => Brightness.light,
    Palette.darkBlue => Brightness.dark,
    _ => null,
  };

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeBrightness = Theme.of(context).brightness;
    final brightness = widget.brightness ?? _scaffoldBrightness ?? themeBrightness;

    return SvgIcon(
      asset: switch (brightness) {
        Brightness.dark => Asset.logo.logoWhite,
        Brightness.light => Asset.logo.logoBlack,
      },
    );
  }
}
