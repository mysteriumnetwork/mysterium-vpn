import 'package:flutter_test/flutter_test.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

/// Recording [UrlLauncherPlatform] fake: captures the launched url and can be
/// told to refuse or throw. Install it with [installFakeUrlLauncher].
class FakeUrlLauncher extends UrlLauncherPlatform with MockPlatformInterfaceMixin {
  FakeUrlLauncher({
    this.canLaunchResult = true,
    this.launchResult = true,
    this.launchThrows = false,
  });

  final bool canLaunchResult;
  final bool launchResult;
  final bool launchThrows;

  /// Url passed to the last [launchUrl] call; null when never launched.
  String? launchedUrl;

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> canLaunch(String url) async => canLaunchResult;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launchedUrl = url;
    if (launchThrows) {
      throw Exception('boom');
    }
    return launchResult;
  }
}

/// Installs a [FakeUrlLauncher] as the platform instance and restores the
/// previous one on teardown. Call from `setUp`.
FakeUrlLauncher installFakeUrlLauncher({
  bool canLaunchResult = true,
  bool launchResult = true,
  bool launchThrows = false,
}) {
  final original = UrlLauncherPlatform.instance;
  final fake = FakeUrlLauncher(
    canLaunchResult: canLaunchResult,
    launchResult: launchResult,
    launchThrows: launchThrows,
  );
  UrlLauncherPlatform.instance = fake;
  addTearDown(() => UrlLauncherPlatform.instance = original);
  return fake;
}
