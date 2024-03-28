import 'dart:convert';
import 'dart:ui';

import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/info/my_profile_info.dart';
import 'package:couple_signal/src/models/signal/couple_unresolved_signal_dto.dart';
import 'package:couple_signal/src/screens/signal/record/signal_record_page.dart';
import 'package:couple_signal/src/screens/signal/started_signal.dart';
import 'package:couple_signal/src/screens/signal/unresolved/signal_progress.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../models/signal/message/message_of_the_day.dart';
import '../../models/signal/message/message_of_the_day_dto.dart';
import '../../models/signal/today/today_signal.dart';

Map<String, dynamic> myTurnData = new Map<String, dynamic>();
List<MessageOfTheDayDto>? messageOfTheDayDtoList;

class TabBarThird extends StatefulWidget {
  const TabBarThird({Key? key}) : super(key: key);

  @override
  _TabBarThirdState createState() => _TabBarThirdState();
}

class _TabBarThirdState extends State<TabBarThird> {
  bool isSized1700 = window.physicalSize.height > 1700;
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
    MyProfileInfo _myProfileInfo = Provider.of<MyProfileInfo>(context, listen: false);

    AdWidget adWidget = AdWidget(ad: myBanner);
    Container adContainer = Container(
      alignment: Alignment.center,
      child: adWidget,
      width: myBanner.size.width.toDouble(),
      height: myBanner.size.height.toDouble(),
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Column(
              children: [
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: isSized1700 ? MediaQuery.of(context).size.height * 0.23 : MediaQuery.of(context).size.height * 0.22,
                      child: Card(
                        elevation: 4.0,
                        child: Container(
                          color: const Color(0xffFFF1F5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text: '하트',
                                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: const Color(0xffFE9BE6)),
                                      ),
                                      TextSpan(
                                        text: '를 클릭해서 언제 어디서든',
                                        style: Theme.of(context).textTheme.bodyText1,
                                      ),
                                    ]
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                child: RichText(
                                  text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '당신의 연인에게 ',
                                          style: Theme.of(context).textTheme.bodyText1,
                                        ),
                                        TextSpan(
                                          text: '시그널',
                                          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: const Color(0xffFE9BE6)),
                                        ),
                                        TextSpan(
                                          text: '을 보내세요',
                                          style: Theme.of(context).textTheme.bodyText1,
                                        ),
                                      ]
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: isSized1700 ? MediaQuery.of(context).size.height * 0.23 : MediaQuery.of(context).size.height * 0.22,
                      child: Card(
                          elevation: 4.0,
                          child: InkWell(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        flex: 2,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  Text(
                                                    '시그널 보내기',
                                                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 24),
                                                  ),
                                                  const Icon(
                                                    Icons.keyboard_arrow_right,
                                                    color: Colors.black,
                                                    size: 30,
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                child: Text(
                                                  '하트를 클릭해보세요.',
                                                  style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Center(
                                              child: Column(
                                                children: [
                                                  IconButton(
                                                    padding: const EdgeInsets.fromLTRB(0, 0, 30, 10),
                                                    onPressed: () async {
                                                      bool result = await _myProfileInfo.isCheckCoupleConnect();
                                                      if (result) {
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => StartSignal()));
                                                      } else {
                                                        _alertDialog(context);
                                                      }
                                                    },
                                                    icon: SizedBox(
                                                      width: MediaQuery.of(context).size.width * 0.3,
                                                      height: MediaQuery.of(context).size.height * 0.25,
                                                      child: OverflowBox(
                                                        minHeight: MediaQuery.of(context).size.height * 0.12,
                                                        maxHeight: MediaQuery.of(context).size.height * 0.12,
                                                        minWidth: MediaQuery.of(context).size.width * 0.3,
                                                        maxWidth: MediaQuery.of(context).size.width * 0.3,
                                                        child: Lottie.asset(
                                                          'images/json/icon/icon_signal.json',
                                                          width: MediaQuery.of(context).size.width * 0.3,
                                                          height: MediaQuery.of(context).size.height * 0.12
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        )
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            onTap: () async {
                              bool result = await _myProfileInfo.isCheckCoupleConnect();
                              if (result) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => StartSignal()));
                              } else {
                                _alertDialog(context);
                              }
                            },
                          )
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: isSized1700 ? MediaQuery.of(context).size.height * 0.23 : MediaQuery.of(context).size.height * 0.22,
                      child: Card(
                          elevation: 4.0,
                          child: InkWell(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      '시그널 현황보기',
                                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 24),
                                                    ),
                                                    const Icon(
                                                      Icons.keyboard_arrow_right,
                                                      color: Colors.black,
                                                      size: 30,
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                  child: Text(
                                                    '진행중인 시그널을',
                                                    style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                  child: Text(
                                                    '확인해보세요.',
                                                    style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: Column(
                                                  children: [
                                                    IconButton(
                                                      padding: const EdgeInsets.fromLTRB(0, 0, 10, 20),
                                                      onPressed: () async {
                                                        await _coupleUnResolvedSignal(context);
                                                      },
                                                      icon: SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.3,
                                                        height: MediaQuery.of(context).size.height * 0.12,
                                                        child: OverflowBox(
                                                          minHeight: MediaQuery.of(context).size.height * 0.12,
                                                          maxHeight: MediaQuery.of(context).size.height * 0.12,
                                                          minWidth: MediaQuery.of(context).size.width * 0.3,
                                                          maxWidth: MediaQuery.of(context).size.width * 0.3,
                                                          child: Lottie.asset(
                                                            'images/json/icon/icon_signal_status.json',
                                                            width: MediaQuery.of(context).size.width * 0.3,
                                                            height: MediaQuery.of(context).size.height * 0.12
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          )
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            onTap: () async {
                              await _coupleUnResolvedSignal(context);
                            },
                          )
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: isSized1700 ? MediaQuery.of(context).size.height * 0.23 : MediaQuery.of(context).size.height * 0.22,
                      child: Card(
                          elevation: 4.0,
                          child: InkWell(
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                          flex: 2,
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      '시그널 이력보기',
                                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 24),
                                                    ),
                                                    const Icon(
                                                      Icons.keyboard_arrow_right,
                                                      color: Colors.black,
                                                      size: 30,
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                  child: Text(
                                                    '시그널 확률 및 통계를',
                                                    style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                                  child: Text(
                                                    '확인해보세요.',
                                                    style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                child: IconButton(
                                                  padding: EdgeInsets.fromLTRB(0, 20, 20, 30),
                                                  onPressed: () async {
                                                    bool result = await _myProfileInfo.isCheckCoupleConnect();
                                                    if (result) {
                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => SignalRecordPage()));
                                                    } else {
                                                      _alertDialog(context);
                                                    }
                                                  },
                                                  icon: SizedBox(
                                                    width: MediaQuery.of(context).size.width * 0.5,
                                                    height: MediaQuery.of(context).size.height * 0.18,
                                                    child: OverflowBox(
                                                      minHeight: MediaQuery.of(context).size.height * 0.18,
                                                      maxHeight: MediaQuery.of(context).size.height * 0.18,
                                                      minWidth: MediaQuery.of(context).size.width * 0.5,
                                                      maxWidth: MediaQuery.of(context).size.width * 0.5,
                                                      child: Lottie.asset(
                                                        'images/json/icon/icon_signal_record.json',
                                                        width: MediaQuery.of(context).size.width * 0.5,
                                                        height: MediaQuery.of(context).size.height * 0.18
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                            onTap: () async {
                              bool result = await _myProfileInfo.isCheckCoupleConnect();
                              if (result) {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SignalRecordPage()));
                              } else {
                                _alertDialog(context);
                              }
                            },
                          )
                      ),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.010,),
                /// 광고
                SizedBox(
                  height: 50,
                  child: adContainer
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  _alertDialog(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "커플 미연동 회원",
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
        '커플 연동 후 \n시그널 보내기가 가능해요.',
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

  _coupleUnResolvedSignal(BuildContext context) async {
    MessageOfTheDay _messageOfTheDay = Provider.of<MessageOfTheDay>(context, listen: false);
    TodaySignal _todaySignal = Provider.of<TodaySignal>(context, listen: false);
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accessToken = pref.getString(Glob.accessToken);
    String coupleCode = pref.getString(Glob.coupleCode).toString();
    int memberSeq = int.parse(pref.getInt(Glob.memberSeq).toString());

    int messageOfTheDaySeq = 0;
    messageOfTheDayDtoList = await _messageOfTheDay.getTodayMessageOfTheDay();
    if (messageOfTheDayDtoList == null || messageOfTheDayDtoList?.length == 0) {
      // 리스트가 null 이면 진행중인 오늘의 한마디가 없으므로 0
      messageOfTheDaySeq = 0;
    } else {
      // 리스트가 null 이 아니면 진행중인 오늘의 한마디가 있으므로 1
      messageOfTheDaySeq = 1;
    }

    myTurnData = await _todaySignal.getIsMyTurn();
    int _todaySignalSeq = int.parse(myTurnData['todaySignalSeq'].toString());

    var url = Uri.parse(Glob.memberUrl + '/check/unresolved/$coupleCode/$memberSeq');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    bool hasUnResolved = false;
    CoupleUnResolvedSignalDto coupleUnResolvedSignalDto = CoupleUnResolvedSignalDto.fromJson(jsonDecode(response.body));

    if (coupleUnResolvedSignalDto.hasUnResolved == true) {
      hasUnResolved = true;
    }

    Navigator.push(context, MaterialPageRoute(builder: (context) => SignalProgress(
      hasUnResolved: hasUnResolved,
      eatSignalSeq: int.parse(coupleUnResolvedSignalDto.eatSignalSeq.toString()),
      playSignalSeq: int.parse(coupleUnResolvedSignalDto.playSignalSeq.toString()),
      messageOfTheDaySeq: messageOfTheDaySeq,
      todaySignalSeq: _todaySignalSeq,
    )));
  }
}

class CustomPageRoute extends MaterialPageRoute {
  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  CustomPageRoute({required WidgetBuilder builder}) : super(builder: builder);
}
