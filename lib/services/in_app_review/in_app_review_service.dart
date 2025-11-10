import 'package:in_app_review/in_app_review.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/services/services.dart';

class InAppReviewService {
  factory InAppReviewService() => _singleton;

  InAppReviewService._internal();
  static final InAppReviewService _singleton = InAppReviewService._internal();

  int minDaysAfterInstall = 7;
  int minDaysBeforeRemind = 14;
  final _sharedPrefs = SharedPreferenceService.instance;

  void monitor() {
    if (!_isFirstLaunch()) {
      _setInstallDate();
    }
  }

  bool showRateDialogIfMeetsConditions() {
    final isMeetsConditions = _shouldShowRateDialog();
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

  bool _shouldShowRateDialog() => _isOverInstallDate() && _isOverRemindDate();

  bool _isOverInstallDate() => _isOverDate(_getInstallTimestamp(), minDaysAfterInstall);

  bool _isOverRemindDate() => _isOverDate(_getRemindTimestamp(), minDaysBeforeRemind);

  bool _isOverDate(int targetDate, int threshold) =>
      DateTime.now().millisecondsSinceEpoch - targetDate >= threshold * 24 * 60 * 60 * 1000;

  bool _isFirstLaunch() => _sharedPrefs.checkExistance(StorageKeys.appInstallDay);

  int _getInstallTimestamp() {
    final installTimestamp = _sharedPrefs.getAppInstallDay();
    if (installTimestamp != null) {
      return installTimestamp;
    }
    return 0;
  }

  Future<bool> _setInstallDate() async =>
      _sharedPrefs.setAppInstallDay(DateTime.now().millisecondsSinceEpoch);

  int _getRemindTimestamp() {
    final remindIntervalTime = _sharedPrefs.getRemindTimeStamp();
    if (remindIntervalTime != null) {
      return remindIntervalTime;
    }
    return 0;
  }

  Future<bool> _setRemindTimestamp() async =>
      _sharedPrefs.setRemindTimeStamp(DateTime.now().millisecondsSinceEpoch);
}
