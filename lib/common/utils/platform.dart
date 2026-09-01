import 'dart:io';

bool isDesktop() => Platform.isWindows || Platform.isLinux || Platform.isMacOS;

bool isMobile() => Platform.isAndroid || Platform.isIOS;

/// Platforms with a push transport. macOS is included: firebase_messaging ships
/// a native macOS implementation and the app already carries the
/// `com.apple.developer.aps-environment` entitlement. Windows and Linux have no
/// FCM support, so they keep the no-op notifications repository.
bool isPushSupported() => Platform.isAndroid || Platform.isIOS || Platform.isMacOS;
