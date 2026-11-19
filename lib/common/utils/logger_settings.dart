import 'package:flutter/foundation.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:talker/talker.dart';

/// Whether verbose diagnostics are wanted, matching the gate the rest of the
/// app uses — dev-flavour *release* builds are what QA and Test Lab run.
bool get _diagnosticsWanted => kDebugMode || Env.flavor.isDev;

/// Talker config shared by the app's loggers.
///
/// Console output is the expensive half: every line is a `print()` to logcat on
/// Android's main thread. History is dropped too — nothing reads it — though
/// that saves only the retained entries, since Talker renders each message for
/// its history filter either way.
TalkerSettings appTalkerSettings() => _diagnosticsWanted
    ? TalkerSettings()
    : TalkerSettings(useConsoleLogs: false, useHistory: false);
