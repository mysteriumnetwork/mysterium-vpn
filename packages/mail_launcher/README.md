# mail_launcher

Detects installed mail clients and launches them to their inbox view.

Supported platforms: iOS, macOS, Android.

## Usage

```dart
import 'package:mail_launcher/mail_launcher.dart';

final apps = await MailLauncher.installed();
if (apps.length == 1) {
  await MailLauncher.open(apps.first);
} else if (apps.length > 1) {
  // present a picker, then call MailLauncher.open(selected)
}
```

## Host app setup

### iOS — `Info.plist`

Declare the URL schemes the plugin probes via `canOpenURL`:

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>message</string>
  <string>googlegmail</string>
  <string>ms-outlook</string>
  <string>readdle-spark</string>
  <string>airmail</string>
  <string>ymail</string>
  <string>fastmail</string>
  <string>superhuman</string>
  <string>protonmail</string>
  <string>x-dispatch</string>
</array>
```

### Android — `AndroidManifest.xml`

Declare a `mailto:` query so `PackageManager.queryIntentActivities` returns results
on Android 11+:

```xml
<queries>
  <intent>
    <action android:name="android.intent.action.VIEW" />
    <data android:scheme="mailto" />
  </intent>
</queries>
```

### macOS

No manifest changes required. Enumeration uses `NSWorkspace.urlsForApplications(toOpen:)`
and launch uses `NSWorkspace.openApplication(at:)`, both sandbox-safe.
