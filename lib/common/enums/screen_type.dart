import 'package:flutter/widgets.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';

enum ScreenType implements Comparable<ScreenType> {
  watch._(0),
  mobile._(1),
  tablet._(2),
  desktop._(3);

  const ScreenType._(this.weight);

  static ScreenType of(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return getScreenType(size);
  }

  final int weight;

  @override
  int compareTo(ScreenType other) => weight.compareTo(other.weight);

  bool operator <(ScreenType other) => compareTo(other) < 0;

  bool operator <=(ScreenType other) => compareTo(other) <= 0;

  bool operator >(ScreenType other) => compareTo(other) > 0;

  bool operator >=(ScreenType other) => compareTo(other) >= 0;
}
