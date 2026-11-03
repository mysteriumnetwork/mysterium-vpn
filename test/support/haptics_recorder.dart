import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Records haptic feedback fired for the rest of the test.
///
/// Returns a growable list of feedback types, e.g.
/// `'HapticFeedbackType.successNotification'`. Other platform calls are passed
/// through as null, matching the untouched channel's behaviour.
List<String> recordHaptics() {
  final fired = <String>[];
  final messenger = TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;

  // The messenger is shared by every test in the file and the binding never
  // clears its handlers, so unregister explicitly.
  addTearDown(() => messenger.setMockMethodCallHandler(SystemChannels.platform, null));

  messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
    if (call.method == 'HapticFeedback.vibrate') {
      fired.add(call.arguments as String);
    }
    return null;
  });

  return fired;
}
