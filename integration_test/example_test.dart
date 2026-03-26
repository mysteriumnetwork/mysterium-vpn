import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest('Sanity check to ensure integration test setup is working', ($) async {
    // Replace later with your app's main widget
    await $.pumpWidgetAndSettle(
      MaterialApp(
        home: Scaffold(
          appBar: AppBar(title: const Text('app')),
          backgroundColor: Colors.blue,
        ),
      ),
    );

    expect($('app'), findsOneWidget);
    if (!Platform.isMacOS) {
      await $.platformAutomator.mobile.pressHome();
    }
  });
}
