import 'dart:convert';
import 'dart:io';

import 'package:couple_signal/src/models/code/couple_code_dto.dart';
import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/signal/temp_signal.dart';
import 'package:couple_signal/src/screens/error/before_registration_error.dart';
import 'package:couple_signal/src/screens/splash_screen.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../home.dart';

String _coupleCode = '';
String _message = '';
String _hintText = '코드를 입력해주세요';
String _tempCoupleCode = '';

class SignupCodeInput extends StatefulWidget {
  const SignupCodeInput({Key? key}) : super(key: key);

  @override
  _SignupCodeInput createState() => _SignupCodeInput();
}

class _SignupCodeInput extends State<SignupCodeInput> {
  @override
  Widget build(BuildContext context) {
    final provider = getIt.get<TempSignal>();
    TextEditingController codeController = new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20,),
              width: double.infinity,
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: viewportConstraints.maxHeight,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Image.asset(
                        'images/heartnal_bi.png',
                        height: MediaQuery.of(context).size.height * 0.07,
                        // color: const Color(0xffFE9BE6),
                        fit: BoxFit.contain,
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                      Text(
                        '이미 상대방에게 코드를 받으셨나요?',
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                        child: Text(
                          '전달받은 커플 코드를 입력해주세요!',
                          style: Theme.of(context).textTheme.bodyText1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: TextField(
                              controller: codeController,
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 18.0),
                              onChanged: (text) {
                                /// coupleCode를 생성한 후 전달받은 코드를 입력하려고 하면 기존에 생성했던 코드를 없애주기 위해 처리
                                if (_coupleCode != "" && text != "") {
                                  _coupleCode = "";
                                }
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white70,
                                hintText: _hintText,
                                hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                                contentPadding: const EdgeInsets.all(15),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: TextButton(
                              child: Text(
                                '연결하기',
                                style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                              ),
                              style: TextButton.styleFrom(
                                  backgroundColor: const Color(0xffFE9BE6),
                                  primary: Colors.white,
                                  padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0)
                              ),
                              onPressed: () async {
                                if (codeController.text.toString() != '') {
                                  bool result = false;
                                  await _checkedCoupleCode(codeController.text.toString()).then((value) => result = value);
                                  if (result) {
                                    /// 사용 가능한 코드인 경우
                                    setState(() {
                                      _coupleCode = codeController.text.toString();
                                      /// result == true 는 이미 생성한 1명만 사용중인 코드이므로 tempCoupleCode 에 넣어둬서 이후 가입 시 _coupleCode 와 같다면 deviceToken 저장해야함
                                      _tempCoupleCode = codeController.text.toString();
                                      _message = '';
                                      _hintText = _coupleCode;
                                    });
                                    _successAlertDialog(context);
                                  } else {
                                    /// 존재하는 코드이지만 다른 사람이 이미 사용하고 있는 코드인 경우
                                    _alertDialog(context);
                                    setState(() {
                                      _coupleCode = '';
                                      _message = '';
                                      _hintText = '코드를 입력해주세요';
                                    });
                                  }
                                } else {
                                  /// 없는 코드를 넣었기 때문에 초기화
                                  _alertDialog(context);
                                  setState(() {
                                    _coupleCode = '';
                                    _message = '';
                                    _hintText = '코드를 입력해주세요';
                                  });
                                }
                              },
                            ),
                          ),
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
              ),
            );
          }
      )
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

  Future<bool> _checkedCoupleCode(String coupleCode) async {
    var url = Uri.parse(Glob.memberUrl + '/check/code/$coupleCode');
    Map<String, String> headers = {
      'Content-Type': 'application/json'
    };

    http.Response response = await http.get(
        url,
        headers: headers,
    );
    return jsonDecode(response.body) ? true : false;
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
          FontAwesomeIcons.circleExclamation,
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

  _alertDialog(BuildContext context) async {
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
          FontAwesomeIcons.circleExclamation,
          color: Colors.red,
        ),
        onPressed: () {},
      ),
      content: Text(
        '정확한 코드를 입력해주세요.',
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

  _successAlertDialog(BuildContext context) async {
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
        '유효한 코드에요.\n하단의 완료버튼을 눌러주세요!',
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
}
