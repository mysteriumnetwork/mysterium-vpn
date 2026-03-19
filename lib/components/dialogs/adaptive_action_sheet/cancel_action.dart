import 'package:flutter/material.dart';

class CancelAction {
  CancelAction({required this.title, this.onPressed});

  final String title;

  final void Function(BuildContext context)? onPressed;
}
