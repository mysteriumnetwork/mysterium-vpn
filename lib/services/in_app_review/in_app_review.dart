import 'package:flutter/widgets.dart';
import 'package:mysterium_vpn/services/services.dart';

class InAppReviewObserver with WidgetsBindingObserver {
  factory InAppReviewObserver() => _singleton;

  InAppReviewObserver._internal();
  final InAppReviewService _service = InAppReviewService();
  static final InAppReviewObserver _singleton = InAppReviewObserver._internal();

  /// Start monitoring conditions to decide wheter a view attemp is made or not
  void monitor() {
    _service.monitor();
    _startObserver();
  }

  void _startObserver() {
    WidgetsBinding.instance.addObserver(this);
    _afterLaunch();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _afterLaunch();
    }
  }

  void _afterLaunch() {
    _service.showRateDialogIfMeetsConditions();
  }
}
