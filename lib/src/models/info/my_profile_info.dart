import 'dart:convert';
import 'dart:io';

import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/info/couple_info_dto.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:package_info/package_info.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:platform/platform.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:couple_signal/src/service/storage_service.dart';

class MyProfileInfo extends ChangeNotifier {
  String? nickName;
  set setNickName(newValue) {
    nickName = newValue;
    notifyListeners();
  }
  String get getNickName => nickName.toString();

  String? coupleNickName;
  String? myProfileImgAddr;
  set setMyProfileImgAddr(newValue) {
    myProfileImgAddr = newValue;
    notifyListeners();
  }
  String? coupleCode;
  set setCoupleCode(newValue) {
    coupleCode = newValue;
    notifyListeners();
  }
  String get getCoupleCode => coupleCode.toString();

  String? coupleProfileImgAddr;
  set setCoupleProfileImgAddr(newValue) {
    coupleProfileImgAddr = newValue;
    notifyListeners();
  }
  String? mainBannerImgAddr;
  set setMainBannerImgAddr(newValue) {
    mainBannerImgAddr = newValue;
    notifyListeners();
  }
  String? myProfileImgUrl;
  set setMyProfileImgUrl(newValue) {
    myProfileImgUrl = newValue;
    notifyListeners();
  }
  String get getMyProfileImgUrl => myProfileImgUrl.toString();

  String? coupleProfileImgUrl;
  set setCoupleProfileImgUrl(newValue) {
    coupleProfileImgUrl = newValue;
    notifyListeners();
  }
  String get getCoupleProfileImgUrl => coupleProfileImgUrl.toString();

  String? mainBannerImgUrl;
  set setMainBannerImgUrl(newValue) {
    mainBannerImgUrl = newValue;
    notifyListeners();
  }
  String get getMainBannerImgUrl => mainBannerImgUrl.toString();

  String? coupleRegDt;
  String? get getCoupleRegDt => coupleRegDt;

  String? myExpression;
  String? coupleExpression;

  int? dDay;
  Widget? myExpressionWidget;
  set setMyExpressionWidget(newValue) {
    myExpressionWidget = newValue;
    notifyListeners();
  }
  Widget get getMyExpressionWidget => myExpressionWidget as Widget;

  String? myExpressionText;
  set setMyExpressionText(newValue) {
    myExpressionText = newValue;
    notifyListeners();
  }
  String get getMyExpressionText => myExpressionText.toString();

  Widget? coupleExpressionWidget;
  String? coupleExpressionText;

  MyProfileInfo.fromJson(Map<String, dynamic> json) {
    nickName = json['nickName'];
    coupleNickName = json['coupleNickName'];
    coupleCode = json['coupleCode'];
    myProfileImgAddr = json['myProfileImgAddr'];
    coupleProfileImgAddr = json['coupleProfileImgAddr'];
    mainBannerImgAddr = json['mainBannerImgAddr'];
    coupleRegDt = json['coupleRegDt'];
    myExpression = json['myExpression'];
    coupleExpression = json['coupleExpression'];
  }

  getMyProfileInfo() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/profile/$username');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    MyProfileInfo myProfileInfo = MyProfileInfo.fromJson(jsonDecode(response.body));

    nickName = myProfileInfo.nickName;
    coupleNickName = myProfileInfo.coupleNickName;
    myProfileImgAddr = myProfileInfo.myProfileImgAddr;
    coupleProfileImgAddr = myProfileInfo.coupleProfileImgAddr;

    mainBannerImgAddr = myProfileInfo.mainBannerImgAddr;

    coupleRegDt = myProfileInfo.coupleRegDt;
    myExpression = myProfileInfo.myExpression;
    coupleExpression = myProfileInfo.coupleExpression;

    if (coupleRegDt.toString() == 'null') {
      dDay = 0;
    } else {
      DateTime now = DateTime.now();

      DateTime fromDt = DateTime.parse(coupleRegDt.toString());
      ///
      dDay = _daysBetween(fromDt, now) + 1;
    }

    await _returnExpression(myExpression, coupleExpression);

    notifyListeners();
  }

  updateProfileImgAddr(String myProfileImgAddr) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var memberSeq = pref.getInt(Glob.memberSeq);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/update/profile/img');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var saveData;

    saveData = jsonEncode({
      "memberSeq": memberSeq,
      "myProfileImgAddr": myProfileImgAddr.toString(),
    });

    http.Response response = await http.post(
        url,
        headers: headers,
        body: saveData
    );

    if (json.decode(response.body)) {
      setMyProfileImgAddr = myProfileImgAddr.toString();
      return true;
    } else {
      return false;
    }
  }

  updateMainBannerImgAddr(String mainBannerImgAddr) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var memberSeq = pref.getInt(Glob.memberSeq);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/update/banner/img');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var saveData;

    saveData = jsonEncode({
      "memberSeq": memberSeq,
      "mainBannerImgAddr": mainBannerImgAddr.toString(),
    });

    http.Response response = await http.post(
        url,
        headers: headers,
        body: saveData
    );

    if (json.decode(response.body)) {
      setMainBannerImgAddr = mainBannerImgAddr.toString();
      return true;
    } else {
      return false;
    }
  }

  setDownloadUrl(String imgCategory, String fileName, BuildContext context) async {
    final Storage storage = Storage();
    MyProfileInfo _myProfileInfo = Provider.of<MyProfileInfo>(context, listen: false);
    // await _myProfileInfo.getMyProfileInfo();

    try {
      if (imgCategory == "myProfile") {
        String myProfileImgUrl = await storage.downloadURL(fileName, "profile");
        _myProfileInfo.setMyProfileImgAddr = fileName;
        _myProfileInfo.setMyProfileImgUrl = myProfileImgUrl;
      } else if (imgCategory == "coupleProfile") {
        String coupleProfileImgUrl = await storage.downloadURL(fileName, "profile");
        _myProfileInfo.setCoupleProfileImgUrl = coupleProfileImgUrl;
      } else if (imgCategory == "mainBanner") {
        String mainBannerImgUrl = await storage.downloadURL(fileName, "main_banner");
        _myProfileInfo.setMainBannerImgAddr = fileName;
        _myProfileInfo.setMainBannerImgUrl = mainBannerImgUrl;
      }
      return true;
    } catch(e) {
      print("Error");
      print(e);
      return false;
    }
  }

  MyProfileInfo() {
    // _getMyProfileInfo();
  }

  _returnExpression(myExpression, coupleExpression) {
    switch (myExpression) {
      case 'grinHearts':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.grinHearts,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '사랑해';
        notifyListeners();
        break;
      case 'grinSquint':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.grinSquint,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '베리굿';
        notifyListeners();
        break;
      case 'kissWinkHeart':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.kissWinkHeart,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '라면먹고 갈래?';
        notifyListeners();
        break;
      case 'dizzy':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.dizzy,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '아파요';
        notifyListeners();
        break;
      case 'frown':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.frown,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '짜증나';
        notifyListeners();
        break;
      case 'grinBeamSweat':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.grinBeamSweat,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '정말 난감해요;';
        notifyListeners();
        break;
      case 'smileBeam':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.smileBeam,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '좋아요';
        notifyListeners();
        break;
      case 'flushed':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.flushed,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '멍';
        notifyListeners();
        break;
      case 'handshake':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.handshake,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '우리 화해할래?';
        notifyListeners();
        break;
    }
    switch (coupleExpression) {
      case 'null':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.userAlt,
            color: const Color(0xffFE9BE6),
            size: 25.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '커플 미등록';
        notifyListeners();
        break;
      case 'grinHearts':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.grinHearts,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '사랑해';
        notifyListeners();
        break;
      case 'grinSquint':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.grinSquint,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '베리굿';
        notifyListeners();
        break;
      case 'kissWinkHeart':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.kissWinkHeart,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '라면먹고 갈래?';
        notifyListeners();
        break;
      case 'dizzy':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.dizzy,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '아파요';
        notifyListeners();
        break;
      case 'frown':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.frown,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '짜증나';
        notifyListeners();
        break;
      case 'grinBeamSweat':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.grinBeamSweat,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '정말 난감해요;';
        notifyListeners();
        break;
      case 'smileBeam':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.smileBeam,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '좋아요';
        notifyListeners();
        break;
      case 'flushed':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.flushed,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '멍';
        notifyListeners();
        break;
      case 'handshake':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.handshake,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '우리 화해할래?';
        notifyListeners();
        break;
    }
  }

  Future<bool> isCheckCoupleConnect() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/check/couple/connect/$username');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
        url,
        headers: headers,
    );

    return json.decode(response.body);

  }

  getFCMToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int memberSeq = int.parse(pref.getInt(Glob.memberSeq).toString());
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/check/token/$memberSeq');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    return jsonDecode(response.body).toString();
  }

  updateNickName(updateNickName) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/profile/nickname');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var saveData;

    saveData = jsonEncode({
      "username": username.toString(),
      "nickName": updateNickName.toString(),
    });

    http.Response response = await http.post(
        url,
        headers: headers,
        body: saveData
    );

    nickName = updateNickName;
    // notifyListeners();

    return nickName;
  }

  updateCoupleRegDt(updateCoupleRegDt) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/couple/d-day');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var saveData;

    saveData = jsonEncode({
      "username": username.toString(),
      "coupleRegDt": updateCoupleRegDt.toString(),
    });

    http.Response response = await http.post(
        url,
        headers: headers,
        body: saveData
    );

    coupleRegDt = updateCoupleRegDt.toString();
    notifyListeners();

    return coupleRegDt;
  }

  /// 커플 연동 해제
  disconnectCouple() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/disconnect/couple');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var postData = jsonEncode({
      "username": username.toString(),
    });

    http.Response response = await http.post(
        url,
        headers: headers,
        body: postData
    );
    return jsonDecode(response.body);
  }

  // D-day
  // from = 비교날짜, to = 현재날짜
  int _daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  Future<Map<String, String>> getPackageInfo(String platform) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();

    String appName = packageInfo.appName;
    String packageName = packageInfo.packageName;
    String version = packageInfo.version;
    String buildNumber = packageInfo.buildNumber;

    SharedPreferences pref = await SharedPreferences.getInstance();
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/app/version/$platform/$version');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    bool result = jsonDecode(response.body);

    Map<String, String> fetchData = new Map<String, String>();

    if (result == true) {
      fetchData['version'] = version;
      fetchData['comment'] = '최신 버전이에요.';
    } else {
      fetchData['version'] = version;
      fetchData['comment'] = '버전 업데이트가 필요해요!';
    }

    return fetchData;
  }

  getMyCoupleData() async {
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
        pref.setString(Glob.coupleCode, coupleInfoDto.coupleCode.toString());
        pref.setString(Glob.coupleRegDt, coupleInfoDto.coupleRegDt.toString());
      }
    } else {

    }
  }
}
