import 'dart:convert';

import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/screens/home.dart';
import 'package:couple_signal/src/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../models/signal/temp_signal.dart';

String _coupleCode = '';
String _message = '';
String _hintText = '코드를 입력해주세요';
String _tempCoupleCode = '';

class CreateCouple extends StatefulWidget {
  const CreateCouple({Key? key}) : super(key: key);

  @override
  _CreateCoupleState createState() => _CreateCoupleState();
}

class _CreateCoupleState extends State<CreateCouple> {
  TextEditingController codeController = new TextEditingController();

  // Google admob
  final BannerAd myBanner = BannerAd(
    // 테스트 아이디
    // adUnitId: 'ca-app-pub-3940256099942544/6300978111',
    adUnitId: Glob.bannerAdUnitId,
    size: AdSize.banner,
    request: AdRequest(),
    listener: BannerAdListener(),
  );

  final BannerAdListener listener = BannerAdListener(
    // Called when an ad is successfully received.
    onAdLoaded: (Ad ad) => print('Ad loaded.'),
    // Called when an ad request failed.
    onAdFailedToLoad: (Ad ad, LoadAdError error) {
      // Dispose the ad here to free resources.
      ad.dispose();
      print('Ad failed to load: $error');
    },
    // Called when an ad opens an overlay that covers the screen.
    onAdOpened: (Ad ad) => print('Ad opened.'),
    // Called when an ad removes an overlay that covers the screen.
    onAdClosed: (Ad ad) => print('Ad closed.'),
    // Called when an impression occurs on the ad.
    onAdImpression: (Ad ad) => print('Ad impression.'),
  );

  @override
  void initState() {
    super.initState();
    myBanner.load();
  }

  @override
  Widget build(BuildContext context) {

    AdWidget adWidget = AdWidget(ad: myBanner);
    Container adContainer = Container(
      alignment: Alignment.center,
      child: adWidget,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '커플 연동',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(10),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.34,
                child: Card(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                          child: Text(
                            '전달받은 커플 코드를 입력해주세요!',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                        TextField(
                          controller: codeController,
                          textInputAction: TextInputAction.done,
                          style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 18.0),
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
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
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.width * 0.05, 3, MediaQuery.of(context).size.width * 0.05),
                          child: Text(
                            _message,
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        TextButton(
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
                            if (codeController.text != '') {
                              await _checkedCouple(context, codeController.text.toString());
                            } else {
                              String message = "코드를 입력해주세요.";
                              _failureAlertDialog(context, message);
                            }
                          },
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: adContainer,
              ),
            )
          ],
        ),
      ),
    );
  }

  _coupleRegistration(BuildContext context, coupleCode) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);
    /// pef 에 coupleCode 저장
    pref.setString(Glob.coupleCode, coupleCode);

    var url = Uri.parse(Glob.memberUrl + '/connect/couple');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var postData;

    postData = jsonEncode({
      "username": username.toString(),
      "coupleCode": coupleCode.toString(),
    });

    http.Response response = await http.post(
      url,
      headers: headers,
      body: postData,
    );

    String message = '';
    if (response.body.toString() == 'true') {
      GlobalAlert().onLoading(context);
      message = "커플 등록이 완료되었어요.";
    } else {
      GlobalAlert().onLoading(context);
      message = "알 수 없는 오류에요. \n잠시 후 다시 시도해주세요.";
    }
    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pop();
    await Future.delayed(Duration(seconds: 1));
    return _returnAlertDialog(context, message);
  }

  _checkedCouple(BuildContext context, String coupleCode) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/check/couple/$username/$coupleCode');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    String result = json.decode(response.body)['result'];
    String message = json.decode(response.body)['message'];

    if (result == 'choice') {
      _choiceAlertDialog(context, coupleCode);
    } else if (result == 'true') {
      _successAlertDialog(context, message, coupleCode);
    } else {
      _failureAlertDialog(context, message);
    }
  }

  _successAlertDialog(BuildContext context, String message, String coupleCode) async {
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        '커플 코드 등록',
        style: Theme.of(context).textTheme.bodyText1,
        textAlign: TextAlign.center,
      ),
      content: Text(
        message,
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
            await _coupleRegistration(context, coupleCode);
          },
        ),
        TextButton(
          child: Text(
            'Cancel',
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

  _failureAlertDialog(BuildContext context, String message) async {
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
        message,
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
  /// 여기 좀 더 세밀하게 할 필요 있을 듯 (메시지 라던가)
  _choiceAlertDialog(BuildContext context, String coupleCode) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "커플 코드 연동",
            style: Theme.of(context).textTheme.bodyText1,
          ),
        ),
        icon: Icon(
          FontAwesomeIcons.exclamationCircle,
          color: Colors.blue,
        ),
        onPressed: () {},
      ),
      content: Text(
        '등록 가능한 코드에요. \n현재 등록된 코드를 삭제하고 \n이 코드로 교체할까요?',
        style: Theme.of(context).textTheme.bodyText2,
      ),
      actions: [
        TextButton(
          child: Text(
            'OK',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: () async {
            /// 먼저 alert 닫고 함수 실행 후 해당 함수에서 확인 alert 를 다시 띄우는 방식으로
            Navigator.of(context).pop();
            await _coupleRegistration(context, coupleCode);
          },
        ),
        TextButton(
          child: Text(
            'Cancel',
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

  _returnAlertDialog(BuildContext context, String message) async {
    final provider = getIt.get<TempSignal>();
    AlertDialog alertDialog = AlertDialog(
      title: Text(
        '커플 코드 등록',
        style: Theme.of(context).textTheme.bodyText1,
        textAlign: TextAlign.center,
      ),
      content: Text(
        message,
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(routePage: 0)));
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
