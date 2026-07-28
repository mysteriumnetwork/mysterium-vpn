import 'dart:io';

enum Routes {
  welcome('/welcome'),
  main('/main'),
  // Nested under /main so Beamer stacks it on top of home.
  newsCenter('/main/news-center'),
  cancelSubscription('/main/cancel-subscription'),
  login('/login'),
  checkYourEmail('/login/check-your-email'),
  splash('/splash'),
  // Deep link route should be guarded and replaced with correct route
  // Do not use this route in the app
  emailToken('/email-token');

  const Routes(this.path);

  final String path;

  static Routes get platformLogin => Platform.isWindows ? welcome : login;
}
