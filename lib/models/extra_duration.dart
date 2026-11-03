import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';

part 'extra_duration.freezed.dart';

/// Bonus period granted on top of a subscription's standard first period —
/// e.g. three bonus months on a 1-year plan, making the first period 15 months.
@freezed
abstract class ExtraDuration with _$ExtraDuration {
  factory ExtraDuration({required int amount, required ExtraDurationUnit unit}) = _ExtraDuration;
}
