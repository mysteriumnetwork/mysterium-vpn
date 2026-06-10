import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

part 'tooltip_content.freezed.dart';

@freezed
abstract class TooltipContent with _$TooltipContent {
  factory TooltipContent({
    required String title,
    required String description,
    required IconData? icon,
    @Default(LocaleKeys.continueBtn) String actionLabel,
  }) = _TooltipContent;
}
