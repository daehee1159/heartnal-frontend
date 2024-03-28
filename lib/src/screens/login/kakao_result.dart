import 'dart:convert';

import 'package:couple_signal/main.dart';
import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/signal/temp_signal.dart';
import 'package:couple_signal/src/screens/error/before_registration_error.dart';
import 'package:couple_signal/src/screens/home.dart';
import 'package:couple_signal/src/screens/signup/signup_nickname.dart';
import 'package:couple_signal/src/screens/splash_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginResult extends StatefulWidget {
  const LoginResult({Key? key}) : super(key: key);

  @override
  _LoginResultState createState() => _LoginResultState();
}

class _LoginResultState extends State<LoginResult> {
  final provider = getIt.get<TempSignal>();
  String _accountEmail = 'None';
  String _gender = 'None';
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // _initText();
  }

  _initText() async {
    final User user = await UserApi.instance.me();
    _accountEmail = user.kakaoAccount!.email.toString();
    _gender = user.kakaoAccount!.gender.toString();

    return _accountEmail;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        leading: Container(),
      ),
      body: FutureBuilder(
        future: _initText(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return FutureBuilder(
                future: _memberRegistrationCheck(snapshot.data.toString()),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
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
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    );
                  } else if (snapshot.data == 'UNSUBSCRIBED') {
                    return SafeArea(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height * 0.05),
                                child: Image.asset(
                                  'images/heartnal_bi.png',
                                  height: MediaQuery.of(context).size.height * 0.07,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              Text(
                                '성공적으로 인증되었어요.',
                                style: Theme.of(context).textTheme.bodyText1,
                                textAlign: TextAlign.center,
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 3, 0, MediaQuery.of(context).size.height * 0.05),
                                child: Text(
                                  '이후 몇가지 질문에 답변해주세요.',
                                  style: Theme.of(context).textTheme.bodyText1,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              TextButton(
                                child: Text(
                                  '다음 단계 진행하기',
                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 18.0, color: Colors.white),
                                ),
                                style: TextButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  padding: const EdgeInsets.all(15),
                                  backgroundColor: const Color(0xffFE9BE6),
                                ),
                                onPressed: () {
                                  _setEmail(_accountEmail);
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => SignupNickName()));
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (snapshot.data == 'INACTIVE') {
                    return Container(
                      child: Column(
                        children: [
                          Center(
                            child: Text(
                              '휴면 상태 회원',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          )
                        ],
                      ),
                    );
                  } else if (snapshot.data == 'WITHDRAWAL') {
                    return Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            "탈퇴 후 30일이 지나지 않았어요.",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          Text(
                            "회원 복구가 가능해요.",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          TextButton(
                            child: Text(
                              "복구하기",
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor: const Color(0xffFE9BE6)
                            ),
                            onPressed: () async {
                              var url = Uri.parse(Glob.memberUrl + '/delete/restore/$_accountEmail');

                              Map<String, String> headers = {
                                'Content-Type': 'application/json',
                              };

                              http.Response response = await http.get(
                                url,
                                headers: headers,
                              );

                              bool result = json.decode(response.body);

                              if (result) {
                                _setKeyAndRoutePage(context, _accountEmail);
                              } else {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => BeforeRegistrationErrorPage()));
                              }
                            },
                          )
                        ],
                      ),
                    );
                  } else {
                    /// 여기까지 온 경우는 이미 가입된 회원이 로그인을 시도하는 경우임
                    /// 이미 가입된 회원이 로그인을 시도한다 = 기기가 변경되었다
                    return FutureBuilder(
                      future: _changedLoginInfo(_accountEmail),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData && snapshot.data.toString() == "true") {
                          final provider = getIt.get<TempSignal>();
                          return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    "로그인 정보가 변경되었어요.\n 버튼을 클릭하여 홈으로 이동해주세요!",
                                    style: Theme.of(context).textTheme.bodyText2,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                SizedBox(height: 10.0,),
                                TextButton(
                                  child: Text(
                                    "Home",
                                    style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: const Color(0xffFE9BE6),
                                    minimumSize: Size(MediaQuery.of(context).size.width * 0.5, 45)
                                  ),
                                  onPressed: () async {
                                    bool result = await _setKey(_accountEmail);
                                    if (result) {
                                      provider.setIsIntentional = true;
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
                                    } else {
                                      GlobalAlert().globErrorAlert(context);
                                    }
                                  },
                                )
                              ],
                            ),
                          );
                        } else if (snapshot.hasData && snapshot.data.toString() == "false") {
                          return Container(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                  child: Text(
                                    "알 수 없는 오류가 발생했어요.",
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    "앱을 종료 후 다시 시도해주세요.",
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                )
                              ],
                            ),
                          );
                        } else {
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
                        }
                      }
                    );
                  }
                }
            );
          } if (snapshot.connectionState == ConnectionState.waiting) {
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
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Error: ${snapshot.error}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            );
          } else {
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
          }
        },
      )
    );
  }
  void _setEmail(String email) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(Glob.email, email);
  }

  Future<bool> _setKey(String email) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('registration', true);
    pref.setString(Glob.email, email);

    var url = Uri.parse(Glob.memberUrl + '/$email');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    int memberSeq = int.parse(response.body);

    await pref.setInt(Glob.memberSeq, memberSeq);

    var coupleCodeUrl = Uri.parse(Glob.memberUrl + '/code/$memberSeq');

    Map<String, String> coupleCodeHeaders = {
      'Content-Type': 'application/json',
    };

    http.Response coupleCodeResponse = await http.get(
      coupleCodeUrl,
      headers: coupleCodeHeaders,
    );

    if (coupleCodeResponse.body.toString() != '' || coupleCodeResponse.body.toString() != 'null') {
      // 커플코드가 없을수도 있음
    } else {
      String coupleCode = jsonDecode(coupleCodeResponse.body).toString();
      await pref.setString(Glob.coupleCode, coupleCode);
    }

    if (pref.getInt(Glob.memberSeq) == null) {
      return false;
    } else {
      return true;
    }
  }

  _memberRegistrationCheck(String email) async {
    var url = Uri.parse(Glob.memberUrl + '/registration/check/$email');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    return jsonDecode(response.body);
  }

  _setKeyAndRoutePage(BuildContext context, String email) async {
    bool result = await _setKey(email);
    if (result) {
      provider.setIsIntentional = true;
      Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
    } else {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          '알 수 없는 오류',
          style: Theme.of(context).textTheme.bodyText2,
        ),
      );
    }
  }

  hasLoginApp() {
    return FutureBuilder(
      future: _setKey(_accountEmail.toString()),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
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
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Error: ${snapshot.error}',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          );
        } else if (snapshot.data) {
          return HasLoginApp();

        } else {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '알 수 없는 오류',
              style: Theme.of(context).textTheme.bodyText2,
            ),
          );
        }
      },
    );
  }

  Future<bool> _changedDeviceToken(String email) async {
    String? tokenData = await FirebaseMessaging.instance.getToken();
    if (tokenData == null) {
      return false;
    }

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

  _changedLoginInfo(String email) async {
    bool result = await _changedDeviceToken(email);
    return result;
  }
}
