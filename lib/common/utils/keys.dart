import 'package:flutter/widgets.dart';

typedef K = Keys;

class Keys {
  static const backButton = Key('backButton');

  // login
  static const loginPage = Key('loginPage');
  static const loginEmailField = Key('loginEmailField');
  static const loginButton = Key('loginButton');

  // home
  static const homePage = Key('homePage');
  static const unauthenticatedBanner = Key('unauthenticatedBanner');
  static const subscriptionBanner = Key('subscriptionBanner');
  static const subscriptionBannerCTA = Key('subscriptionBannerCTA');

  // subscription
  static const subscriptionPage = Key('subscriptionPage');
}
