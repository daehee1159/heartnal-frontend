import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:couple_signal/src/models/anniversary/anniversary.dart';
import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/global/navigator_service.dart';
import 'package:couple_signal/src/models/signal/check_signal.dart';
import 'package:couple_signal/src/models/signal/check_signal_dto.dart';
import 'package:couple_signal/src/models/signal/couple_unresolved_signal_dto.dart';
import 'package:couple_signal/src/models/signal/message/message_of_the_day.dart';
import 'package:couple_signal/src/models/signal/message/message_of_the_day_dto.dart';
import 'package:couple_signal/src/models/signal/temp_signal.dart';
import 'package:couple_signal/src/models/signal/temp_signal_dto.dart';
import 'package:couple_signal/src/models/signal/unresolved_signal_dto.dart';
import 'package:couple_signal/src/screens/settings/create_couple.dart';
import 'package:couple_signal/src/screens/signal/message/received_message_of_the_day.dart';
import 'package:couple_signal/src/screens/signal/received/received_signal.dart';
import 'package:couple_signal/src/screens/signal/received/recipient_received_signal.dart';
import 'package:couple_signal/src/screens/signal/today/received_today_signal.dart';
import 'package:couple_signal/src/screens/signal/today/today_signal_question1.dart';
import 'package:couple_signal/src/screens/signal/unresolved/signal_progress.dart';
import 'package:couple_signal/src/screens/tabbar/check_anniversary.dart';
import 'package:couple_signal/src/screens/tabbar/create_anniversary.dart';
import 'package:couple_signal/src/screens/tabbar/notification_page.dart';
import 'package:couple_signal/src/service/global_func.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:couple_signal/src/models/signal/signal_dto.dart';
import 'package:couple_signal/src/screens/tabbar/tabbar_fifth.dart';
import 'package:couple_signal/src/screens/tabbar/tabbar_first.dart';
import 'package:couple_signal/src/screens/tabbar/tabbar_fourth.dart';
import 'package:couple_signal/src/screens/tabbar/tabbar_second.dart';
import 'package:couple_signal/src/screens/tabbar/tabbar_third.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../models/signal/today/today_signal.dart';
import '../models/signal/today/today_signal_questions_dto.dart';

List<Anniversary> anniversaryList = [];
var _doNotSeeTodayChecked = false;
final String doNotSeeTodayDate = 'doNotSeeTodayDate';
final getIt = GetIt.instance;

class HomePage extends StatefulWidget {
  final int routePage;
  const HomePage({Key? key, required this.routePage}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  bool readSignal = true;
  bool isDispose = false;
  String testString = "";

  @override
  void dispose() {
    isDispose = true;
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  TextEditingController anniversaryTitleController = new TextEditingController();
  DateTime currentDate = DateTime.now();
  late TabController controller = TabController(length: 5, vsync: this, initialIndex: widget.routePage);

  late FirebaseMessaging messaging;
  String? notificationText;

  @override
  void initState() {
    super.initState();
    controller = TabController(length: 5, vsync: this, initialIndex: widget.routePage);
    anniversaryTitleController = new TextEditingController();
    WidgetsBinding.instance.addObserver(this);

    Future.delayed(Duration.zero, () async {
      _checkTempSignal(context);
    });

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

    _loadSignal();
    messaging = FirebaseMessaging.instance;
    messaging.subscribeToTopic("messaging");

    FirebaseMessaging.onMessage.listen((RemoteMessage event) async {
      /// message received
      _alertSignal();
      readSignal = false;
      SignalDto signalDto = SignalDto.fromJson(event.data);

      if (signalDto.isSignal == 'true' && !isDispose && signalDto.category != "messageOfTheDay" && signalDto.category != 'todaySignal') {
        Future.delayed(const Duration(milliseconds: 1000), () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Icon(
                          FontAwesomeIcons.envelopeOpenText,
                          color: const Color(0xffFE9BE6),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.006, 0, 0),
                          child: Text(
                            '시그널 도착',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                      Text(
                        '시그널이 도착했어요.',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      (signalDto.result.toString() == 'true') ?
                      Text(
                        "결과를 확인해보세요!",
                        style: Theme.of(context).textTheme.bodyText2,
                      ) :
                      Text(
                        '당신의 마음을 전달해보세요!',
                        style: Theme.of(context).textTheme.bodyText2,
                      )
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: Text(
                        "Ok",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      onPressed: () async {
                        // 시그널 받았을 때
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        SignalDto signalDto = SignalDto.fromJson(event.data);

                        if (signalDto.tempSignalSeq == "0") {
                        } else {
                          SharedPreferences pref = await SharedPreferences.getInstance();
                          int memberSeq = int.parse(pref.getInt(Glob.memberSeq).toString());
                          var accessToken = pref.getString(Glob.accessToken);

                          Map<String, String> headers = {
                            'Content-Type': 'application/json',
                            'Authorization': 'Bearer ' + accessToken.toString()
                          };

                          var deleteTempUrl = Uri.parse(Glob.memberUrl + '/delete/temp/signal');

                          final deleteTempData = jsonEncode({
                            "tempSignalSeq": signalDto.tempSignalSeq,
                            "memberSeq": memberSeq,
                          });

                          http.Response deleteTempResponse = await http.post(
                              deleteTempUrl,
                              headers: headers,
                              body: deleteTempData
                          );

                          if (jsonDecode(deleteTempResponse.body) == false) {
                            return;
                          }
                        }

                        // background 에서 받은 메시지를 pref 에 저장
                        pref.setBool('hasMessage', true);
                        pref.setString('position', signalDto.position.toString());
                        pref.setString('category', signalDto.category.toString());
                        pref.setInt('tryCount', int.parse(signalDto.tryCount.toString()));
                        pref.setString('termination', signalDto.termination.toString());

                        if (signalDto.category.toString() == 'eatSignal') {
                          pref.setInt('eatSignalSeq', int.parse(signalDto.eatSignalSeq.toString()));
                        } else if (signalDto.category.toString() == 'playSignal') {
                          pref.setInt('playSignalSeq', int.parse(signalDto.playSignalSeq.toString()));
                        }

                        pref.setString('senderSelected', signalDto.senderSelected.toString());
                        pref.setString('recipientSelected', signalDto.recipientSelected.toString());
                        pref.setString('resultSelected', signalDto.resultSelected.toString());

                        if (signalDto.result.toString() == 'true') {
                          pref.setBool('result', true);
                        } else if (signalDto.result.toString() == 'false') {
                          pref.setBool('result', false);
                        }

                        if (signalDto.position == 'recipient' && signalDto.termination == "true") {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ReceivedSignal(signalDto: signalDto,)));
                        } else if (signalDto.position == 'recipient' && signalDto.termination == "false") {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => RecipientReceivedSignal(signalDto: signalDto,)));
                        } else if (signalDto.position == 'recipient' && signalDto.termination == "true" && signalDto.tryCount == '3') {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ReceivedSignal(signalDto: signalDto,)));
                        } else {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ReceivedSignal(signalDto: signalDto,)));
                        }
                      },
                    )
                  ],
                );
              });
        });
      } else if (signalDto.isSignal == 'true' && !isDispose && signalDto.category == "messageOfTheDay" && signalDto.category != 'todaySignal') {
        Future.delayed(const Duration(milliseconds: 1000), () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Icon(
                          FontAwesomeIcons.envelopeOpenText,
                          color: const Color(0xffFE9BE6),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.006, 0, 0),
                          child: Text(
                            '오늘의 한마디 도착',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                      Text(
                        '오늘의 한마디가 도착했어요!',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      Text(
                        "메시지를 확인해주세요!",
                        style: Theme.of(context).textTheme.bodyText2,
                      )
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: Text(
                        "Ok",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      onPressed: () async {
                        // 시그널 받았을 때
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        SignalDto signalDto = SignalDto.fromJson(event.data);

                        if (signalDto.tempSignalSeq == "0") {
                        } else {
                          SharedPreferences pref = await SharedPreferences.getInstance();
                          int memberSeq = int.parse(pref.getInt(Glob.memberSeq).toString());
                          var accessToken = pref.getString(Glob.accessToken);

                          Map<String, String> headers = {
                            'Content-Type': 'application/json',
                            'Authorization': 'Bearer ' + accessToken.toString()
                          };

                          var deleteTempUrl = Uri.parse(Glob.memberUrl + '/delete/temp/signal');

                          final deleteTempData = jsonEncode({
                            "tempSignalSeq": signalDto.tempSignalSeq,
                            "memberSeq": memberSeq,
                          });

                          http.Response deleteTempResponse = await http.post(
                              deleteTempUrl,
                              headers: headers,
                              body: deleteTempData
                          );

                          if (jsonDecode(deleteTempResponse.body) == false) {
                            return;
                          }
                        }

                        var accessToken = pref.getString(Glob.accessToken);
                        int messageOfTheDaySeq = int.parse(signalDto.messageOfTheDaySeq.toString());

                        var url = Uri.parse(Glob.dailySignalUrl + '/info/$messageOfTheDaySeq');

                        Map<String, String> headers = {
                          'Content-Type': 'application/json',
                          'Authorization': 'Bearer ' + accessToken.toString()
                        };

                        http.Response response = await http.get(
                          url,
                          headers: headers,
                        );

                        MessageOfTheDayDto messageOfTheDayDto = MessageOfTheDayDto.fromJson(jsonDecode(response.body));
                        MessageOfTheDay _messageOfTheDay = Provider.of<MessageOfTheDay>(context, listen: false);

                        _messageOfTheDay.setMessageOfTheDaySeq = messageOfTheDayDto.messageOfTheDaySeq;
                        _messageOfTheDay.setSenderMemberSeq = messageOfTheDayDto.senderMemberSeq;
                        _messageOfTheDay.setRecipientMemberSeq = messageOfTheDayDto.recipientMemberSeq;
                        _messageOfTheDay.setMessage = messageOfTheDayDto.message;
                        _messageOfTheDay.setCoupleCode = messageOfTheDayDto.coupleCode;
                        _messageOfTheDay.setTermination = (signalDto.termination == "true") ? true : false;
                        _messageOfTheDay.setRegDt = messageOfTheDayDto.regDt;

                        Navigator.push(context, MaterialPageRoute(builder: (context) => ReceivedMessageOfTheDay()));
                      },
                    )
                  ],
                );
              });
        });
      } else if (signalDto.isSignal == 'true' && !isDispose && signalDto.category != "messageOfTheDay" && signalDto.category == 'todaySignal') {
        Future.delayed(const Duration(milliseconds: 1000), () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Icon(
                          FontAwesomeIcons.envelopeOpenText,
                          color: const Color(0xffFE9BE6),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.006, 0, 0),
                          child: Text(
                            '오늘의 시그널 도착',
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ),
                    ],
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                      Text(
                        '오늘의 시그널이 도착했어요!',
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      (signalDto.termination == 'true') ?
                      Text(
                        "결과를 확인해주세요!",
                        style: Theme.of(context).textTheme.bodyText2,
                      ) :
                      Text(
                        "질문에 답변을 해주세요!",
                        style: Theme.of(context).textTheme.bodyText2,
                      )
                    ],
                  ),
                  actions: [
                    TextButton(
                      child: Text(
                        "Ok",
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                      onPressed: () async {
                        // 시그널 받았을 때
                        SharedPreferences pref = await SharedPreferences.getInstance();
                        SignalDto signalDto = SignalDto.fromJson(event.data);

                        if (signalDto.tempSignalSeq == "0") {
                        } else {
                          if (signalDto.position == 'sender') {
                            SharedPreferences pref = await SharedPreferences.getInstance();
                            int memberSeq = int.parse(pref.getInt(Glob.memberSeq).toString());
                            var accessToken = pref.getString(Glob.accessToken);

                            Map<String, String> headers = {
                              'Content-Type': 'application/json',
                              'Authorization': 'Bearer ' + accessToken.toString()
                            };

                            var deleteTempUrl = Uri.parse(Glob.memberUrl + '/delete/temp/signal');

                            final deleteTempData = jsonEncode({
                              "tempSignalSeq": signalDto.tempSignalSeq,
                              "memberSeq": memberSeq,
                            });

                            http.Response deleteTempResponse = await http.post(
                                deleteTempUrl,
                                headers: headers,
                                body: deleteTempData
                            );

                            /// 투두 여기가 지금 false 임
                            /// 왜냐하면 나는 내가 받는사람으로 테스트하면서 temp 테이블에는 77번으로 해놨음 78이 받는 사람임
                            if (jsonDecode(deleteTempResponse.body) == false) {
                              return;
                            }
                          } else {
                          }
                        }

                        TodaySignal _todaySignal = Provider.of<TodaySignal>(context, listen: false);

                        int todaySignalSeq = int.parse(signalDto.todaySignalSeq.toString());
                        String position = signalDto.position.toString();
                        bool termination = (signalDto.termination.toString() == 'true') ? true : false;

                        /// 오늘의 시그널
                        List<TodaySignalQuestionsDto> questionList = await _todaySignal.getTodaySignalQuestions(position, todaySignalSeq);

                        _todaySignal.setTodaySignalSeq = todaySignalSeq;
                        _todaySignal.setPosition = position;
                        _todaySignal.setAllQuestionList = questionList;

                        Navigator.push(context, MaterialPageRoute(builder: (context) => ReceivedTodaySignal(termination: termination, position: _todaySignal.getPosition, questionList: questionList, todaySignalSeq: todaySignalSeq)));
                      },
                    )
                  ],
                );
              });
        });
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        /// get_it + provider 를 통해 HomePage 일때만 호출
        if (mounted) {
          Future.delayed(Duration.zero, () {
            final provider = getIt.get<TempSignal>();
            if (provider.getIsWatchingAd == false) {
              _checkTempSignal(context);
            }
          });
        }
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.paused:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    /// 토큰이 만료되었을 때
    Future.microtask(() async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String fcmTokenBool = pref.getString(Glob.fcmTokenBool).toString();

      if (fcmTokenBool == "true") {
        bool result = await _fcmRefreshToken();
        if (result) {
          /// 토큰 재발급 성공
          pref.setString(Glob.fcmTokenBool, "false");
        } else {
          /// 토큰 재발급 실패, alert로 처리해야할지는 좀 더 생각해봐야할듯
          // GlobalAlert().globTokenErrorAlert(context);
          /// 에러 로그 API 전송
          int memberSeq = int.parse(pref.getString(Glob.memberSeq).toString());
          GlobalFunc().setErrorLog("토큰 재발급 실패 memberSeq = $memberSeq");
        }
      }
    });

    Anniversary _anniversary = Provider.of<Anniversary>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: Image.asset(
            'images/heartnal_bi.png',
            height: MediaQuery.of(context).size.height * 0.04,
            fit: BoxFit.contain,
          ),
          // AppBar icon color 변경 시 여기
          iconTheme: IconThemeData(color: Color(0xff494749), size: Theme.of(context).iconTheme.size),
          elevation: 0,
          actions: [
            Padding(
                padding: EdgeInsets.all(0),
                child: readSignal ? IconButton(
                  icon: Icon(
                    FontAwesomeIcons.bell,
                    size: 25,
                  ),
                  onPressed: () {
                    _checkSignal(context, true);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage()));
                  },
                ) : IconButton(
                  icon: badges.Badge(
                    badgeContent: const Text(''),
                    child: const Icon(
                      FontAwesomeIcons.bell,
                      size: 25,
                    ),
                  ),
                  onPressed: () {
                    setState(() {
                      /// 미완료 시그널이 있으면 Progress 로 보냄
                      _checkSignal(context, true);
                    });
                    Navigator.push(context, MaterialPageRoute(builder: (context) => NotificationPage()));
                  },
                )
            )
          ],
        ),
        body: TabBarView(
          children: [
            TabBarFirst(),
            TabBarSecond(),
            TabBarThird(),
            TabBarFourth(),
            TabBarFifth()
          ],
          controller: controller,
        ),
        drawer: Drawer(
          child: FutureBuilder(
            future: _anniversary.getCoupleRegDt(),
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
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                );
              } else if (snapshot.data == false) {
                return Drawer(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    children: [
                      DrawerHeader(
                        decoration: const BoxDecoration(
                          color: const Color(0xffFFF1F5),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                                child: RichText(
                                  text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: '기념일',
                                          style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 24.0,)
                                        ),
                                        WidgetSpan(
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                              child: const Icon(
                                                FontAwesomeIcons.gift,
                                                color: const Color(0xffFE9BE6),
                                              ),
                                            )
                                        )
                                      ]
                                  ),
                                )
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                            Center(
                              child: Text(
                                'D-Day 등록 후 사용이 가능해요!',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                            SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                            TextButton(
                              child: Text(
                                'D-Day 등록하기',
                                style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                              ),
                              style: TextButton.styleFrom(
                                  primary: Colors.white,
                                  backgroundColor: const Color(0xffFE9BE6),
                                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10)
                              ),
                              onPressed: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => CreateCouple()));
                              },
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                );
              } else {
                anniversaryList = snapshot.data;
                var dDay = _anniversary.coupleRegDt.toString().substring(0, 10);
                return Column(
                    children: [
                      DrawerHeader(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 1.0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Center(
                                    child: RichText(
                                      text: TextSpan(
                                          children: [
                                            TextSpan(
                                                text: '기념일',
                                                style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 24.0,)
                                            ),
                                            WidgetSpan(
                                                child: Padding(
                                                  padding: const EdgeInsets.fromLTRB(10.0, 0, 0, 0),
                                                  child: const Icon(
                                                    FontAwesomeIcons.gift,
                                                    color: const Color(0xffFE9BE6),
                                                  ),
                                                )
                                            )
                                          ]
                                      ),
                                    )
                                ),
                                SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                Center(
                                  child: RichText(
                                    text: TextSpan(
                                      children: [
                                        WidgetSpan(
                                          alignment: PlaceholderAlignment.middle,
                                          child: Icon(Icons.favorite, size: 17, color: const Color(0xffFE9BE6),)
                                        ),
                                        TextSpan(
                                          text: '$dDay',
                                          style: Theme.of(context).textTheme.bodyText2
                                        ),
                                        WidgetSpan(
                                          alignment: PlaceholderAlignment.middle,
                                          child: Icon(Icons.favorite, size: 17, color: const Color(0xffFE9BE6),)
                                        ),
                                      ]
                                    ),
                                  ),
                                ),
                                SizedBox(height: 10.0,),
                                Center(
                                  child: Text(
                                    "우리 만난 날",
                                      style: Theme.of(context).textTheme.bodyText2
                                  ),
                                )
                              ],
                            ),
                          ),
                          padding: EdgeInsets.zero,
                          decoration: BoxDecoration(color: const Color(0xffFFF1F5),)
                      ),
                      Expanded(
                          child: ListView.builder(
                            /// 메모리 최적화를 위한 것, 현재 테스트중 https://ichi.pro/ko/flutter-memoli-choejeoghwa-silijeu-154251400833665 참고
                            addAutomaticKeepAlives: false,
                            addRepaintBoundaries: false,
                            itemCount: anniversaryList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                  minLeadingWidth: 50.0,
                                  title: Text(
                                    anniversaryList[index].anniversaryTitle.toString(),
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                  subtitle: Text(
                                    anniversaryList[index].anniversaryDate.toString(),
                                    style: Theme.of(context).textTheme.bodyText2,
                                  ),
                                  leading: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        anniversaryList[index].remainingDays.toString(),
                                        style: Theme.of(context).textTheme.bodyText2,
                                      ),
                                    ],
                                  ),
                                  trailing: anniversaryList[index].anniversarySeq == null ? Text("") : Icon(FontAwesomeIcons.edit),
                                  onTap: () {
                                    /// 자동으로 생성된 D-Day는 수정 불가, 내가 등록한 D-Day만 수정 가능 anniversarySeq 유무에 따름
                                    if (anniversaryList[index].anniversarySeq == null) {
                                      GlobalAlert().dontUpdateAnniversary(context);
                                    } else {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => CheckAnniversary(
                                                  anniversarySeq: int.parse(anniversaryList[index].anniversarySeq.toString()),
                                                  anniversaryTitle: anniversaryList[index].anniversaryTitle.toString(),
                                                  anniversaryDate: anniversaryList[index].anniversaryDate.toString(),
                                                  repeatYN: anniversaryList[index].repeatYN.toString()
                                              )
                                          )
                                      );
                                    }
                                  }
                              );
                            },
                          )
                      ),
                      Container(
                        color: Colors.black,
                        width: double.infinity,
                        height: 0.1,
                      ),
                      Container(
                        alignment: Alignment.center,
                        // padding: EdgeInsets.all(10),
                        height: 60,
                        child: ListTile(
                          leading: const Icon(Icons.add_circle_outline, color: Colors.grey,),
                          title: Text(
                            "기념일 추가하기",
                            style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
                          ),
                          // trailing: Icon(Icons.keyboard_arrow_right),
                          onTap: () {
                            // Navigator.of(context).pop();
                            Navigator.push(context, MaterialPageRoute(builder: (context) => CreateAnniversary()));
                          },
                        ),
                      ),
                    ]
                );
              }
            },
          ),
        ),
        bottomNavigationBar: Platform.isIOS ? Container(
          // color: const Color(0xffF7F7F9),
          padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
          child: TabBar(
            unselectedLabelColor: const Color(0xff494749),
            labelColor: const Color(0xffFE9BE6),
            indicatorColor: const Color(0xffFE9BE6),
            tabs: [
              Tab(
                icon: const Icon(
                  Icons.home_sharp,
                  size: 30,
                ),
              ),
              Tab(
                icon: const Icon(
                  Icons.menu_book_rounded,
                  size: 30,
                ),
              ),
              Tab(
                icon: const Icon(
                  Icons.favorite,
                  size: 30,
                ),
              ),
              Tab(
                icon: const Icon(
                  Icons.calendar_today,
                  size: 30,
                ),
              ),
              Tab(
                icon: const Icon(
                  Icons.settings,
                  size: 30,
                ),
              ),
            ],
            onTap: (value) => {

            },
            controller: controller,
          ),
        ) : TabBar(
          unselectedLabelColor: const Color(0xff494749),
          labelColor: const Color(0xffFE9BE6),
          indicatorColor: const Color(0xffFE9BE6),
          tabs: [
            Tab(
              icon: const Icon(
                Icons.home_sharp,
                size: 30,
              ),
            ),
            Tab(
              icon: const Icon(
                Icons.menu_book_rounded,
                size: 30,
              ),
            ),
            Tab(
              icon: const Icon(
                Icons.favorite,
                size: 30,
              ),
            ),
            Tab(
              icon: const Icon(
                Icons.calendar_today,
                size: 30,
              ),
            ),
            Tab(
              icon: const Icon(
                Icons.settings,
                size: 30,
              ),
            ),
          ],
          onTap: (value) => {
            if (value == 2) {
            }
          },
          controller: controller,
        ),
      ),
    );
  }

  _loadSignal() async {
    /// Load Signal
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("checkSignal") == true) {
      setState(() {
        readSignal = true;
      });
    } else {
      setState(() {
        readSignal = false;
      });
    }
  }

  _alertSignal() async {
    /// Alert Signal
    SharedPreferences pref = await SharedPreferences.getInstance();
    var checkSignal = 'checkSignal';
    pref.setBool(checkSignal, false);
    readSignal = false;
  }

  _checkSignal(context, bool isFcmData) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var checkSignal = 'checkSignal';
    pref.setBool(checkSignal, true);
    readSignal = true;

    String username = pref.getString(Glob.email).toString();
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/check/signal/$username');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );
    CheckSignalDto checkSignalDto = CheckSignalDto.fromJson(jsonDecode(response.body));

    CheckSignal _checkSignal = Provider.of<CheckSignal>(context, listen: false);
    _checkSignal.setHasUnResolved = checkSignalDto.hasUnResolved!;
    _checkSignal.setSenderEatSignalSeq = checkSignalDto.senderEatSignalSeq!;
    _checkSignal.setSenderPlaySignalSeq = checkSignalDto.senderPlaySignalSeq!;

    _checkSignal.setRecipientEatSignalSeq = checkSignalDto.recipientEatSignalSeq!;
    _checkSignal.setRecipientPlaySignalSeq = checkSignalDto.recipientPlaySignalSeq!;

    int doNotSeeTodayResult = 0;

    // 오늘 하루 보지않기 체크했을 때
    if (pref.getString(doNotSeeTodayDate).toString() == '' || pref.getString(doNotSeeTodayDate).toString() == 'null') {
      /// 오늘 하루 보지 않기 체크 아닐 때 그냥 넘어가면 됨
      doNotSeeTodayResult = 1;
    } else {
      DateTime pastDate = DateTime.parse(pref.getString(doNotSeeTodayDate).toString());
      DateTime now = DateTime.now();
      doNotSeeTodayResult = _daysBetween(pastDate, now);
    }

    /// 미완료건이 있는 경우 alert
    /// doNotSeeTodayResult 가 0보다 크면 날짜 지난거임
    if (_checkSignal.getHasUnResolved == true && doNotSeeTodayResult > 0 && isFcmData == true) {
      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: TextButton.icon(
                      label: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text(
                          "미완료 시그널",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      icon: Icon(
                        FontAwesomeIcons.exclamationCircle,
                        color: Colors.red,
                      ),
                      onPressed: () {},
                    ),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Text(
                            '미완료된 시그널이 있어요.',
                            style: Theme.of(context).textTheme.bodyText2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: 3,),
                        Center(
                          child: Text(
                            "시그널을 보내주세요!",
                            style: Theme.of(context).textTheme.bodyText2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 24.0,
                              width: 24.0,
                              child: Checkbox(
                                value: _doNotSeeTodayChecked,
                                onChanged: (value) {
                                  setState(() {
                                    _doNotSeeTodayChecked = !_doNotSeeTodayChecked;
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.01,),
                            GestureDetector(
                              child: Text(
                                '오늘 하루 보지 않기',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              onTap: () {
                                setState(() {
                                  _doNotSeeTodayChecked = !_doNotSeeTodayChecked;
                                });
                              }
                            )
                          ],
                        )
                      ],
                    ),
                    actions: [
                      TextButton(
                        child: Text(
                          'OK',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        onPressed: () async {
                          // 현재 시간 기록 이후 이 alert 불러올 때 시간 체크해서 불러오기
                          if (_doNotSeeTodayChecked) {
                            setState(() {
                              DateTime today = DateTime.now();
                              pref.setString(doNotSeeTodayDate, today.toString());
                              _doNotSeeTodayChecked = false;
                            });
                          }

                          String coupleCode = pref.getString(Glob.coupleCode).toString();
                          int memberSeq = int.parse(pref.getInt(Glob.memberSeq).toString());
                          var url = Uri.parse(Glob.memberUrl + '/check/unresolved/$coupleCode/$memberSeq');

                          Map<String, String> headers = {
                            'Content-Type': 'application/json',
                            'Authorization': 'Bearer ' + accessToken.toString()
                          };

                          http.Response response = await http.get(
                            url,
                            headers: headers,
                          );

                          CoupleUnResolvedSignalDto coupleUnResolvedSignalDto = CoupleUnResolvedSignalDto.fromJson(jsonDecode(response.body));

                          bool hasUnResolved = false;
                          int eatSignalSeq = 0;
                          int playSignalSeq = 0;
                          int messageOfTheDaySeq = 0;
                          int todaySignalSeq = 0;

                          if (coupleUnResolvedSignalDto.hasUnResolved == true) {
                            hasUnResolved = true;
                          }
                          if (coupleUnResolvedSignalDto.eatSignalSeq != 0) {
                            eatSignalSeq = int.parse(coupleUnResolvedSignalDto.eatSignalSeq.toString());
                          }
                          if (coupleUnResolvedSignalDto.playSignalSeq != 0) {
                            playSignalSeq = int.parse(coupleUnResolvedSignalDto.playSignalSeq.toString());
                          }

                          if (coupleUnResolvedSignalDto.messageOfTheDaySeq != 0) {
                            messageOfTheDaySeq = int.parse(coupleUnResolvedSignalDto.messageOfTheDaySeq.toString());
                          }

                          if (coupleUnResolvedSignalDto.todaySignalSeq != 0) {
                            todaySignalSeq = int.parse(coupleUnResolvedSignalDto.todaySignalSeq.toString());
                          }

                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignalProgress(
                            hasUnResolved: hasUnResolved,
                            eatSignalSeq: eatSignalSeq,
                            playSignalSeq: playSignalSeq,
                            messageOfTheDaySeq: messageOfTheDaySeq,
                            todaySignalSeq: todaySignalSeq,
                          )));
                          // Navigator.push(context, MaterialPageRoute(builder: (context) => UnResolvedDashBoard()));
                        },
                      ),
                      TextButton(
                        child: Text(
                          'Cancel',
                          style: Theme.of(context).textTheme.bodyText2,
                        ),
                        onPressed: () async {
                          // 현재 시간 기록 이후 이 alert 불러올 때 시간 체크해서 불러오기
                          if (_doNotSeeTodayChecked) {
                            setState(() {
                              DateTime today = DateTime.now();
                              pref.setString(doNotSeeTodayDate, today.toString());
                              _doNotSeeTodayChecked = false;
                            });
                          }
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                }
            );
          }
      );
    }
  }

  /// 미확인 시그널 체크
  _checkTempSignal(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int memberSeq = int.parse(pref.getInt(Glob.memberSeq).toString());
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/temp/signal/$memberSeq');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    List<TempSignalDto> tempSignalList = ((json.decode(response.body) as List).map((e) => TempSignalDto.fromJson(e)).toList());

    if (tempSignalList.isEmpty) {
      return false;
    } else if (tempSignalList.length == 1) {
      int messageOfTheDaySeq = int.parse(tempSignalList[0].signalSeq.toString());
      if (tempSignalList[0].category == "messageOfTheDay") {
        var url = Uri.parse(Glob.dailySignalUrl + '/info/$messageOfTheDaySeq');

        Map<String, String> headers = {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ' + accessToken.toString()
        };

        http.Response response = await http.get(
          url,
          headers: headers,
        );

        MessageOfTheDayDto messageOfTheDayDto = MessageOfTheDayDto.fromJson(jsonDecode(response.body));

        MessageOfTheDay _messageOfTheDay = Provider.of<MessageOfTheDay>(context, listen: false);

        _messageOfTheDay.setMessageOfTheDaySeq = messageOfTheDayDto.messageOfTheDaySeq;
        _messageOfTheDay.setSenderMemberSeq = messageOfTheDayDto.senderMemberSeq;
        _messageOfTheDay.setRecipientMemberSeq = messageOfTheDayDto.recipientMemberSeq;
        _messageOfTheDay.setMessage = messageOfTheDayDto.message;
        _messageOfTheDay.setCoupleCode = messageOfTheDayDto.coupleCode;
        _messageOfTheDay.setTermination = tempSignalList[0].termination;
        _messageOfTheDay.setRegDt = messageOfTheDayDto.regDt;

        var deleteTempUrl = Uri.parse(Glob.memberUrl + '/delete/temp/signal');
        final deleteTempData = jsonEncode({
          "tempSignalSeq": tempSignalList[0].tempSignalSeq,
          "memberSeq": memberSeq,
        });

        http.Response deleteTempResponse = await http.post(
            deleteTempUrl,
            headers: headers,
            body: deleteTempData
        );

        Navigator.push(context, MaterialPageRoute(builder: (context) => ReceivedMessageOfTheDay()));

      } else if (tempSignalList[0].category == "todaySignal") {
        TodaySignal _todaySignal = Provider.of<TodaySignal>(context, listen: false);

        int todaySignalSeq = int.parse(tempSignalList[0].signalSeq.toString());
        String position = tempSignalList[0].position.toString();
        bool termination = (tempSignalList[0].termination.toString() == 'true') ? true : false;
        /// 오늘의 시그널

        List<TodaySignalQuestionsDto> questionList = await _todaySignal.getTodaySignalQuestions(position, todaySignalSeq);

        _todaySignal.setTodaySignalSeq = todaySignalSeq;
        _todaySignal.setPosition = position;
        _todaySignal.setAllQuestionList = questionList;

        /// tempSignal 삭제
        var deleteTempUrl = Uri.parse(Glob.memberUrl + '/delete/temp/signal');
        final deleteTempData = jsonEncode({
          "tempSignalSeq": tempSignalList[0].tempSignalSeq,
          "memberSeq": memberSeq,
        });

        http.Response deleteTempResponse = await http.post(
            deleteTempUrl,
            headers: headers,
            body: deleteTempData
        );

        Navigator.push(context, MaterialPageRoute(builder: (context) => ReceivedTodaySignal(termination: termination, position: _todaySignal.getPosition, questionList: questionList, todaySignalSeq: todaySignalSeq)));

      } else {
        /// tempSignal 1개 존재하므로 바로 결과 alert 호출
        var url = Uri.parse(Glob.memberUrl + '/check/signal');

        String inputSignalSeq = '';

        if (tempSignalList[0].category == 'eatSignal') {
          inputSignalSeq = 'eatSignalSeq';
        } else {
          inputSignalSeq = 'playSignalSeq';
        }

        final saveData = jsonEncode({
          "position": tempSignalList[0].position,
          "category": tempSignalList[0].category,
          inputSignalSeq: tempSignalList[0].signalSeq
        });

        http.Response response = await http.post(
            url,
            headers: headers,
            body: saveData
        );

        /// 여기서 받아오는 데이터 중 tryCount 가 할 차례를 의미하는건지 이전 차례인건지 확인해봐야함
        UnResolvedSignalDto unResolvedSignalDto = UnResolvedSignalDto.fromJson(jsonDecode(response.body));

        String eatSignalSeq = (unResolvedSignalDto.category == "eatSignal") ? unResolvedSignalDto.eatSignalSeq.toString() : "null";
        String playSignalSeq = (unResolvedSignalDto.category == "playSignal") ? unResolvedSignalDto.playSignalSeq.toString() : "null";
        String result = (unResolvedSignalDto.position == "sender" && unResolvedSignalDto.senderSelected == unResolvedSignalDto.recipientSelected) ? "true" : "false";
        var resultSelected = (result == "true") ? unResolvedSignalDto.senderSelected : null;

        SignalDto signalDto = SignalDto(
          "", "", "", "", "", "true",
          unResolvedSignalDto.position, unResolvedSignalDto.category, unResolvedSignalDto.tryCount.toString(), eatSignalSeq, playSignalSeq,"", "", tempSignalList[0].signalSeq.toString(), unResolvedSignalDto.senderSelected, unResolvedSignalDto.recipientSelected,
          tempSignalList[0].termination.toString(), result, resultSelected,);

        /// 여기서 TempSignal Table 에 있는 seq 건 삭제, 그 후에 ReceivedSignal 등으로 이동
        var deleteTempUrl = Uri.parse(Glob.memberUrl + '/delete/temp/signal');
        final deleteTempData = jsonEncode({
          "tempSignalSeq": tempSignalList[0].tempSignalSeq,
          "memberSeq": memberSeq,
        });

        http.Response deleteTempResponse = await http.post(
            deleteTempUrl,
            headers: headers,
            body: deleteTempData
        );

        if (jsonDecode(deleteTempResponse.body) == true) {
          if (unResolvedSignalDto.position == "recipient") {
            NavigationService().navigateToScreen(RecipientReceivedSignal(signalDto: signalDto,));
          } else {
            NavigationService().navigateToScreen(ReceivedSignal(signalDto: signalDto,));
          }
        } else {
        }
      }
    } else {
      int messageOfTheDaySeq = 0;

      for (var i = 0; i < tempSignalList.length; i++) {
        if (tempSignalList[i].category == "messageOfTheDay") {
          messageOfTheDaySeq = int.parse(tempSignalList[i].signalSeq.toString());
        }
      }

      String coupleCode = pref.getString(Glob.coupleCode).toString();
      int memberSeq = int.parse(pref.getInt(Glob.memberSeq).toString());
      var url = Uri.parse(Glob.memberUrl + '/check/unresolved/$coupleCode/$memberSeq');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ' + accessToken.toString()
      };

      http.Response response = await http.get(
        url,
        headers: headers,
      );

      CoupleUnResolvedSignalDto coupleUnResolvedSignalDto = CoupleUnResolvedSignalDto.fromJson(jsonDecode(response.body));

      bool hasUnResolved = false;
      int eatSignalSeq = 0;
      int playSignalSeq = 0;
      int todaySignalSeq = 0;

      if (coupleUnResolvedSignalDto.hasUnResolved == true) {
        hasUnResolved = true;
      }
      if (coupleUnResolvedSignalDto.eatSignalSeq != 0) {
        eatSignalSeq = int.parse(coupleUnResolvedSignalDto.eatSignalSeq.toString());
      }
      if (coupleUnResolvedSignalDto.playSignalSeq != 0) {
        playSignalSeq = int.parse(coupleUnResolvedSignalDto.playSignalSeq.toString());
      }
      if (coupleUnResolvedSignalDto.todaySignalSeq != 0) {
        todaySignalSeq = int.parse(coupleUnResolvedSignalDto.todaySignalSeq.toString());
      }

      /// tempSignalList 지워줘야 다음에 또 안뜸
      for (var j = 0; j < tempSignalList.length; j++) {
        var deleteTempUrl = Uri.parse(Glob.memberUrl + '/delete/temp/signal');
        final deleteTempData = jsonEncode({
          "tempSignalSeq": tempSignalList[j].tempSignalSeq,
          "memberSeq": memberSeq,
        });

        http.Response deleteTempResponse = await http.post(
            deleteTempUrl,
            headers: headers,
            body: deleteTempData
        );
      }

      await showDialog(
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return AlertDialog(
                    title: TextButton.icon(
                      label: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text(
                          "시그널 도착!",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                      ),
                      icon: Icon(
                        FontAwesomeIcons.envelopeOpenText,
                        color: const Color(0xffFE9BE6),
                      ),
                      onPressed: () {},
                    ),
                    content: Text(
                      "당신의 마음을 전달해주세요!",
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
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SignalProgress(
                            hasUnResolved: hasUnResolved,
                            eatSignalSeq: eatSignalSeq,
                            playSignalSeq: playSignalSeq,
                            messageOfTheDaySeq: messageOfTheDaySeq,
                            todaySignalSeq: todaySignalSeq,
                          )));
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
                }
            );
          }
      );
    }
  }

  /// D-day
  /// from = 비교날짜, to = 현재날짜
  int _daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  Future<bool> _fcmRefreshToken() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String fcmToken = pref.getString(Glob.fcmToken).toString();
    String email = pref.getString(Glob.email).toString();

    var url = Uri.parse(Glob.memberUrl + '/change/device');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    var postData = jsonEncode({
      "email": email,
      "myDeviceToken": fcmToken,
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
}
