import 'package:flutter/material.dart';

class CheckSignal extends ChangeNotifier {
  late bool _hasUnResolved;
  // setter
  set setHasUnResolved(bool newValue) {
    _hasUnResolved = newValue;
    notifyListeners();
  }
  // getter
  bool get getHasUnResolved => _hasUnResolved;

  late int _senderEatSignalSeq;
  // setter
  set setSenderEatSignalSeq(newValue) {
    _senderEatSignalSeq = newValue;
    notifyListeners();
  }
  // getter
  int get getSenderEatSignalSeq => _senderEatSignalSeq;

  late int _senderPlaySignalSeq;
  // setter
  set setSenderPlaySignalSeq(newValue) {
    _senderPlaySignalSeq = newValue;
    notifyListeners();
  }
  // getter
  int get getSenderPlaySignalSeq => _senderPlaySignalSeq;

  late int _recipientEatSignalSeq;
  // setter
  set setRecipientEatSignalSeq(newValue) {
    _recipientEatSignalSeq = newValue;
    notifyListeners();
  }
  // getter
  int get getRecipientEatSignalSeq => _recipientEatSignalSeq;

  late int _recipientPlaySignalSeq;
  // setter
  set setRecipientPlaySignalSeq(newValue) {
    _recipientPlaySignalSeq = newValue;
    notifyListeners();
  }
  // getter
  int get getRecipientPlaySignalSeq => _recipientPlaySignalSeq;
}
