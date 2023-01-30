import 'package:flutter/material.dart';

import '../enums/enums.dart';

/// Contains sizing information to make responsive choices for the current screen
class ScreenSizeConfiguration {
  final ScreenType screenType;
  final SizeType sizeType;
  final Size screenSize;
  final Size localWidgetSize;

  bool get isMobile => screenType == ScreenType.mobile;

  bool get isTablet => screenType == ScreenType.tablet;

  bool get isDesktop => screenType == ScreenType.desktop;

  bool get isWatch => screenType == ScreenType.watch;

  // Refined

  bool get isExtraLarge => sizeType == SizeType.extraLarge;

  bool get isLarge => sizeType == SizeType.large;

  bool get isNormal => sizeType == SizeType.normal;

  bool get isSmall => sizeType == SizeType.small;

  ScreenSizeConfiguration({
    required this.screenType,
    required this.sizeType,
    required this.screenSize,
    required this.localWidgetSize,
  });

  @override
  String toString() => 'DeviceType:$screenType RefinedSize:$sizeType ScreenSize:$screenSize LocalWidgetSize:$localWidgetSize';
}