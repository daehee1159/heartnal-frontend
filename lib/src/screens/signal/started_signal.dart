import 'dart:convert';

import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/signal/couple_unresolved_signal_dto.dart';
import 'package:couple_signal/src/models/signal/today/today_signal_dto.dart';
import 'package:couple_signal/src/screens/home.dart';
import 'package:couple_signal/src/screens/signal/eat/first_sender_eat_signal.dart';
import 'package:couple_signal/src/screens/signal/message/message_of_the_day_page.dart';
import 'package:couple_signal/src/screens/signal/play/first_sender_play_signal.dart';
import 'package:couple_signal/src/screens/signal/today/received_today_signal.dart';
import 'package:couple_signal/src/screens/signal/today/result_today_signal.dart';
import 'package:couple_signal/src/screens/signal/today/today_signal_main.dart';
import 'package:couple_signal/src/screens/signal/today/today_signal_question1.dart';
import 'package:couple_signal/src/screens/signal/unresolved/signal_progress.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../models/signal/message/message_of_the_day.dart';
import '../../models/signal/today/today_signal.dart';
import '../../models/signal/today/today_signal_questions_dto.dart';
import '../test/kakao_link_api.dart';

bool hasUnResolved = false;
int eatSignalSeq = 0;
int playSignalSeq = 0;
int messageOfTheDaySeq = 0;
int todaySignalSeq = 0;
Map<String, dynamic> myTurnData = new Map<String, dynamic>();

class StartSignal extends StatefulWidget {
  const StartSignal({Key? key}) : super(key: key);

  @override
  _StartSignalState createState() => _StartSignalState();
}

class _StartSignalState extends State<StartSignal> {
  @override
  Widget build(BuildContext context) {
    TodaySignal _todaySignal = Provider.of<TodaySignal>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '시그널 보내기',
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Container(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.95,
                  height: MediaQuery.of(context).size.height * 0.23,
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
                                        text: '원하는 카테고리를 ',
                                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: const Color(0xffFE9BE6)),
                                      ),
                                      TextSpan(
                                        text: '선택해주세요.',
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
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.height * 0.23,
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
                                                      '오늘 뭐먹지?',
                                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 24),
                                                    ),
                                                    Icon(
                                                      Icons.keyboard_arrow_right,
                                                      color: Colors.black,
                                                      size: 30,
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                  child: Text(
                                                    '이미지를 클릭해보세요',
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
                                                      padding: const EdgeInsets.fromLTRB(0, 20, 40, 10),
                                                      onPressed: () async {
                                                        bool result = await _signalCheckProgress("eatSignal");
                                                        if (result) {
                                                          signalProgressAlert(context, "eatSignal");
                                                        } else {
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => SenderEatSignalCategoryPage()));
                                                        }
                                                      },
                                                      icon: SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.25,
                                                        height: MediaQuery.of(context).size.height * 0.12,
                                                        child: OverflowBox(
                                                          minHeight: MediaQuery.of(context).size.height * 0.12,
                                                          maxHeight: MediaQuery.of(context).size.height * 0.12,
                                                          minWidth: MediaQuery.of(context).size.width * 0.25,
                                                          maxWidth: MediaQuery.of(context).size.width * 0.25,
                                                          child: Lottie.asset(
                                                            'images/json/icon/icon_eat_signal.json',
                                                            width: MediaQuery.of(context).size.width * 0.25,
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
                              bool result = await _signalCheckProgress("eatSignal");
                              if (result) {
                                signalProgressAlert(context, "eatSignal");
                              } else {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => SenderEatSignalCategoryPage()));
                              }
                            },
                          )
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.height * 0.23,
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
                                                      '오늘 뭐하지?',
                                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 24),
                                                    ),
                                                    Icon(
                                                      Icons.keyboard_arrow_right,
                                                      color: Colors.black,
                                                      size: 30,
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                  child: Text(
                                                    '이미지를 클릭해보세요',
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
                                                      padding: const EdgeInsets.fromLTRB(0, 20, 40, 10),
                                                      onPressed: () async {
                                                        bool result = await _signalCheckProgress("playSignal");
                                                        if (result) {
                                                          signalProgressAlert(context, "playSignal");
                                                        } else {
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => PlayPrimaryCategory()));
                                                        }
                                                      },
                                                      icon: SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.35,
                                                        height: MediaQuery.of(context).size.height * 0.20,
                                                        child: OverflowBox(
                                                          minHeight: MediaQuery.of(context).size.height * 0.20,
                                                          maxHeight: MediaQuery.of(context).size.height * 0.20,
                                                          minWidth: MediaQuery.of(context).size.width * 0.35,
                                                          maxWidth: MediaQuery.of(context).size.width * 0.35,
                                                          child: Lottie.asset(
                                                            'images/json/icon/icon_play_signal.json',
                                                            width: MediaQuery.of(context).size.width * 0.35,
                                                            height: MediaQuery.of(context).size.height * 0.20
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
                              bool result = await _signalCheckProgress("playSignal");
                              if (result) {
                                signalProgressAlert(context, "playSignal");
                              } else {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => PlayPrimaryCategory()));
                              }
                            },
                          )
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.height * 0.23,
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
                                                      '오늘의 한마디',
                                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 24),
                                                    ),
                                                    Icon(
                                                      Icons.keyboard_arrow_right,
                                                      color: Colors.black,
                                                      size: 30,
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                  child: Text(
                                                    '이미지를 클릭해보세요',
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
                                                      padding: const EdgeInsets.fromLTRB(0, 0, 40, 10),
                                                      onPressed: () async {
                                                        bool result = await _signalCheckProgress("messageOfTheDay");
                                                        if (result) {
                                                          signalProgressAlert(context, "messageOfTheDay");
                                                        } else {
                                                          Navigator.push(context, MaterialPageRoute(builder: (context) => MessageOfTheDayPage()));
                                                        }
                                                      },
                                                      icon: SizedBox(
                                                        width: MediaQuery.of(context).size.width * 0.35,
                                                        height: MediaQuery.of(context).size.height * 0.20,
                                                        child: OverflowBox(
                                                          minHeight: MediaQuery.of(context).size.height * 0.20,
                                                          maxHeight: MediaQuery.of(context).size.height * 0.20,
                                                          minWidth: MediaQuery.of(context).size.width * 0.35,
                                                          maxWidth: MediaQuery.of(context).size.width * 0.35,
                                                          child: Lottie.asset(
                                                            'images/json/icon/icon_message_of_the_day.json',
                                                            width: MediaQuery.of(context).size.width * 0.35,
                                                            height: MediaQuery.of(context).size.height * 0.20
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
                              bool result = await _signalCheckProgress("messageOfTheDay");
                              if (result) {
                                signalProgressAlert(context, "messageOfTheDay");
                              } else {
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MessageOfTheDayPage()));
                              }
                            },
                          )
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.height * 0.23,
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
                                                  '오늘의 시그널',
                                                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 24),
                                                ),
                                                Icon(
                                                  Icons.keyboard_arrow_right,
                                                  color: Colors.black,
                                                  size: 30,
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                              child: Text(
                                                '이미지를 클릭해보세요',
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
                                                    padding: const EdgeInsets.fromLTRB(0, 0, 40, 10),
                                                    onPressed: () async {
                                                      /// 여기서 내 차례여서 true 인지 아니면 오늘 다 해서 true 인지 모르기 때문에 isMyTurn 호출해야함
                                                      var result = await _todaySignal.getIsMyTurn();

                                                      int _todaySignalSeq = int.parse(result['todaySignalSeq'].toString());
                                                      String _isMyTurn = result['isMyTurn'];
                                                      String _isComplete = result['isComplete'];
                                                      String _position = '';


                                                      if (_todaySignalSeq == 0 && _isMyTurn == 'Y' && _isComplete == 'N') {
                                                        /// sender 이면서 오늘 첫 시도일 때
                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => TodaySignalMain()));
                                                      } else if (_todaySignalSeq != 0 && _isMyTurn == 'Y' && _isComplete == 'N') {
                                                        /// recipient 이면서 내 차례일 때
                                                        // position == recipient, 내 차례
                                                        _position = 'recipient';
                                                        List<TodaySignalQuestionsDto> questionList = await _todaySignal.getTodaySignalQuestions('recipient', _todaySignalSeq);
                                                        _todaySignal.setTodaySignalSeq = _todaySignalSeq;
                                                        _todaySignal.setPosition = 'recipient';
                                                        _todaySignal.setAllQuestionList = questionList;

                                                        Navigator.push(context, MaterialPageRoute(builder: (context) => TodaySignalQuestion1(position: 'recipient', questionList: questionList, todaySignalSeq: _todaySignalSeq,)));
                                                      } else if (_todaySignalSeq != 0 && _isMyTurn == 'N' && _isComplete == 'N') {
                                                        /// sender 이면서 내 차례는 아니지만 상대방이 아직 답변을 하지 않은 경우
                                                        _position = 'sender';
                                                        // alert type 1
                                                        /// signalProgressAlert 에서 messageOfTheDay or todaySignal 이면 오늘 시그널 횟수 초과 멘트기 때문에 아래처럼 바꿔서 파라미터를 넣어줬음
                                                        signalProgressAlert(context, "todaySignalProceeding");
                                                      } else if (_todaySignalSeq == 0 && _isMyTurn == 'N' && _isComplete == 'Y') {
                                                        /// 오늘의 시그널 기능을 오늘 모두 이용한 경우
                                                        /// 투두 이게 나올 수 없는 확률임
                                                        signalProgressAlert(context, "todaySignal");
                                                      } else {
                                                        /// 오늘의 시그널 기능을 오늘 모두 이용한 경우
                                                        signalProgressAlert(context, "todaySignal");
                                                      }
                                                    },
                                                    icon: SizedBox(
                                                      width: MediaQuery.of(context).size.width * 0.25,
                                                      height: MediaQuery.of(context).size.height * 0.15,
                                                      child: OverflowBox(
                                                        minHeight: MediaQuery.of(context).size.height * 0.15,
                                                        maxHeight: MediaQuery.of(context).size.height * 0.15,
                                                        minWidth: MediaQuery.of(context).size.width * 0.25,
                                                        maxWidth: MediaQuery.of(context).size.width * 0.25,
                                                        child: Lottie.asset(
                                                          'images/json/icon/icon_today_signal.json',
                                                          width: MediaQuery.of(context).size.width * 0.25,
                                                          height: MediaQuery.of(context).size.height * 0.15
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
                            /// 여기서 내 차례여서 true 인지 아니면 오늘 다 해서 true 인지 모르기 때문에 isMyTurn 호출해야함
                            var result = await _todaySignal.getIsMyTurn();

                            int _todaySignalSeq = int.parse(result['todaySignalSeq'].toString());
                            String _isMyTurn = result['isMyTurn'];
                            String _isComplete = result['isComplete'];
                            String _position = '';


                            if (_todaySignalSeq == 0 && _isMyTurn == 'Y' && _isComplete == 'N') {
                              /// sender 이면서 오늘 첫 시도일 때
                              Navigator.push(context, MaterialPageRoute(builder: (context) => TodaySignalMain()));
                            } else if (_todaySignalSeq != 0 && _isMyTurn == 'Y' && _isComplete == 'N') {
                              /// recipient 이면서 내 차례일 때
                              // position == recipient, 내 차례
                              _position = 'recipient';
                              List<TodaySignalQuestionsDto> questionList = await _todaySignal.getTodaySignalQuestions('recipient', _todaySignalSeq);
                              _todaySignal.setTodaySignalSeq = _todaySignalSeq;
                              _todaySignal.setPosition = 'recipient';
                              _todaySignal.setAllQuestionList = questionList;

                              Navigator.push(context, MaterialPageRoute(builder: (context) => TodaySignalQuestion1(position: 'recipient', questionList: questionList, todaySignalSeq: _todaySignalSeq,)));
                            } else if (_todaySignalSeq != 0 && _isMyTurn == 'N' && _isComplete == 'N') {
                              /// sender 이면서 내 차례는 아니지만 상대방이 아직 답변을 하지 않은 경우
                              _position = 'sender';
                              // alert type 1
                              /// signalProgressAlert 에서 messageOfTheDay or todaySignal 이면 오늘 시그널 횟수 초과 멘트기 때문에 아래처럼 바꿔서 파라미터를 넣어줬음
                              signalProgressAlert(context, "todaySignalProceeding");
                            } else if (_todaySignalSeq == 0 && _isMyTurn == 'N' && _isComplete == 'Y') {
                              /// 오늘의 시그널 기능을 오늘 모두 이용한 경우
                              signalProgressAlert(context, "todaySignal");
                            } else {
                              /// 오늘의 시그널 기능을 오늘 모두 이용한 경우
                              signalProgressAlert(context, "todaySignal");
                            }
                          },
                        )
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.95,
                      height: MediaQuery.of(context).size.height * 0.23,
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
                                                      '준비중입니다!',
                                                      style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 24, color: Colors.grey),
                                                    ),
                                                    Icon(
                                                      Icons.keyboard_arrow_right,
                                                      color: Colors.grey,
                                                      size: 30,
                                                    ),
                                                  ],
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                                                  child: Text(
                                                    '조금만 기다려주세요.',
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
                                                      padding: const EdgeInsets.fromLTRB(0, 0, 60, 55),
                                                      onPressed: () async {

                                                      },
                                                      icon: Icon(
                                                        FontAwesomeIcons.hourglassHalf,
                                                        color: Colors.grey,
                                                        size: 70,
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
                            onTap: () {},
                          )
                      ),
                    ),
                  ],
                ),
              ],
            )
          ),
        ),
      ),
    );
  }

  _signalCheckProgress(String category) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var accessToken = pref.getString(Glob.accessToken);
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
    if (coupleUnResolvedSignalDto.hasUnResolved == false) {
      hasUnResolved = false;
      return false;
    } else {
      hasUnResolved = true;

      if (category == "eatSignal") {
        eatSignalSeq = (coupleUnResolvedSignalDto.eatSignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.eatSignalSeq.toString()) : 0;
        playSignalSeq = (coupleUnResolvedSignalDto.playSignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.playSignalSeq.toString()) : 0;
        messageOfTheDaySeq = (coupleUnResolvedSignalDto.messageOfTheDaySeq != 0) ? int.parse(coupleUnResolvedSignalDto.messageOfTheDaySeq.toString()) : 0;
        todaySignalSeq = (coupleUnResolvedSignalDto.todaySignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.todaySignalSeq.toString()) : 0;

        if (eatSignalSeq != 0) {
          return true;
        } else {
          return false;
        }
      } else if (category == "playSignal") {
        eatSignalSeq = (coupleUnResolvedSignalDto.eatSignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.eatSignalSeq.toString()) : 0;
        playSignalSeq = (coupleUnResolvedSignalDto.playSignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.playSignalSeq.toString()) : 0;
        messageOfTheDaySeq = (coupleUnResolvedSignalDto.messageOfTheDaySeq != 0) ? int.parse(coupleUnResolvedSignalDto.messageOfTheDaySeq.toString()) : 0;
        todaySignalSeq = (coupleUnResolvedSignalDto.todaySignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.todaySignalSeq.toString()) : 0;

        if (playSignalSeq != 0) {
          return true;
        } else {
          return false;
        }
      } else if (category == 'messageOfTheDay') {
        eatSignalSeq = (coupleUnResolvedSignalDto.eatSignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.eatSignalSeq.toString()) : 0;
        playSignalSeq = (coupleUnResolvedSignalDto.playSignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.playSignalSeq.toString()) : 0;
        messageOfTheDaySeq = (coupleUnResolvedSignalDto.messageOfTheDaySeq != 0) ? int.parse(coupleUnResolvedSignalDto.messageOfTheDaySeq.toString()) : 0;
        todaySignalSeq = (coupleUnResolvedSignalDto.todaySignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.todaySignalSeq.toString()) : 0;

        if (messageOfTheDaySeq != 0) {
          return true;
        } else {
          return false;
        }
      } else {
        eatSignalSeq = (coupleUnResolvedSignalDto.eatSignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.eatSignalSeq.toString()) : 0;
        playSignalSeq = (coupleUnResolvedSignalDto.playSignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.playSignalSeq.toString()) : 0;
        messageOfTheDaySeq = (coupleUnResolvedSignalDto.messageOfTheDaySeq != 0) ? int.parse(coupleUnResolvedSignalDto.messageOfTheDaySeq.toString()) : 0;
        todaySignalSeq = (coupleUnResolvedSignalDto.todaySignalSeq != 0) ? int.parse(coupleUnResolvedSignalDto.todaySignalSeq.toString()) : 0;

        if (todaySignalSeq != 0) {
          return true;
        } else {
          return false;
        }
      }
    }
  }

  signalProgressAlert(BuildContext context, String category) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            '진행 불가',
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
        children: [
          (category == 'messageOfTheDay' || category == 'todaySignal') ?
          Text(
            '오늘 전송 횟수를 초과했어요.\n시그널 진행상황을 확인해주세요!',
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.center,
          ) :
          Text(
            '이미 진행중인 시그널이 있어요.\n시그널 진행상황을 확인해주세요!',
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(
            '확인',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: () async {
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

            Navigator.of(context).pop();
            Navigator.push(context, MaterialPageRoute(builder: (context) => SignalProgress(
              hasUnResolved: hasUnResolved,
              eatSignalSeq: int.parse(coupleUnResolvedSignalDto.eatSignalSeq.toString()),
              playSignalSeq: int.parse(coupleUnResolvedSignalDto.playSignalSeq.toString()),
              messageOfTheDaySeq: messageOfTheDaySeq,
              todaySignalSeq: _todaySignalSeq,
            )));
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
