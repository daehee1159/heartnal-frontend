import 'dart:convert';

import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/info/my_profile_info.dart';
import 'package:couple_signal/src/models/signal/message/message_of_the_day_dto.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MessageOfTheDay extends ChangeNotifier {
  int _messageOfTheDaySeq = 0;
  set setMessageOfTheDaySeq(newValue) {
    _messageOfTheDaySeq = newValue;
    notifyListeners();
  }
  int get getMessageOfTheDaySeq => _messageOfTheDaySeq;

  int _senderMemberSeq = 0;
  set setSenderMemberSeq(newValue) {
    _senderMemberSeq = newValue;
    notifyListeners();
  }
  int get getSenderMemberSeq => _senderMemberSeq;

  int _recipientMemberSeq = 0;
  set setRecipientMemberSeq(newValue) {
    _recipientMemberSeq = newValue;
    notifyListeners();
  }
  int get getRecipientMemberSeq => _recipientMemberSeq;

  String _coupleCode = "";
  set setCoupleCode(newValue) {
    _coupleCode = newValue;
    notifyListeners();
  }
  String get getCoupleCode => _coupleCode;

  String _message = "";
  set setMessage(newValue) {
    _message = newValue;
    notifyListeners();
  }
  String get getMessage => _message;

  String _regDt = "";
  set setRegDt(newValue) {
    _regDt = newValue;
    notifyListeners();
  }
  String get getRegDt => _regDt;

  bool _termination = false;
  set setTermination(newValue) {
    _termination = newValue;
    notifyListeners();
  }
  bool get getTermination => _termination;

  List _recordItemList = ["날짜별", "보낸 한마디", "받은 한마디", "통계"];
  List get getRecordItemList => _recordItemList;


  setMessageOfTheDay(String message) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int senderMemberSeq = int.parse(pref.getInt(Glob.memberSeq).toString());
    String coupleCode = pref.getString(Glob.coupleCode).toString();

    var url = Uri.parse(Glob.dailySignalUrl);

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var saveData;

    saveData = jsonEncode({
      "senderMemberSeq": senderMemberSeq,
      "coupleCode": coupleCode,
      "message": message
    });

    http.Response response = await http.post(
        url,
        headers: headers,
        body: saveData
    );

    return jsonDecode(response.body);
  }

  getMessageOfTheDay() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int senderMemberSeq = int.parse(pref.getInt(Glob.memberSeq).toString());
    String coupleCode = pref.getString(Glob.coupleCode).toString();

    var url = Uri.parse(Glob.dailySignalUrl + "/$senderMemberSeq" + "/$coupleCode");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    http.Response response = await http.get(
        url,
        headers: headers,
    );

    List<MessageOfTheDayDto> fetchData =((json.decode(response.body) as List).map((e) => MessageOfTheDayDto.fromJson(e)).toList());

    return fetchData;
  }

  getTodayMessageOfTheDay() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int senderMemberSeq = int.parse(pref.getInt(Glob.memberSeq).toString());
    String coupleCode = pref.getString(Glob.coupleCode).toString();

    var url = Uri.parse(Glob.dailySignalUrl + "/today/$coupleCode");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    List<MessageOfTheDayDto> fetchData =((json.decode(response.body) as List).map((e) => MessageOfTheDayDto.fromJson(e)).toList());

    return fetchData;
  }

}
