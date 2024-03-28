import 'dart:convert';
import 'dart:io';

import 'package:couple_signal/src/models/anniversary/anniversary.dart';
import 'package:couple_signal/src/models/calendar/calendar.dart';
import 'package:couple_signal/src/models/calendar/menstrual_cycle.dart';
import 'package:couple_signal/src/models/couple_diary/couple_diary.dart';
import 'package:couple_signal/src/models/global/navigator_service.dart';
import 'package:couple_signal/src/models/inquiry/inquiry.dart';
import 'package:couple_signal/src/models/signal/eat_signal_item.dart';
import 'package:couple_signal/src/models/expression/expression.dart';
import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/info/my_profile_info.dart';
import 'package:couple_signal/src/models/signal/message/message_of_the_day.dart';
import 'package:couple_signal/src/models/signal/play_signal_item.dart';
import 'package:couple_signal/src/models/signal/signal.dart';
import 'package:couple_signal/src/models/signal/check_signal.dart';
import 'package:couple_signal/src/models/signal/recent_signal.dart';
import 'package:couple_signal/src/models/signal/temp_signal.dart';
import 'package:couple_signal/src/models/info/member.dart';
import 'package:couple_signal/src/models/signal/today/today_signal.dart';
import 'package:couple_signal/src/models/theme/theme_provider.dart';
import 'package:couple_signal/src/screens/signup/getting_started_screen.dart';
import 'package:couple_signal/src/screens/splash_screen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// import 'package:kakao_flutter_sdk/all.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
// import 'package:package_info/package_info.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:url_launcher/url_launcher.dart';

bool _loginBool = false;
bool hasMessage = false;
GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerSingleton(TempSignal());
}

Future<void> main() async {
  setupLocator();
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey: Platform.environment['KAKAO_NATIVE_APP_KEY'], javaScriptAppKey: Platform.environment['KAKAO_JAVASCRIPT_APP_KEY']);
  await Firebase.initializeApp();

  /// 토큰이 만료되었을 때
  FirebaseMessaging.instance.onTokenRefresh.listen((newToken) async {
    bool result = await _fcmRefreshToken(newToken);
  });

  // google admob
  // WidgetsFlutterBinding.ensureInitialized();
  // Admob.initialize();
  MobileAds.instance.initialize();

  // version check
  bool result = await _versionCheck(Platform.isIOS ? "iOS" : "android");
  if (result == false && await canLaunch(Platform.isIOS ? Glob.appstoreUrl : Glob.playstoreUrl)) {
    launch(Platform.isIOS ? Glob.appstoreUrl : Glob.playstoreUrl);
  }

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (BuildContext context) => EatSignalItem(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => PlaySignalItem(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => Signal(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => Calendar(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => CheckSignal(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => Expression(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => MyProfileInfo(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => RecentSignal(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => Anniversary(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => ThemeProvider(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => CoupleDiary(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => TempSignal(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => MessageOfTheDay(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => MenstrualCycle(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => Inquiry(),
          ),
          ChangeNotifierProvider(
            create: (BuildContext context) => TodaySignal(),
          ),
        ],
        child: MyApp(),
      )
  );

}
_fcmRefreshToken(newToken) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setString(Glob.fcmTokenBool, "true");
  pref.setString(Glob.fcmToken, newToken);

  String fcmTokenBool = pref.getString(Glob.fcmTokenBool).toString();
  String fcmToken = pref.getString(Glob.fcmToken).toString();

  if (fcmTokenBool == "true" && fcmToken != "" && fcmToken != "null") {
    return true;
  } else {
    return false;
  }
}

_versionCheck(String platform) async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  String version = packageInfo.version;

  SharedPreferences pref = await SharedPreferences.getInstance();
  var accessToken = pref.getString(Glob.accessToken);

  var url = Uri.parse(Glob.memberUrl + '/app/version/$platform/$version');

  Map<String, String> headers = {
    'Content-Type': 'application/json',
  };

  http.Response response = await http.get(
    url,
    headers: headers,
  );

  bool result = jsonDecode(response.body);

  if (result == true) {
    return true;
  } else {
    return false;
  }
}

class HasLoginApp extends StatefulWidget {
  const HasLoginApp({Key? key}) : super(key: key);

  @override
  _HasLoginAppState createState() => _HasLoginAppState();
}

class _HasLoginAppState extends State<HasLoginApp> {
  @override
  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      Future.microtask(() async {
        await FirebaseMessaging.instance.requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        ).then((settings) {
        });
      });
    }
    // 실제적으로 여기서 설정이 되는게 아님 밑에서 설정됨
    return MaterialApp(
      title: 'Heartnal',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          fontFamily: 'CookieRun'
      ),
      navigatorKey: NavigationService().navigationKey,
      home: MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeProvider themeProvider = ThemeProvider();

  void getCurrentTheme() async {
    themeProvider.darkTheme = await themeProvider.preference.getTheme();
  }

  @override
  void initState() {
    getCurrentTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    /// 화면 세로 고정
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    ThemeProvider _themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    _loginCheck() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      var key = 'registration';
      var loginCheck = false;
      bool? result = pref.getBool(key);
      String username = pref.getString(Glob.email).toString();

      if (pref.getBool("hasMessage").toString() == "true") {
        hasMessage = true;
      } else {
        hasMessage = false;
      }

      if (result == null) {
        result = false;
        loginCheck = false;
      }
      loginCheck = result;
      /// 가입된 회원
      if (loginCheck == true) {
        var url = Uri.parse(Glob.accessTokenUrl);

        Map<String, String> headers = {
          'Content-Type': 'application/json',
        };

        final postData = jsonEncode({
          "username": username,
          "password": username,
        });

        http.Response response = await http.post(
            url,
            headers: headers,
            body: postData
        );

        Jwt jwt = Jwt.fromJson(jsonDecode(response.body));

        // accessToken set
        var accessToken = jwt.author.accessToken;
        pref.setString(Glob.accessToken, accessToken);

        // refreshToken set
        var refreshToken = jwt.author.refreshToken;
        pref.setString(Glob.refreshToken, refreshToken);

        _loginBool = true;
      } else if (result == null) {
        _loginBool = false;
      } else {
        /// 미가입 회원
        _loginBool = false;
      }
    }

    /// 다크모드 추가로 인한 stateful 변경
    return ChangeNotifierProvider(
        create: (_) => _themeProvider,
        child: Consumer<ThemeProvider>(
            builder: (context, value, child) {
              return MaterialApp(
                title: 'Flutter Demo',
                debugShowCheckedModeBanner: false,
                theme: _themeProvider.themeData(_themeProvider.darkTheme),
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate
                ],
                supportedLocales: [
                  Locale('ko', 'KO'),
                  // Locale('en', 'US')
                ],
                navigatorKey: NavigationService().navigationKey,
                home: FutureBuilder(
                  future: _loginCheck(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const CircularProgressIndicator()
                            ],
                          ),
                        ),
                      );
                    } else if (_loginBool) {
                      final provider = locator.get<TempSignal>();
                      provider.setIsIntentional = true;
                      return SplashScreen();
                    } else {
                      return GettingStartedScreen();
                    }
                  },
                ),
                // routes: routes,
              );
            }
        )
    );
  }
}
