import 'dart:convert';

import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/info/couple_info_dto.dart';
import 'package:couple_signal/src/models/info/my_profile_info.dart';
import 'package:couple_signal/src/screens/home.dart';
import 'package:couple_signal/src/screens/settings/create_couple_code.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

String _coupleNickName = '';
String _coupleCode = '';
String _coupleRegDt = '';

class DisconnectCouple extends StatefulWidget {
  const DisconnectCouple({Key? key}) : super(key: key);

  @override
  _DisconnectCoupleState createState() => _DisconnectCoupleState();
}

class _DisconnectCoupleState extends State<DisconnectCouple> {
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
          '커플 연동 해제',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      body: FutureBuilder(
        future: _getMyCoupleData(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData == false) {
            return CircularProgressIndicator();
          }
          else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Error: ${snapshot.error}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            );
          }
          else {
            return Container(
              child: Column(
                children: [
                  Card(
                    elevation: 4.0,
                    margin: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 0.0),
                          child: Text(
                            '커플 정보',
                            style: Theme.of(context).textTheme.bodyText2
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.person, color: const Color(0xff5D5D5D),),
                          title: Text(
                            "연결된 커플 닉네임",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          trailing: Text(
                            (_coupleNickName == 'null') ? '미등록' : _coupleNickName,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          onTap: () {},
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: const Icon(Icons.person, color: const Color(0xff5D5D5D),),
                          title: Text(
                            "커플 코드",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          trailing: Text(
                            (_coupleCode == "null") ? "미등록" : _coupleCode,
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          onTap: () {},
                        ),
                        _buildDivider(),
                        ListTile(
                          leading: const Icon(Icons.calendar_today, color: const Color(0xff5D5D5D),),
                          title: Text(
                            "사귄 날짜",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          trailing: Text(
                            (_coupleRegDt == 'null') ? '미등록' : _coupleRegDt.substring(0, 10),
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20.0,),
                  (_coupleNickName == "null" && _coupleCode == "null" && _coupleRegDt == "null") ?
                      Column(
                        children: [
                          Text(
                            "커플 미등록 상태에요.",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          SizedBox(height: 5.0,),
                          Text(
                            "커플 등록을 먼저 진행해주세요!",
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                          SizedBox(height: 5.0,),
                          TextButton(
                            child: Text(
                              '커플 등록',
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),),
                            style: TextButton.styleFrom(
                                primary: Colors.white,
                                backgroundColor: const Color(0xffFE9BE6),
                                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0)
                            ),
                            onPressed: () async {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => CreateCoupleCode()));
                            },
                          )
                        ],
                      ) :
                  TextButton(
                    child: Text(
                      '커플 해제',
                      style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),),
                    style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: const Color(0xffFE9BE6),
                        padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0)
                    ),
                    onPressed: () async {
                      _alertDialog(context);
                    },
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: Stack(
                        children: [
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: adContainer,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.0,)
                ],
              ),
            );
          }
        },
      )
    );
  }
  Container _buildDivider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }

  _getMyCoupleData() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/couple/info/$username');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
        url,
        headers: headers,
    );

    if (response.body == "") {
      CoupleInfoDto coupleInfoDto = new CoupleInfoDto("null", "null", "null");
      _coupleNickName = coupleInfoDto.coupleNickName.toString();
      _coupleCode = coupleInfoDto.coupleCode.toString();
      _coupleRegDt = coupleInfoDto.coupleRegDt.toString();

      return coupleInfoDto;
    } else {
      CoupleInfoDto coupleInfoDto = CoupleInfoDto.fromJson(jsonDecode(response.body));
      if (coupleInfoDto.coupleNickName == null) {
        coupleInfoDto.coupleNickName = 'null';
      }

      if (coupleInfoDto.coupleCode == null) {
        coupleInfoDto.coupleCode = 'null';
      }

      if (coupleInfoDto.coupleRegDt == null) {
        coupleInfoDto.coupleRegDt = 'null';
      }
      _coupleNickName = coupleInfoDto.coupleNickName.toString();
      _coupleCode = coupleInfoDto.coupleCode.toString();
      _coupleRegDt = coupleInfoDto.coupleRegDt.toString();
      return coupleInfoDto;
    }
  }

  _alertDialog(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "커플 연동 해제",
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
        '커플 연동 해제 시\n상대와의 모든 데이터가 사라져요.\n그래도 해제할까요?',
        style: Theme.of(context).textTheme.bodyText2,
        textAlign: TextAlign.center,
      ),
      actions: [
        TextButton(
          child: Text(
            '해제',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: () async {
            GlobalAlert().onLoading(context);
            MyProfileInfo _myProfileInfo = Provider.of<MyProfileInfo>(context, listen: false);
            bool result = await _myProfileInfo.disconnectCouple();
            if (result) {
              await Future.delayed(Duration(seconds: 2));
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(routePage: 0,)));
            } else {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              GlobalAlert().globErrorAlert(context);
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
}

