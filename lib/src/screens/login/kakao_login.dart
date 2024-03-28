import 'dart:convert';
import 'dart:io';

import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/models/signal/temp_signal.dart';
import 'package:couple_signal/src/screens/error/before_registration_error.dart';
import 'package:couple_signal/src/screens/error/sign_in_apple_error.dart';
import 'package:couple_signal/src/screens/home.dart';
import 'package:couple_signal/src/screens/signup/signup_nickname.dart';
import 'package:couple_signal/src/screens/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_auth.dart';
import 'package:kakao_flutter_sdk_auth/kakao_flutter_sdk_auth.dart';
// import 'package:kakao_flutter_sdk/all.dart';
// import 'package:kakao_flutter_sdk/auth.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../models/global/global_variable.dart';
import 'kakao_result.dart';

class KakaoLogin extends StatefulWidget {
  const KakaoLogin({Key? key}) : super(key: key);

  @override
  _KakaoLoginState createState() => _KakaoLoginState();
}

class _KakaoLoginState extends State<KakaoLogin> {
  bool _isKakaoTalkInstalled = false;

  @override
  void initState() {
    super.initState();
    _initKakaoTalkInstalled();
  }

  _initKakaoTalkInstalled() async {
    final installed = await isKakaoTalkInstalled();
    setState(() {
      _isKakaoTalkInstalled = installed;
    });
  }

  _issueAccessToken(String authCode) async {
    try {
      var token = await AuthApi.instance.issueAccessToken(authCode: authCode);
      TokenManagerProvider.instance.manager.setToken(token);
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginResult(),));
    } catch(e) {
      print(e.toString());
    }
  }

  _loginWithKakao() async {
    try {
      var code = await AuthCodeClient.instance.authorize();
      await _issueAccessToken(code);
    } catch (e) {
      print(e.toString());
    }
  }

  _loginWithTalk() async {
    try {

      var code = await AuthCodeClient.instance.authorizeWithTalk();
      await _issueAccessToken(code);
    } catch (e) {
      print(e.toString());
    }
  }

  _bottomSheet() {
    return Container(
      height: 40,
      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
      alignment: FractionalOffset.bottomCenter,
      child: Text(
        '기존 가입 회원은 인증 후 자동 로그인됩니다.',
        style: Theme.of(context).textTheme.bodyText2
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0.0,
        leading: Container(),
      ),
      bottomSheet: _bottomSheet(),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Image.asset(
                'images/heartnal_bi.png',
                height: MediaQuery.of(context).size.height * 0.07,
                fit: BoxFit.contain,
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                child: Text(
                  '하트널을 간편하게 시작해보세요!',
                  style: Theme.of(context).textTheme.bodyText2,
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.07,),
            Center(
              child: InkWell(
                onTap: () => _isKakaoTalkInstalled ? _loginWithTalk() : _loginWithKakao(),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: MediaQuery.of(context).size.height * 0.07,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.yellow
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 2, 5, 4),
                        child: const Icon(FontAwesomeIcons.solidComment, color: const Color(0xff3C1E1E),),
                      ),
                      const SizedBox(width: 10,),
                      Text(
                        '카카오로 시작하기',
                        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: const Color(0xff3C1E1E), fontSize: 20.0, fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: (Platform.isIOS) ? 10.0 : 0.0,),
            (Platform.isIOS) ? Padding(
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.1),
              child: SignInWithAppleButton(
                text: "Apple로 시작하기",
                height: MediaQuery.of(context).size.height * 0.07,
                onPressed: () async {
                  String email = "";
                  bool loginAvailable = await SignInWithApple.isAvailable();

                  if (loginAvailable) {
                    final credential = await SignInWithApple.getAppleIDCredential(
                      scopes: [
                        AppleIDAuthorizationScopes.email,
                      ],
                    );
                    final provider = getIt.get<TempSignal>();
                    if (credential.email.toString() == "" || credential.email.toString() == "null") {
                      String emailCheck = await _getIosMember(credential.userIdentifier.toString());

                      if (emailCheck == "not found") {
                        email = credential.userIdentifier.toString();
                        _iosMemberRegistration(credential.userIdentifier.toString());
                        String checkResult = await _memberRegistrationCheck(email);

                        switch (checkResult) {
                          case 'UNSUBSCRIBED':
                            _setAppleEmail(email);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignupNickName()));
                            break;
                          case 'INACTIVE':
                          /// 휴면 회원 해제 로직 필요
                            break;
                          case 'WITHDRAWAL':
                            restoreMember(context, email);
                            break;
                          default:
                            bool result = await _changedLoginInfo(email);
                            if (result) {
                              provider.setIsIntentional = true;
                              await _setKey(email);
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
                            } else {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => SignInAppleErrorPage()));
                            }
                            break;
                        }
                      } else {
                        email = emailCheck;
                        _iosMemberRegistration(credential.userIdentifier.toString());
                        bool result = await _changedLoginInfo(email);
                        if (result) {
                          provider.setIsIntentional = true;
                          await _setKey(email);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignInAppleErrorPage()));
                        }
                      }
                    } else {
                      email = credential.email.toString();
                      _iosMemberRegistration(credential.userIdentifier.toString());
                      String checkResult = await _memberRegistrationCheck(email);
                      switch (checkResult) {
                        case 'UNSUBSCRIBED':
                          _setAppleEmail(email);
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignupNickName()));
                          break;
                        case 'INACTIVE':
                        /// 휴면 회원 해제 로직 필요
                          break;
                        case 'WITHDRAWAL':
                          restoreMember(context, email);
                          break;
                        default:
                          bool result = await _changedLoginInfo(email);
                          if (result) {
                            provider.setIsIntentional = true;
                            await _setKey(email);
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
                          } else {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => SignInAppleErrorPage()));
                          }
                          break;
                      }
                    }
                  }
                },
              ),
            ) :
                SizedBox()
          ],
        ),
      ),
    );
  }
  Future<UserCredential> signInWithApple() async {
    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );
    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  }

  appleLoginError(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "오류 발생",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.circleExclamation,
          color: Colors.red,
        ),
        onPressed: () {},
      ),
      content: Text(
        '알 수 없는 오류가 발생했어요.\n앱을 삭제 후 다시 시도해주세요.',
        style: Theme.of(context).textTheme.bodyText2,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          child: Text(
            '확인',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        }
    );
  }

  _setAppleEmail(String email) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setString(Glob.email, email);
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

  _iosMemberRegistration(String identifier) async {
    SharedPreferences pref = await SharedPreferences.getInstance();

    pref.setString(Glob.identifier, identifier);

    if (pref.getString(Glob.identifier) != null) {
      return true;
    } else {
      return false;
    }
  }

  _getIosMember(String identifier) async {
    var url = Uri.parse(Glob.memberUrl + '/ios/$identifier');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    return jsonDecode(response.body);
  }

  restoreMember(BuildContext context, String email) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "회원 복구",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.circleExclamation,
          color: Colors.blue,
        ),
        onPressed: () {},
      ),
      content: Text(
        '탈퇴 후 30일 미만 계정이에요.\n복구하시겠어요?',
        style: Theme.of(context).textTheme.bodyText2,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          child: Text(
            '복구',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: () async {
            var url = Uri.parse(Glob.memberUrl + '/delete/restore/$email');

            Map<String, String> headers = {
              'Content-Type': 'application/json',
            };

            http.Response response = await http.get(
              url,
              headers: headers,
            );

            bool result = json.decode(response.body);

            if (result) {
              await _setKey(email);
              await _setKeyAndRoutePage(context, email);
            } else {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BeforeRegistrationErrorPage()));
            }
          },
        ),
        TextButton(
          child: Text(
            '취소',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        }
    );
  }

  _setKeyAndRoutePage(BuildContext context, String email) async {
    bool result = await _setAppleEmail(email);
    if (result) {
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(routePage: 0,)));
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

    String coupleCode = jsonDecode(coupleCodeResponse.body).toString();

    await pref.setString(Glob.coupleCode, coupleCode);

    if (pref.getInt(Glob.memberSeq) == null || pref.getString(Glob.coupleCode) == null) {
      return false;
    } else {
      return true;
    }
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

  changeDeviceAlert(BuildContext context, String email) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "로그인 정보 변경",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.circleExclamation,
          color: Colors.blue,
        ),
        onPressed: () {},
      ),
      content: Text(
        '로그인 정보가 변경되었어요.\n확인을 눌러 홈으로 이동해주세요.',
        style: Theme.of(context).textTheme.bodyText2,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          child: Text(
            '확인',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: () async {
            Navigator.of(context).pop();
            bool result = await _setAppleEmail(email);
            if (result) {
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(routePage: 0,)));
            } else {
              GlobalAlert().globErrorAlert(context);
            }
          },
        ),
      ],
    );
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog;
        }
    );
  }
}
