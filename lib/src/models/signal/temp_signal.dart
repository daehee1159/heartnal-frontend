import 'package:flutter/material.dart';

class TempSignal extends ChangeNotifier {
  late bool _isWatchingAd = false;
  set setIsWatchingAd(newValue) {
    _isWatchingAd = newValue;
    notifyListeners();
  }
  bool get getIsWatchingAd => _isWatchingAd;

  /// SplashScreen 으로 이동 시 이 값을 true 설정 후 route 해야함
  bool _isIntentional = false;
  set setIsIntentional(newValue) {
    _isIntentional = newValue;
    notifyListeners();
  }
  bool get getIsIntentional => _isIntentional;
}
