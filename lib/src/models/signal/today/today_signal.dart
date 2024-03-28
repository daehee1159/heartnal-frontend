import 'dart:convert';

import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/signal/today/today_signal_dto.dart';
import 'package:couple_signal/src/models/signal/today/today_signal_questions_dto.dart';
import 'package:couple_signal/src/models/signal/today/today_signal_record_detail_dto.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class TodaySignal extends ChangeNotifier {

  int _todaySignalSeq = 0;
  set setTodaySignalSeq(newValue) {
    _todaySignalSeq = newValue;
    notifyListeners();
  }
  int get getTodaySignalSeq => _todaySignalSeq;

  String _position = '';
  set setPosition(newValue) {
    _position = newValue;
    notifyListeners();
  }
  String get getPosition => _position;

  List<TodaySignalQuestionsDto> _allQuestionList = [];
  set setAllQuestionList(newValue) {
    _allQuestionList = newValue;
    notifyListeners();
  }
  List<TodaySignalQuestionsDto> get getAllQuestionList => _allQuestionList;

  List<TodaySignalQuestionsDto> _questionList1 = [];
  set setQuestionList1(newValue) {
    _questionList1 = newValue;
    notifyListeners();
  }
  List<TodaySignalQuestionsDto> get getQuestionList1 => _questionList1;

  List<TodaySignalQuestionsDto> _questionList2 = [];
  set setQuestionList2(newValue) {
    _questionList2 = newValue;
    notifyListeners();
  }
  List<TodaySignalQuestionsDto> get getQuestionList2 => _questionList2;

  TodaySignalDto _todaySignalDto = new TodaySignalDto();
  set setTodaySignalDto(newValue) {
    _todaySignalDto = newValue;
    notifyListeners();
  }
  TodaySignalDto get getTodaySignalDto => _todaySignalDto;

  List<String> _answerList = [];
  set setAnswerList(List<String> newValue) {
    for (int i = 0; i < newValue.length; i++) {
      _answerList.add(newValue[i]);
    }
    notifyListeners();
  }
  set initAnswerList(newValue) {
    _answerList = [];
    notifyListeners();
  }
  List<String> get getAnswerList => _answerList;

  getIsMyTurn() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    int memberSeq = int.parse(pref.getInt(Glob.memberSeq).toString());
    String coupleCode = pref.getString(Glob.coupleCode).toString();
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.dailySignalUrl + '/check/today/signal/$coupleCode/$memberSeq');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    return jsonDecode(response.body);

  }

  getTodaySignalQuestions(String position, int todaySignalSeq) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.dailySignalUrl + '/today/signal/question/$position/$todaySignalSeq');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    List<TodaySignalQuestionsDto> recentSignal = ((json.decode(response.body) as List).map((e) => TodaySignalQuestionsDto.fromJson(e)).toList());

    return recentSignal;
  }

  setTodaySignal(int todaySignalSeq, List<String> questionList, List<String> answerList, String position) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);
    int memberSeq = int.parse(pref.getInt(Glob.memberSeq).toString());
    String coupleCode = pref.getString(Glob.coupleCode).toString();

    var url = Uri.parse(Glob.dailySignalUrl + "/today/signal");

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var postData;

    if (position == 'sender') {
      postData = jsonEncode({
        "senderMemberSeq": memberSeq,
        "coupleCode": coupleCode,
        "questionList": questionList,
        "senderAnswerList": answerList,
      });
    } else {
      postData = jsonEncode({
        "todaySignalSeq": todaySignalSeq,
        "recipientMemberSeq": memberSeq,
        "coupleCode": coupleCode,
        "questionList": questionList,
        "recipientAnswerList": answerList,
      });
    }

    http.Response response = await http.post(
        url,
        headers: headers,
        body: postData
    );

    return jsonDecode(response.body);
  }

  getTodaySignalRecord() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accessToken = pref.getString(Glob.accessToken);
    int memberSeq = int.parse(pref.getInt(Glob.memberSeq).toString());
    String coupleCode = pref.getString(Glob.coupleCode).toString();

    /// 오늘의 시그널 이력보기
    var url = Uri.parse(Glob.dailySignalUrl + '/today/signal/record/$coupleCode/$memberSeq');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    List<TodaySignalDto> todaySignalList = ((json.decode(response.body) as List).map((e) => TodaySignalDto.fromJson(e)).toList());

    print('테스트 데이터');
    print(todaySignalList);

    return todaySignalList;
  }

  getTodaySignalRecordDetail(int todaySignalSeq) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.dailySignalUrl + '/today/signal/record/$todaySignalSeq');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    print('결과 어케 나옴');
    print(jsonDecode(response.body));

    List<TodaySignalRecordDetailDto> detailList = ((json.decode(response.body) as List).map((e) => TodaySignalRecordDetailDto.fromJson(e)).toList());

    return detailList;
  }

  getTodaySignal(int todaySignalSeq) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.dailySignalUrl + '/today/signal/$todaySignalSeq');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    TodaySignalDto signalDto = TodaySignalDto.fromJson(jsonDecode(response.body));

    return signalDto;
  }

}
