import 'dart:convert';

import 'package:couple_signal/src/models/code/couple_code_dto.dart';
import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

String _coupleCode = '';
String _message = '커플 코드 생성을 클릭해주세요!';

class CreateCoupleCode extends StatefulWidget {
  const CreateCoupleCode({Key? key}) : super(key: key);

  @override
  _CreateCoupleCodeState createState() => _CreateCoupleCodeState();
}

class _CreateCoupleCodeState extends State<CreateCoupleCode> {
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
    // TODO: implement initState
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
          '커플 코드 생성하기',
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
                height: MediaQuery.of(context).size.height * 0.20,
                child: Card(
                  margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
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
                                padding: const EdgeInsets.fromLTRB(0, 25, 0, 20),
                                child: Text(
                                  _message,
                                  style: Theme.of(context).textTheme.bodyText2,
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
                                        '복사되었어요.',
                                        style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                                        textAlign: TextAlign.center,
                                      ))
                                    ));
                                  },
                                ) : Text('')
                            )
                          ],
                        ),
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
  _createCode(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/code');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
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
    });
  }
}
