import 'package:flutter/material.dart';

class Signal extends ChangeNotifier {
  // signal 에 필요한 data
  late String _position = '';
  set setPosition(newValue) {
    _position = newValue;
    notifyListeners();
  }
  String get getPosition => _position;

  late String _category = '';
  set setCategory(newValue) {
    _category = newValue;
    notifyListeners();
  }
  String get getCategory => _category;

  late int _tryCount = 0;
  set setTryCount(newValue) {
    _tryCount = int.parse(newValue.toString());
    notifyListeners();
  }
  int get getTryCount => _tryCount;

  // eatSignalSeq
  late int _eatSignalSeq = 0;
  set setEatSignalSeq(newValue) {
    _eatSignalSeq = newValue;
    notifyListeners();
  }
  int get getEatSignalSeq => _eatSignalSeq;

  // playSignalSeq
  late int _playSignalSeq = 0;
  set setPlaySignalSeq(newValue) {
    _playSignalSeq = newValue;
    notifyListeners();
  }
  int get getPlaySignalSeq => _playSignalSeq;

  late String _senderSelected = '';
  set setSenderSelected(newValue) {
    _senderSelected = newValue;
    notifyListeners();
  }
  String get getSenderSelected => _senderSelected;

  late String _recipientSelected = '';
  set setRecipientSelected(newValue) {
    _recipientSelected = newValue;
    notifyListeners();
  }
  String get getRecipientSelected => _recipientSelected;

  // result
  late bool _result = false;
  set setResult(newValue) {
    _result = newValue;
    notifyListeners();
  }
  bool get getResult => _result;

  late String _resultSelected = '';
  set setResultSelected(newValue) {
    _resultSelected = newValue;
    notifyListeners();
  }
  String get getResultSelected => _resultSelected;
}
