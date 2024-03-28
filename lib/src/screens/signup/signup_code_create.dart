import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../models/code/couple_code_dto.dart';
import '../../models/global/global_variable.dart';
import '../../models/signal/temp_signal.dart';
import '../error/before_registration_error.dart';
import '../home.dart';
import '../splash_screen.dart';

String _coupleCode = '';
String _message = '';
String _hintText = '코드를 입력해주세요';
String _tempCoupleCode = '';

class SignupCodeCreate extends StatefulWidget {
  const SignupCodeCreate({Key? key}) : super(key: key);

  @override
  State<SignupCodeCreate> createState() => _SignupCodeCreateState();
}

class _SignupCodeCreateState extends State<SignupCodeCreate> {
  final provider = getIt.get<TempSignal>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20,),
            width: double.infinity,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    'images/heartnal_bi.png',
                    height: MediaQuery.of(context).size.height * 0.07,
                    // color: const Color(0xffFE9BE6),
                    fit: BoxFit.contain,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                  Text(
                    '커플 코드를 생성해주세요!',
                    style: Theme.of(context).textTheme.bodyText1,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Center(
                          child: _coupleCode == '' ? Text('') : Text(_coupleCode, style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 18.0),),
                        )
                      ),
                      Expanded(
                        flex: 2,
                        child: TextButton(
                          child: Text(
                            '커플 코드 생성',
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                          ),
                          style: TextButton.styleFrom(
                              backgroundColor: const Color(0xffFE9BE6)
                          ),
                          onPressed: () {
                            _createCode(context);
                          },
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 20, 3, 20),
                          child: Text(
                            _message,
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: (_message != '') ? IconButton(
                          icon: Icon(
                            FontAwesomeIcons.copy
                          ),
                          color: const Color(0xffFE9BE6),
                          onPressed: () {
                            /// 복사하기 함수
                            Clipboard.setData(ClipboardData(text: _coupleCode)).then((value) => ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(
                                '복사되었어요!',
                                style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                                textAlign: TextAlign.center,
                              ))
                            ));
                          },
                        ) : Text('')
                      )
                    ],
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.09,),
                  TextButton(
                    child: Text(
                      '완료',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                    ),
                    style: TextButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                      padding: const EdgeInsets.all(15),
                      backgroundColor: const Color(0xffFE9BE6),
                    ),
                    onPressed: () async {
                      if (_coupleCode == '') {
                        _completeAlertDialog(context);
                      } else {
                        var response;
                        /// 회원가입
                        response = await _memberRegistration(_coupleCode, Platform.isIOS ? "iOS" : "android");
                        if (response == "false") {
                          /// 오류 발생 시
                          Navigator.push(context, MaterialPageRoute(builder: (context) => BeforeRegistrationErrorPage()));
                        } else {
                          await _registrationCheck(int.parse(response));
                          provider.setIsIntentional = true;
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SplashScreen()));
                        }
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        }
      ),
    );
  }

  _createCode(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);

    var url = Uri.parse(Glob.memberUrl + '/code');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var saveData;

    saveData = jsonEncode({
      "username": username.toString(),
    });

    http.Response response = await http.post(
        url,
        headers: headers,
        body: saveData
    );

    CoupleCodeDto coupleCodeDto = CoupleCodeDto.fromJson(jsonDecode(response.body));

    setState(() {
      _coupleCode = coupleCodeDto.coupleCode.toString();
      _message = coupleCodeDto.message.toString();
      _successCodeAlertDialog(context);
    });
  }

  _successCodeAlertDialog(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "코드 확인",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.circleCheck,
          color: Colors.blue,
        ),
        onPressed: () {},
      ),
      content: Text(
        '하단의 완료 버튼을 클릭 후\n상대방에게 코드를 전달해주세요!',
        style: Theme.of(context).textTheme.bodyText2,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          child: Text(
            'OK',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: () async {
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

  _completeAlertDialog(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "커플 연동 실패",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.exclamationCircle,
          color: Colors.red,
        ),
        onPressed: () {},
      ),
      content: Text(
        '커플 코드를 생성하거나\n 전달받은 코드를 입력해주세요.',
        style: Theme.of(context).textTheme.bodyText2,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          child: Text(
            'OK',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: () async {
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

  Future<String> _memberRegistration(String coupleCode, String platform) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String username = pref.getString(Glob.email).toString();
    String nickName = pref.getString(Glob.nickName).toString();
    String coupleRegDt = pref.getString(Glob.coupleRegDt).toString();

    /// 만약 특수한 상황에 의해 username, nickName, coupleRegDt 데이터중 하나라도 pref에 제대로 저장에 실패했다면 다시 처음 화면으로 돌리기
    if ((pref.getString(Glob.email) == null || pref.getString(Glob.email).toString() == "") || (pref.getString(Glob.nickName) == null || pref.getString(Glob.nickName).toString() == "") || (pref.getString(Glob.coupleRegDt) == null || pref.getString(Glob.coupleRegDt).toString() == "")) {
      return "false";
    }

    /// pref 에 coupleCode 저장
    pref.setString(Glob.coupleCode, coupleCode);

    /// iOS 멤버의 경우 따로 iOS 테이블에 identifier + email 저장해야함
    if (platform == "iOS") {
      String identifier = pref.getString(Glob.identifier).toString();

      var url = Uri.parse(Glob.memberUrl + '/ios');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      var postData = jsonEncode({
        "identifier": identifier,
        "email": username
      });

      http.Response response = await http.post(
          url,
          headers: headers,
          body: postData
      );

      bool result = jsonDecode(response.body);

      if (result.toString() == "false") {
        return "false";
      }
    }

    var url = Uri.parse(Glob.memberUrl);

    String? myDeviceToken;

    await FirebaseMessaging.instance.getToken().then((value) {
      myDeviceToken = value;
    });

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    final saveData;

    if (coupleCode == _tempCoupleCode) {
      saveData = jsonEncode({
        "email": username.toString(),
        "nickName": nickName.toString(),
        "coupleRegDt": coupleRegDt,
        "coupleCode": coupleCode,
        "myDeviceToken": myDeviceToken,
        "coupleDeviceToken": 'true',
      });
    } else {
      saveData = jsonEncode({
        "email": username.toString(),
        "nickName": nickName.toString(),
        "coupleRegDt": coupleRegDt,
        "coupleCode": coupleCode,
        "myDeviceToken": myDeviceToken,
        "coupleDeviceToken": 'false',
      });
    }

    http.Response response = await http.post(
        url,
        headers: headers,
        body: saveData
    );

    if (response.statusCode == 200) {
      if (response.body.toString() == "false") {
        return "false";
      } else {
        return response.body;
      }
    } else {
      return "false";
    }
  }

  // 회원가입 완료 여부 저장
  _registrationCheck(int memberSeq) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var key = 'registration';
    bool value = true;
    pref.setBool(key, value);
    pref.setInt(Glob.memberSeq, memberSeq);

    // 가입 시 해당 device token 저장
    FirebaseMessaging.instance.getToken().then((value) {
      String? token = value;

      if (token == null) {
      }

      bool setDevice = true;
      pref.setString("deviceToken", token!);
      pref.setBool("setDevice", setDevice);
    });
  }
}
