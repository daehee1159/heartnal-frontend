import 'dart:io';

import 'package:flutter/material.dart';

class Glob {
  static final String serverUrl = 'http://${Platform.environment['SERVER_URL'] ?? '10.0.2.2:80'}';
  static final String memberUrl = 'http://${Platform.environment['MEMBER_URL'] ?? '10.0.2.2:80'}/api/member';
  static final String eatSignalUrl = 'http://${Platform.environment['EAT_SIGNAL_URL'] ?? '10.0.2.2:80'}/eat-signal';
  static final String playSignalUrl = 'http://${Platform.environment['PLAY_SIGNAL_URL'] ?? '10.0.2.2:80'}/play-signal';
  static final String dailySignalUrl = 'http://${Platform.environment['DAILY_SIGNAL_URL'] ?? '10.0.2.2:80'}/api/daily/signal';
  static final String calendarUrl = 'http://${Platform.environment['CALENDAR_URL'] ?? '10.0.2.2:80'}/api/calendar';
  static final String accessTokenUrl = 'http://${Platform.environment['ACCESS_TOKEN_URL'] ?? '10.0.2.2:80'}/authenticate';

  static final String coupleDiaryUrl = 'http://${Platform.environment['DIARY_URL'] ?? '10.0.2.2:80'}/api/diary';
  static final String email = "email";

  static final String identifier = "identifier";

  static final String memberSeq = "memberSeq";

  static final String coupleCode = "coupleCode";
  static final String coupleRegDt = "coupleRegDt";
  static final String accessToken = "accessToken";
  static final String refreshToken = "refreshToken";
  static final String nickName = "nickName";

  static final String fcmTokenBool = "fcmTokenBool";
  static final String fcmToken = "fcmToken";

  String testData = "";

  static final String playstoreUrl = "https://play.google.com/store/apps/details?id=com.msm.couple_signal";
  static final String appstoreUrl = "https://apps.apple.com/kr/app/%ED%95%98%ED%8A%B8%EB%84%90heartnal/1615266807";

  static String kakaoAuthorization = Platform.environment['KAKAO_AUTHORIZATION'].toString();

  static String bannerAdUnitId = Platform.isIOS ? Platform.environment['IOS_BANNER_ID'].toString() : Platform.environment['ANDROID_BANNER_ID'].toString();
  static String interstitialAdUnitId = Platform.isIOS ? Platform.environment['IOS_INTERSTITIAL_ID'].toString() : Platform.environment['ANDROID_INTERSTITIAL_ID'].toString();

  static final String privacySiteUrl = "https://sites.google.com/view/heartnal";

  static final List calendarColors = [Colors.blue, Colors.red, Colors.yellow, Color(0xffFE9BE6), Colors.green, Colors.grey, Colors.purple, Colors.orange];

  static const Map<String, Color> colorStringToColor = {
    'blue': Color(0x802196f3),
    'pink': Color(0x80ff4081),
    'brown': Color(0x80795548),
    'cyanAccent': Color(0x8018ffff),
    // 'red': Colors.red,
    // 'yellow': Colors.yellow,
    // 'heartnal': Color(0xffFE9BE6),
    'green': Color(0x804caf50),
    'grey': Color(0x809e9e9e),
    'purpleAccent': Color(0x80e040fb),
    'orange': Color(0x80ff9800),
  };

  static final List<int> menstrualCycleList = [14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52];
  static final List<int> menstrualPeriodList = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15];
  static final List<String> contraceptiveList = ["CONTRACEPTIVE_A", "CONTRACEPTIVE_B", "CONTRACEPTIVE_C", "CONTRACEPTIVE_D", "CONTRACEPTIVE_NONE"];

  static final List<String> inquiryType = ['유형 선택','유형A', '유형B', '유형C', '유형D', '유형E', '유형F'];

}
