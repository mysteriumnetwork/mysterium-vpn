enum Routes {
  welcome('/welcome'),
  main('/main'),
  login('/login'),
  checkYourEmail('/login/check-your-email'),
  splash('/splash'),
  settings('/main/settings'),
  payment('/main/payment'),
  paymentSettings('/main/settings/payment'),
  privacyPolicy('/main/privacy-policy');

  const Routes(this.path);

  final String path;
}
