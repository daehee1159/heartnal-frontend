import 'dart:convert';

import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/info/couple_info_dto.dart';
import '../models/signal/temp_signal.dart';
import '../screens/home.dart';
import 'package:flutter/material.dart';

import '../screens/splash_screen.dart';

class GlobalFunc {
  setErrorLog(String errorLog) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/error');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var saveData;

    saveData = jsonEncode({
      "errorLog": errorLog,
    });

    http.Response response = await http.post(
        url,
        headers: headers,
        body: saveData
    );
  }

  /// DB 의 coupleCode 와 pref 의 coupleCode 를 비교 맞으면 true 다르면 false
  /// 커플 해제 후 다시 연동할 때 이 함수가 필요함
  checkCoupleCode(BuildContext context) async {
    final provider = getIt.get<TempSignal>();
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/couple/info/$username');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    if (response.body != "") {
      CoupleInfoDto coupleInfoDto = CoupleInfoDto.fromJson(jsonDecode(response.body));

      if (pref.getString(Glob.coupleCode).toString() != coupleInfoDto.coupleCode.toString()) {
        provider.setIsIntentional = true;
        Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
      }
    }
  }
}
