import 'package:flutter/material.dart';

class BottomSheetAction {
  BottomSheetAction({required this.title, required this.onPressed});

  final String title;
  final void Function(BuildContext context) onPressed;
}
