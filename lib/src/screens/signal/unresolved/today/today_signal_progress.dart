import 'package:couple_signal/src/models/signal/today/today_signal_dto.dart';
import 'package:couple_signal/src/service/global_func.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../models/global/global_variable.dart';
import '../../../../models/info/my_profile_info.dart';
import '../../../../models/kakao/kakao_share_manager.dart';
import '../../../../models/signal/today/today_signal.dart';
import '../../../../models/signal/today/today_signal_questions_dto.dart';
import '../../today/today_signal_main.dart';
import '../../today/today_signal_question1.dart';

int _memberSeq = 0;
Map<String, dynamic> myTurnData = new Map<String, dynamic>();

class TodaySignalProgress extends StatefulWidget {
  const TodaySignalProgress({Key? key}) : super(key: key);

  @override
  State<TodaySignalProgress> createState() => _TodaySignalProgressState();
}

class _TodaySignalProgressState extends State<TodaySignalProgress> {
  @override
  void initState() {
    super.initState();
    _getMemberSeq();
  }

  @override
  Widget build(BuildContext context) {
    TodaySignal _todaySignal = Provider.of<TodaySignal>(context, listen: false);
    MyProfileInfo _myProfileInfo = Provider.of<MyProfileInfo>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "오늘의 시그널 현황보기",
          style: Theme.of(context).textTheme.bodyText1,
        ),
        elevation: 0.0,
      ),
      body: FutureBuilder(
        future: _todaySignal.getIsMyTurn(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator()
                  ],
                )
              ),
            );
          } else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Error: ${snapshot.error}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            );
          } else {
            myTurnData = snapshot.data;

            int _todaySignalSeq = int.parse(myTurnData['todaySignalSeq'].toString());
            bool _isMyTurn = (myTurnData['isMyTurn'].toString() == 'Y') ? true : false;
            bool _isComplete = (myTurnData['isComplete'].toString() == 'Y') ? true : false;

            /// 오늘의 시그널을 이용하지 않은 경우
            if (_todaySignalSeq == 0 && _isMyTurn == true && _isComplete == false) {
              return Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height * 0.15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.40,
                        height: MediaQuery.of(context).size.height * 0.30,
                        child: OverflowBox(
                          minHeight: MediaQuery.of(context).size.height * 0.30,
                          maxHeight: MediaQuery.of(context).size.height * 0.30,
                          minWidth: MediaQuery.of(context).size.width * 0.40,
                          maxWidth: MediaQuery.of(context).size.width * 0.40,
                          child: Lottie.asset(
                            'images/json/icon/icon_today_signal.json',
                            width: MediaQuery.of(context).size.width * 0.40,
                            height: MediaQuery.of(context).size.height * 0.30
                          ),
                        ),
                      ),
                    ),
                    // SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                    Center(
                      child: Text(
                        '오늘의 시그널 이력이 없네요!',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.09,),
                    Center(
                      child: Text(
                        '오늘의 시그널을 보내고\n우리의 점수를 확인해보세요!',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    TextButton(
                      child: Text(
                        '시그널 보내기',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xffFE9BE6),
                        primary: Colors.white,
                        padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.30, 12, MediaQuery.of(context).size.width * 0.30, 12)
                      ),
                      onPressed: () async {
                        List<TodaySignalQuestionsDto> questionList = await _todaySignal.getTodaySignalQuestions('sender', _todaySignalSeq);
                        _todaySignal.setTodaySignalSeq = _todaySignalSeq;
                        _todaySignal.setPosition = 'sender';
                        _todaySignal.setAllQuestionList = questionList;

                        Navigator.push(context, MaterialPageRoute(builder: (context) => TodaySignalQuestion1(position: 'sender', questionList: questionList, todaySignalSeq: _todaySignalSeq,)));
                      },
                    )
                  ],
                ),
              );
            } else if (_todaySignalSeq != 0 && _isMyTurn == false && _isComplete == true) {
              /// 오늘의 시그널을 모두 이용한 경우
              return FutureBuilder(
                future: _todaySignal.getTodaySignal(_todaySignalSeq),
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
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    );
                  } else {
                    TodaySignalDto signalDto = snapshot.data;
                    String finalScore = signalDto.finalScore.toString();

                    return Container(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height * 0.15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Lottie.asset(
                              'images/json/icon/icon_today_signal.json',
                              width: MediaQuery.of(context).size.width * 0.50,
                              height: MediaQuery.of(context).size.height * 0.35,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            // color: const Color(0xffFFF7F3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.1, 0, 0, 0),
                                    child: Column(
                                      children: [
                                        (_myProfileInfo.myProfileImgAddr.toString() == 'null') ?
                                        CircleAvatar(
                                          radius: MediaQuery.of(context).size.width * 0.07,
                                          backgroundImage: AssetImage('images/basic_profile_img.jpg'),
                                        ) :
                                        CircleAvatar(
                                          radius: MediaQuery.of(context).size.width * 0.07,
                                          backgroundImage: NetworkImage(_myProfileInfo.getMyProfileImgUrl),
                                        ),
                                        SizedBox(height: 10.0,),
                                        Text(
                                          _myProfileInfo.getNickName,
                                          style: Theme.of(context).textTheme.bodyText2,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Expanded(
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.12,
                                          height: MediaQuery.of(context).size.height * 0.08,
                                          child: OverflowBox(
                                            minHeight: MediaQuery.of(context).size.height * 0.08,
                                            maxHeight: MediaQuery.of(context).size.height * 0.08,
                                            minWidth: MediaQuery.of(context).size.width * 0.12,
                                            maxWidth: MediaQuery.of(context).size.width * 0.12,
                                            child: Lottie.asset(
                                              'images/json/icon/icon_heart.json',
                                              width: MediaQuery.of(context).size.width * 0.12,
                                              height: MediaQuery.of(context).size.height * 0.08
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: MediaQuery.of(context).size.height * 0.002,),
                                        Text(
                                          '$finalScore점',
                                          style: Theme.of(context).textTheme.bodyText1,
                                        )
                                      ],
                                    )
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(0, 0, MediaQuery.of(context).size.width * 0.1, 0),
                                    child: Column(
                                      children: [
                                        (_myProfileInfo.coupleProfileImgAddr.toString() == 'null') ?
                                        CircleAvatar(
                                          radius: MediaQuery.of(context).size.width * 0.07,
                                          backgroundImage: AssetImage('images/basic_profile_img.jpg'),
                                        ) :
                                        CircleAvatar(
                                          radius: MediaQuery.of(context).size.width * 0.07,
                                          backgroundImage: NetworkImage(_myProfileInfo.getCoupleProfileImgUrl),
                                        ),
                                        SizedBox(height: 10.0,),
                                        Text(
                                          _myProfileInfo.coupleNickName.toString(),
                                          style: Theme.of(context).textTheme.bodyText2,
                                        )
                                      ],
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: MediaQuery.of(context).size.height * 0.09,),
                          Center(
                            child: Text(
                              '우리의 점수를 친구 커플에게 공유해봐요!',
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          TextButton(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              height: MediaQuery.of(context).size.height * 0.06,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                // color: Colors.yellow
                                // 카카오 색
                                color: const Color(0xffFEE500)
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
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 1, 0, 0),
                                    child: Text(
                                      '카카오톡 공유하기',
                                      style: Theme.of(context).textTheme.bodyText2!.copyWith(color: const Color(0xff3C1E1E),),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            onPressed: () {
                              /// 공유하기
                              KakaoShareManager().isKakaotalkInstalled().then((installed) {
                                if (installed) {
                                  KakaoShareManager().shareMyCode(_myProfileInfo.nickName.toString(), _myProfileInfo.coupleNickName.toString(), int.parse(finalScore));
                                } else {
                                }
                              });
                            },
                          )
                        ],
                      ),
                    );
                  }
                },
              );
            } else if (_todaySignalSeq != 0 && _isMyTurn == true && _isComplete == false) {
              /// 오늘의 시그널을 이용했고 내 차례인 경우
              return Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height * 0.15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.40,
                        height: MediaQuery.of(context).size.height * 0.30,
                        child: OverflowBox(
                          minHeight: MediaQuery.of(context).size.height * 0.30,
                          maxHeight: MediaQuery.of(context).size.height * 0.30,
                          minWidth: MediaQuery.of(context).size.width * 0.40,
                          maxWidth: MediaQuery.of(context).size.width * 0.40,
                          child: Lottie.asset(
                            'images/json/icon/icon_today_signal.json',
                            width: MediaQuery.of(context).size.width * 0.40,
                            height: MediaQuery.of(context).size.height * 0.30
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        '상대방이 시그널을 보냈어요!\n오늘의 시그널에 답변해주세요!',
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(height: 10.0,),
                    TextButton(
                      child: Text(
                        '시그널 보내기',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xffFE9BE6),
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.15, vertical: MediaQuery.of(context).size.height * 0.013)
                      ),
                      onPressed: () async {
                        /// 받은 seq 를 가지고 조회해서 todaySignal 로 넘기기
                        String _position = 'recipient';
                        List<TodaySignalQuestionsDto> _questionList = await _todaySignal.getTodaySignalQuestions(_position, _todaySignalSeq);

                        Navigator.push(context, MaterialPageRoute(builder: (context) => TodaySignalQuestion1(position: _position, questionList: _questionList, todaySignalSeq: _todaySignalSeq)));
                      },
                    )
                  ],
                ),
              );

            } else if (_todaySignalSeq != 0 && _isMyTurn == false && _isComplete == false) {
              /// 오늘의 시그널을 이용했고 상대 차례인 경우
              return Container(
                padding: EdgeInsets.fromLTRB(0, 0, 0, MediaQuery.of(context).size.height * 0.15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.40,
                        height: MediaQuery.of(context).size.height * 0.30,
                        child: OverflowBox(
                          minHeight: MediaQuery.of(context).size.height * 0.30,
                          maxHeight: MediaQuery.of(context).size.height * 0.30,
                          minWidth: MediaQuery.of(context).size.width * 0.40,
                          maxWidth: MediaQuery.of(context).size.width * 0.40,
                          child: Lottie.asset(
                            'images/json/icon/icon_today_signal.json',
                            width: MediaQuery.of(context).size.width * 0.40,
                            height: MediaQuery.of(context).size.height * 0.30
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        '상대방의 답변을 기다리고 있어요!',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                    Center(
                      child: Text(
                        '조금만 기다려주세요!',
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
                    TextButton(
                      child: Text(
                        '뒤로가기',
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                      ),
                      style: TextButton.styleFrom(
                          backgroundColor: const Color(0xffFE9BE6),
                          padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.13, vertical: MediaQuery.of(context).size.height * 0.01)
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                      },
                    )
                    // TextButton(
                    //   child: Text(
                    //     '상대방 조르기',
                    //     style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                    //   ),
                    //   style: TextButton.styleFrom(
                    //       backgroundColor: const Color(0xffFE9BE6),
                    //       padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.13, vertical: MediaQuery.of(context).size.height * 0.02)
                    //   ),
                    //   onPressed: () async {
                    //
                    //   },
                    // )
                  ],
                ),
              );
            } else {
              /// 여기는 나오면 안되는 경우이며 혹시라도 나오게 된다면 errorLog 작성
              GlobalFunc().setErrorLog('today_signal_progress.dart 오늘의 시그널 현황보기 else 인 경우');
              return Container(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        ''
                      ),
                    )
                  ],
                ),
              );
            }
          }
        }
      ),
    );
  }

  _getMemberSeq() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int memberSeq = int.parse(pref.getInt(Glob.memberSeq).toString());
    _memberSeq = memberSeq;
  }
}
