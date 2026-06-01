import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'tooltip_content.freezed.dart';

@freezed
abstract class TooltipContent with _$TooltipContent {
  factory TooltipContent({
    required String title,
    required String description,
    required String actionLabel,
    required VoidCallback onActionPressed,
  }) = _TooltipContent;
}
