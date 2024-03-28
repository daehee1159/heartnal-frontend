import 'dart:convert';

import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/screens/signup/getting_started_screen.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DeleteAccount extends StatefulWidget {
  const DeleteAccount({Key? key}) : super(key: key);

  @override
  _DeleteAccountState createState() => _DeleteAccountState();
}

class _DeleteAccountState extends State<DeleteAccount> {
  TextEditingController _textController = new TextEditingController();

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
    _textController = new TextEditingController();
    myBanner.load();
  }

  @override
  void dispose() {
    super.dispose();
    _textController.dispose();
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
          '회원 탈퇴',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      body: GestureDetector(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
                  child: Text(
                    '더 나은 서비스를 위해 탈퇴 사유를 기재해주세요.',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                Card(
                  elevation: 4.0,
                  color: Colors.white,
                  margin: const EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _textController,
                      maxLines: 10,
                      style: Theme.of(context).textTheme.bodyText2,
                      decoration: InputDecoration.collapsed(
                        hintText: '탈퇴 사유를 입력해주세요.',
                        hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                TextButton(
                  child: Text(
                    '탈퇴하기',
                    style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                    backgroundColor: const Color(0xffFE9BE6),
                  ),
                  onPressed: () async {
                    if (_textController.text == '') {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: TextButton.icon(
                              label: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: Text(
                                  "사유 미입력",
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
                              '탈퇴 사유를 입력해주세요!',
                              style: Theme.of(context).textTheme.bodyText2,
                              textAlign: TextAlign.center,
                            ),
                            actions: [
                              TextButton(
                                child: Text(
                                  'OK',
                                  style: Theme.of(context).textTheme.bodyText2,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                }
                              ),
                            ],
                          ));
                    } else {
                      GlobalAlert().onLoading(context);
                      bool result= await _deleteAccount(_textController.text);
                      if (result) {
                        await Future.delayed(Duration(seconds: 2));
                        /// 탈퇴 API 성공 시 기존에 pref에 저장된 내용들 지워줘야함
                        _deletePref();
                        Navigator.of(context).pop();
                        _alertDialog(context);
                      } else {
                        Navigator.of(context).pop();
                        GlobalAlert().globErrorAlert(context);
                      }
                    }
                  },
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.40,),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: adContainer,
                )
              ],
            ),
          ),
        ),
        onTap: () {
          FocusScope.of(context).unfocus();
        },
      ),
    );
  }

  Future<bool> _deleteAccount(reasonMessage) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/delete/account');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var saveData;

    saveData = jsonEncode({
      "username": username.toString(),
      "reasonMessage": reasonMessage.toString()
    });

    http.Response response = await http.post(
        url,
        headers: headers,
        body: saveData
    );

    return jsonDecode(response.body);
  }

  _deletePref() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove(Glob.email);
    pref.remove(Glob.coupleCode);
    pref.remove(Glob.memberSeq);
    pref.remove(Glob.accessToken);
    pref.remove(Glob.refreshToken);
    pref.remove(Glob.nickName);
    pref.remove(Glob.coupleRegDt);
  }

  _alertDialog(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "탈퇴 성공",
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
        '탈퇴가 완료되었어요.\n탈퇴 이후에는 앱 사용에\n제한이 있을 수 있어요.',
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => GettingStartedScreen()));
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
