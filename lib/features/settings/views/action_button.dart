import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class SettingActionButton extends StatefulWidget {
  const SettingActionButton({
    required this.action,
    required this.child,
    this.backgroundColor,
    this.height = 34,
    this.width = 100,
    this.borderRadius = 4,
    super.key,
  });

  final Color? backgroundColor;
  final double height;
  final double width;
  final double borderRadius;
  final FutureOr<void> Function()? action;
  final Widget child;

  @override
  State<SettingActionButton> createState() => _SettingActionButtonState();
}

class _SettingActionButtonState extends State<SettingActionButton> {
  bool _isLoading = false;

  void _handlePressed() {
    setState(() => _isLoading = true);
    Future(() async => widget.action?.call()).whenComplete(() {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) => Theme(
    data: DesignSystemTheme.of(context),
    child: ButtonPrimary(
      decoration: ButtonDecoration(
        decorationColor: widget.backgroundColor,
        minimumSize: Size(widget.width, widget.height),
      ),
      size: ButtonSize.small,
      onPressed: widget.action == null || _isLoading ? null : _handlePressed,
      loading: _isLoading ? const ButtonLoading() : null,
      child: widget.child,
    ),
  );
}
