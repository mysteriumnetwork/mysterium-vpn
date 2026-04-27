import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

T useResponsiveValue<T>(T fallback, {Size? size, T? mobile, T? tablet, T? desktop}) {
  final screenType = useScreenType(size);
  final entries = {
    ScreenType.desktop: desktop,
    ScreenType.tablet: tablet,
    ScreenType.mobile: mobile,
  }.entries;

  for (var i = 0; i < entries.length; i++) {
    final entry = entries.elementAt(i);
    if (screenType == entry.key) {
      final value = entries.skip(i).firstWhereOrNull((it) => it.value != null)?.value;
      return value ?? fallback;
    }
  }

  return fallback;
}

typedef ResponsiveValueExtractor<T> = T Function();

ScreenType useScreenType([Size? size]) => use(_Hook(size));

class _Hook extends Hook<ScreenType> {
  const _Hook(this.size);

  final Size? size;

  @override
  _HookState createState() => _HookState();
}

class _HookState extends HookState<ScreenType, _Hook> {
  @override
  ScreenType build(BuildContext context) {
    final size = hook.size;
    if (size != null) {
      return ScreenType.fromSize(size);
    }
    return ScreenType.of(context);
  }
}
