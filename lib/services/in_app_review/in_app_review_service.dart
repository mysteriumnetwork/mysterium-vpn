import 'dart:io';

import 'package:in_app_review/in_app_review.dart';
import 'package:mysterium_vpn/env.dart';

class InAppReviewService {
  factory InAppReviewService() => _singleton;

  InAppReviewService._internal();
  static final InAppReviewService _singleton = InAppReviewService._internal();

  /// Whether the native store review prompt can be shown on this device:
  /// a supported platform (Android/iOS/macOS — not Windows/Linux) where the
  /// OS reports the review API as available.
  Future<bool> isAvailable() async {
    if (!supportsNativeReview) {
      return false;
    }
    return InAppReview.instance.isAvailable();
  }

  /// Opens the native store review prompt when the platform supports it.
  ///
  /// Returns `true` when the native prompt was requested, `false` when it is
  /// unavailable (Windows/Linux — `in_app_review` has no implementation there;
  /// Samsung; or the OS quota is exhausted) so the caller can fall back to
  /// opening the store page directly.
  Future<bool> requestReview() async {
    if (!await isAvailable() || isSamsung()) {
      return false;
    }
    await InAppReview.instance.requestReview();
    return true;
  }

  /// Whether the platform ships a native review implementation at all — not
  /// Windows or Linux, where `in_app_review` throws `MissingPluginException`.
  ///
  /// Deliberately excludes Samsung: those devices keep the store arm and fall
  /// through [requestReview] to the store page, rather than being reassigned to
  /// the other A/B arm behind ConfigCat's back.
  bool get supportsNativeReview => Platform.isAndroid || Platform.isIOS || Platform.isMacOS;

  /// On Samsung devices the in-app review dialog does not work properly.
  bool isSamsung() {
    if (Platform.isAndroid) {
      return Env.deviceManufacturer.toLowerCase().contains('samsung');
    }
    return false;
  }
}
