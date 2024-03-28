import 'dart:convert';

import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class RecentSignal extends ChangeNotifier{
  String? category;
  int? signalSeq;
  int? senderMemberSeq;
  String? finalResult;
  String? finalResultItem;
  Widget? finalResultWidget;
  String? regDt;

  String? mostMatchedSignalItem;
  int? mostMatchedSignalItemCount;

  int _recentSignalCount = 0;
  // set setRecentSignalCount(int newValue) {
  //   _recentSignalCount = newValue;
  //   notifyListeners();
  // }
  int get getRecentSignalCount => _recentSignalCount;

  int _eatSignalRecentCount = 0;
  set setEatSignalRecentCount(int newValue) {
    _eatSignalRecentCount = newValue;
    notifyListeners();
  }
  int get getEatSignalRecentCount => _eatSignalRecentCount;

  int _eatSignalRecentSuccessCount = 0;
  set setEatSignalRecentSuccessCount(int newValue) {
    _eatSignalRecentSuccessCount = newValue;
    notifyListeners();
  }
  int get getEatSignalRecentSuccessCount => _eatSignalRecentSuccessCount;

  int _playSignalRecentCount = 0;
  set setPlaySignalRecentCount(int newValue) {
    _playSignalRecentCount = newValue;
    notifyListeners();
  }
  int get getPlaySignalRecentCount => _playSignalRecentCount;

  int _playSignalRecentSuccessCount = 0;
  set setPlaySignalRecentSuccessCount(int newValue) {
    _playSignalRecentSuccessCount = newValue;
    notifyListeners();
  }
  int get getPlaySignalRecentSuccessCount => _playSignalRecentSuccessCount;

  RecentSignal();

  RecentSignal.fromJson(Map<String, dynamic> json) {
    category = json['category'];
    signalSeq = json['signalSeq'];
    senderMemberSeq = json['senderMemberSeq'];
    finalResult = json['finalResult'];
    finalResultItem = json['finalResultItem'];
    regDt = json['regDt'];
    mostMatchedSignalItem = json['mostMatchedSignalItem'];
    mostMatchedSignalItemCount = json['mostMatchedSignalItemCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category'] = this.category;
    data['signalSeq'] = this.signalSeq;
    data['senderMemberSeq'] = this.senderMemberSeq;
    data['finalResult'] = this.finalResult;
    data['finalResultItem'] = this.finalResultItem;
    data['regDt'] = this.regDt;
    data['mostMatchedSignalItem'] = this.mostMatchedSignalItem;
    data['mostMatchedSignalItemCount'] = this.mostMatchedSignalItemCount;
    return data;
  }

  getRecentSignal() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/signal/recent/$username');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    if (response.body == "") {
      RecentSignal recentSignal = new RecentSignal();
      recentSignal.category = 'null';
      recentSignal.signalSeq = 0;
      recentSignal.finalResult = 'null';
      recentSignal.finalResultWidget = null;
      recentSignal.regDt = 'null';

      List<RecentSignal> recentSignalList = [];

      recentSignalList.add(recentSignal);
      return recentSignalList;
    } else {
      List<RecentSignal> recentSignal = ((json.decode(response.body) as List).map((e) => RecentSignal.fromJson(e)).toList());

      int recentCount = 0;

      for (int i = 0; i < recentSignal.length; i++) {
        if (recentSignal[i].finalResult == '1') {
          recentCount++;
          recentSignal[i].finalResultWidget = IconButton(
            icon: const Icon(
              FontAwesomeIcons.solidHeart,
              color: const Color(0xffFE9BE6),
              size: 30.0,
            ),
            onPressed: () {

            },
          );
        } else {
          recentSignal[i].finalResultWidget = IconButton(
            icon: const Icon(
              FontAwesomeIcons.heartBroken,
              color: Colors.grey,
              size: 30.0,
            ),
            onPressed: () {

            },
          );
        }
      }

      int _eatSignalRecentCount = 0;
      int _eatSignalRecentSuccessCount = 0;
      int _playSignalRecentCount = 0;
      int _playSignalRecentSuccessCount = 0;

      /// 오늘 뭐먹지, 오늘 뭐하지 최근 20개
      for (int i = 0; i < recentSignal.length; i++) {
        if (recentSignal[i].category == 'eatSignal') {
          _eatSignalRecentCount++;
          if (recentSignal[i].finalResult == '1') {
            _eatSignalRecentSuccessCount++;
          }
        }
        if (recentSignal[i].category == 'playSignal') {
          _playSignalRecentCount++;
          if (recentSignal[i].finalResult == '1') {
            _playSignalRecentSuccessCount++;
          }
        }
      }

      setEatSignalRecentCount = _eatSignalRecentCount;
      setEatSignalRecentSuccessCount = _eatSignalRecentSuccessCount;
      setPlaySignalRecentCount = _playSignalRecentCount;
      setPlaySignalRecentSuccessCount = _playSignalRecentSuccessCount;

      _recentSignalCount = recentCount;
      notifyListeners();

      return recentSignal;
    }
  }

  getAllSignalList(String category) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);
    int memberSeq = int.parse(pref.getInt(Glob.memberSeq).toString());

    var url = Uri.parse(Glob.memberUrl + '/signal/recent/all/$memberSeq/$category');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    List<RecentSignal> recentSignal = ((json.decode(response.body) as List).map((e) => RecentSignal.fromJson(e)).toList());

    return recentSignal;
  }

  getMostMatchedSignalItem(String category, String startDt, String endDt) async {
    print("호출 여부");
    SharedPreferences pref = await SharedPreferences.getInstance();
    String coupleCode = pref.getString(Glob.coupleCode).toString();
    String username = pref.getString(Glob.email).toString();
    var accessToken = pref.getString(Glob.accessToken);
    int memberSeq = int.parse(pref.getInt(Glob.memberSeq).toString());

    var url = Uri.parse(Glob.memberUrl + '/most/matched/item');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var saveData;

    saveData = jsonEncode({
      "memberSeq": memberSeq,
      "coupleCode": coupleCode,
      "category": category,
      "startDt": startDt,
      "endDt": endDt
    });

    http.Response response = await http.post(
        url,
        headers: headers,
        body: saveData
    );

    print(response.body);

    RecentSignal recentSignal = RecentSignal.fromJson(jsonDecode(response.body));

    print("리턴 여부");
    print(recentSignal);


    return recentSignal;
  }
}
