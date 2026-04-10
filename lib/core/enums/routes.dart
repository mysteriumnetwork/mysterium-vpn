import 'dart:io';

enum Routes {
  welcome('/welcome'),
  main('/main'),
  login('/login'),
  checkYourEmail('/login/check-your-email'),
  splash('/splash'),
  settings('/main/settings'),
  // Deep link route should be guarded and replaced with correct route
  // Do not use this route in the app
  emailToken('/email-token');

  const Routes(this.path);

  final String path;

  static Routes get platformLogin => Platform.isWindows ? welcome : login;
}
