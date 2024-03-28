import 'dart:convert';

import 'package:couple_signal/src/models/couple_diary/couple_diary.dart';
import 'package:couple_signal/src/models/info/my_profile_info.dart';
import 'package:couple_signal/src/models/signal/temp_signal.dart';
import 'package:couple_signal/src/screens/home.dart';
import 'package:couple_signal/src/service/global_func.dart';
import 'package:couple_signal/src/service/storage_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/global/global_variable.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = getIt.get<TempSignal>();

    if (provider.getIsIntentional) {
      provider.setIsIntentional = false;
      Future<dynamic> result = _fetchData(context);
      result.then((value) {
        if (value == true) {
          Future.delayed(Duration(milliseconds: 1500), () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(routePage: 0)));
          });
        } else {
          GlobalFunc().setErrorLog("SplashScreen _fetchData Error value = $value");
        }
      });
    }

    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'images/heartnal_bi.png',
              height: MediaQuery.of(context).size.height * 0.05,
              fit: BoxFit.contain,
              color: const Color(0xffFE9BE6),
            ),
            Lottie.asset(
              'images/json/splash4.json',
            ),
          ],
        ),
      ),
    );
  }

  _fetchData(BuildContext context) async {
    final Storage storage = Storage();
    MyProfileInfo _myProfileInfo = Provider.of<MyProfileInfo>(context, listen: false);
    CoupleDiary _coupleDiaryProvider = Provider.of<CoupleDiary>(context, listen: false);
    await _myProfileInfo.getMyCoupleData();
    await _myProfileInfo.getMyProfileInfo();
    await _coupleDiaryProvider.getCoupleDiary();
    try {
      String myProfileImgUrl = await storage.downloadURL(_myProfileInfo.myProfileImgAddr.toString(), "profile");
      String coupleProfileImgUrl = await storage.downloadURL(_myProfileInfo.coupleProfileImgAddr.toString(), "profile");
      String mainBannerImgUrl = await storage.downloadURL(_myProfileInfo.mainBannerImgAddr.toString(), "main_banner");

      _myProfileInfo.setMyProfileImgUrl = myProfileImgUrl;
      _myProfileInfo.setCoupleProfileImgUrl = coupleProfileImgUrl;
      _myProfileInfo.setMainBannerImgUrl = mainBannerImgUrl;

      if (myProfileImgUrl != "null") {
        precacheImage(Image.network(myProfileImgUrl).image, context);
      }

      if (coupleProfileImgUrl != "null") {
        precacheImage(Image.network(coupleProfileImgUrl).image, context);
      }

      if (mainBannerImgUrl != "null") {
        precacheImage(Image.network(mainBannerImgUrl).image, context);
      }

      if (_coupleDiaryProvider.coupleDiaryList.length != 0) {
        for (int i = 0; i < _coupleDiaryProvider.coupleDiaryList.length; i++) {
          String downloadFileName = await storage.downloadURL(_coupleDiaryProvider.coupleDiaryList[i].fileName1.toString(), "couple_diary");
          precacheImage(Image.network(downloadFileName).image, context);
        }
      }

      /// FCM Token 만료 체크 및 교체
      String? myDeviceToken;
      await FirebaseMessaging.instance.getToken().then((value) {
        myDeviceToken = value;
      });

      String dbToken = await _myProfileInfo.getFCMToken();

      /// FCM 토큰이 DB 와 다를 경우 update
      if (myDeviceToken.toString() != "" && myDeviceToken.toString() != dbToken) {
        bool result = await _changedDeviceToken(myDeviceToken.toString());
        if (result == false) {
          GlobalFunc().setErrorLog("changedDeviceToken function Error");
        }
      }

      return true;
    } catch(e) {
      GlobalFunc().setErrorLog("SplashScreen _fetchData catch Error log = $e");
      return false;
    }
  }

  Future<bool> _changedDeviceToken(String tokenData) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var email = pref.getString(Glob.email);
    var url = Uri.parse(Glob.memberUrl + '/change/device');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var postData = jsonEncode({
      "email": email,
      "myDeviceToken": tokenData.toString(),
    });

    http.Response response = await http.post(
        url,
        headers: headers,
        body: postData
    );

    bool result = jsonDecode(response.body);

    if (result) {
      return true;
    } else {
      return false;
    }
  }
}

