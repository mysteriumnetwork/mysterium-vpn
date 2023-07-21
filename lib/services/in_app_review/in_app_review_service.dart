import 'package:in_app_review/in_app_review.dart';
import 'package:mysterium_vpn/common/enums/storage_keys.dart';
import 'package:mysterium_vpn/services/shared_preferences_service.dart';

class InAppReviewService {
  factory InAppReviewService() => _singleton;

  InAppReviewService._internal();
  static final InAppReviewService _singleton = InAppReviewService._internal();

  int minDaysAfterInstall = 7;
  int minDaysBeforeRemind = 14;
  final _sharedPrefs = SharedPreferenceService.instance;

  Future<void> monitor() async {
    if (await _isFirstLaunch() == false) {
      _setInstallDate();
    }
  }

  Future<bool> showRateDialogIfMeetsConditions() async {
    final isMeetsConditions = await _shouldShowRateDialog();
    if (isMeetsConditions) {
      Future.delayed(const Duration(seconds: 5), _showDialog);
    }
    return isMeetsConditions;
  }

  Future<void> _showDialog() async {
    final inAppReview = InAppReview.instance;
    if (await inAppReview.isAvailable()) {
      inAppReview.requestReview();
    }
    _setRemindTimestamp();
  }

  Future<bool> _shouldShowRateDialog() async =>
      await _isOverInstallDate() && await _isOverRemindDate();

  Future<bool> _isOverInstallDate() async {
    final overInstallDate = await _isOverDate(await _getInstallTimestamp(), minDaysAfterInstall);
    return overInstallDate;
  }

  Future<bool> _isOverRemindDate() async {
    final overRemindDate = await _isOverDate(await _getRemindTimestamp(), minDaysBeforeRemind);
    return overRemindDate;
  }

  Future<bool> _isOverDate(int targetDate, int threshold) async =>
      DateTime.now().millisecondsSinceEpoch - targetDate >= threshold * 24 * 60 * 60 * 1000;

  Future<bool> _isFirstLaunch() async => _sharedPrefs.checkExistance(StorageKeys.appInstallDay);

  Future<int> _getInstallTimestamp() async {
    final installTimestamp = await _sharedPrefs.getAppInstallDay();
    if (installTimestamp != null) {
      return installTimestamp;
    }
    return 0;
  }

  Future<bool> _setInstallDate() async =>
      _sharedPrefs.setAppInstallDay(DateTime.now().millisecondsSinceEpoch);

  Future<int> _getRemindTimestamp() async {
    final remindIntervalTime = await _sharedPrefs.getRemindTimeStamp();
    if (remindIntervalTime != null) {
      return remindIntervalTime;
    }
    return 0;
  }

  Future<bool> _setRemindTimestamp() async =>
      _sharedPrefs.setRemindTimeStamp(DateTime.now().millisecondsSinceEpoch);
}
