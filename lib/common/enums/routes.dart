enum Routes {
  welcome('/welcome'),
  main('/main'),
  login('/login'),
  checkYourEmail('/login/check-your-email'),
  splash('/splash'),
  settings('/main/settings'),
  payment('/main/payment'),
  permissions('/main/permissions'),
  privacyPolicy('/main/privacy-policy');

  const Routes(this.path);

  final String path;
}
