# mysterium-vpn

Next-gen Mysterium VPN client for mobile (iOS/Android) and desktop (Windows/MacOS/Linux).  

## Development

### Prepare environment

```
npm i -g firebase-tools
firebase login
flutterfire configure
```

### Build & run the app

```
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
flutter build ios
```
