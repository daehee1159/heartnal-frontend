import 'dart:convert';

import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Anniversary extends ChangeNotifier {
  int? anniversarySeq;
  String? username;
  String? anniversaryDate;
  String? anniversaryTitle;
  String? repeatYN;
  String? remainingDays;

  String? coupleRegDt;

  var dDayList = [];
  List<Anniversary> anniversaryList = [];

  Anniversary({this.username, this.anniversaryDate, this.anniversaryTitle});

  Anniversary.fromJson(Map<String, dynamic> json) {
    anniversarySeq = json['anniversarySeq'];
    username = json['username'];
    anniversaryDate = json['anniversaryDate'];
    anniversaryTitle = json['anniversaryTitle'];
    repeatYN = json['repeatYN'];
    remainingDays = json['remainingDays'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['anniversarySeq'] = this.anniversarySeq;
    data['username'] = this.username;
    data['anniversaryDate'] = this.anniversaryDate;
    data['anniversaryTitle'] = this.anniversaryTitle;
    data['repeatYN'] = this.repeatYN;
    return data;
  }

  getCoupleRegDt() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/couple/reg-dt/$username');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    String checkCoupleRegDt = 'false';
    String resultCoupleRegDt = 'null';

    if (json.decode(response.body)['checkRegDt'] != null) {
      checkCoupleRegDt = json.decode(response.body)['checkRegDt'];
    }

    if (json.decode(response.body)['coupleRegDt'] != null) {
      resultCoupleRegDt = json.decode(response.body)['coupleRegDt'];
    }

    // coupleRegDt 등록이 안되어 있는 경우 false
    if (checkCoupleRegDt == "false") {
      return false;
    } else {
      // coupleRegDt 등록이 되어 있는 경우
      coupleRegDt = resultCoupleRegDt;
      url = Uri.parse(Glob.memberUrl + '/anniversary/$username');
      http.Response response = await http.get(
        url,
        headers: headers,
      );
      List<Anniversary> fetchData =((json.decode(response.body) as List).map((e) => Anniversary.fromJson(e)).toList());
      // List<AnniversaryDto> fetchData = AnniversaryDto.fromJson(jsonDecode(response.body)) as List<AnniversaryDto>;

      anniversaryList = fetchData;
      notifyListeners();

      return fetchData;
    }
  }

  setAnniversary(String anniversaryTitle, DateTime anniversaryDate, bool repeatYN) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl +'/anniversary');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var postData;

    postData = jsonEncode({
      "username": username.toString(),
      "anniversaryTitle": anniversaryTitle,
      "anniversaryDate": anniversaryDate.toString().substring(0, 10) + " 00:00:00",
      "repeatYN": repeatYN.toString() == "true" ? "Y" : "N"
    });

    http.Response response = await http.post(
      url,
      headers: headers,
      body: postData,
    );

    // home.dart 에서 super.widget 으로 돌아가는거라면 여기서 get 해줄 필요 없음
    // await getCoupleRegDt();
  }

  updateAnniversary(int anniversarySeq, String anniversaryTitle, DateTime anniversaryDate, bool repeatYN) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl +'/anniversary/update');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var postData;

    postData = jsonEncode({
      "username": username.toString(),
      "anniversarySeq": anniversarySeq,
      "anniversaryTitle": anniversaryTitle,
      "anniversaryDate": anniversaryDate.toString().substring(0, 10) + " 00:00:00",
      "repeatYN": repeatYN.toString() == "true" ? "Y" : "N"
    });

    http.Response response = await http.post(
      url,
      headers: headers,
      body: postData,
    );

    if (response.statusCode == 200 && response.body.toString() == "true") {
      return true;
    } else {
      return false;
    }
  }

  deleteAnniversary(int anniversarySeq) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl +'/anniversary/delete');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var postData;

    postData = jsonEncode({
      "username": username.toString(),
      "anniversarySeq": anniversarySeq,
    });

    http.Response response = await http.post(
      url,
      headers: headers,
      body: postData,
    );

    if (response.statusCode == 200 && response.body.toString() == "true") {
      return true;
    } else {
      return false;
    }
  }
}
