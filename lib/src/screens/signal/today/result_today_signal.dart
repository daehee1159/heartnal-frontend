import 'dart:convert';

import 'package:couple_signal/src/models/signal/today/today_signal_dto.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../models/global/global_variable.dart';
import '../../../models/info/my_profile_info.dart';
import '../../../models/kakao/kakao_share_manager.dart';
import '../../../models/signal/today/today_signal.dart';
import '../../../signal/today_signal_result_message_type.dart';
import '../../home.dart';

int _memberSeq = 0;

class ResultTodaySignal extends StatefulWidget {
  final int todaySignalSeq;
  const ResultTodaySignal({Key? key, required this.todaySignalSeq}) : super(key: key);

  @override
  State<ResultTodaySignal> createState() => _ResultTodaySignalState();
}

class _ResultTodaySignalState extends State<ResultTodaySignal> {
  @override
  void initState() {
    _getMemberSeq();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    TodaySignal _todaySignal = Provider.of<TodaySignal>(context, listen: false);
    MyProfileInfo _myProfileInfo = Provider.of<MyProfileInfo>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '오늘의 시그널 결과',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        elevation: 0.0,
      ),
      body: FutureBuilder(
        future: _todaySignal.getTodaySignal(this.widget.todaySignalSeq),
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
            TodaySignalDto todaySignalDto = snapshot.data;

            String _resultMessage = '';
            int finalScore = int.parse(todaySignalDto.finalScore.toString());

            /// 60점 이하일 때
            if (finalScore >= 0 && finalScore <= 60) {
              _resultMessage = TodaySignalResultMessageType.score60.convertText;
            } else if (finalScore > 60 && finalScore <= 90) {
              /// 60점 < 90점
              _resultMessage = TodaySignalResultMessageType.score90.convertText;
            } else {
              /// 100점
              _resultMessage = TodaySignalResultMessageType.score100.convertText;
            }

            return Container(
              // padding: const EdgeInsets.all(10.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Lottie.asset(
                      'images/json/icon/icon_today_signal.json',
                      width: MediaQuery.of(context).size.width * 0.50,
                      height: MediaQuery.of(context).size.height * 0.35,
                    ),
                  ),
                  (int.parse(todaySignalDto.senderMemberSeq.toString()) == _memberSeq) ?
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
                                todaySignalDto.finalScore.toString() + '점',
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
                  ) :
                  Container(
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.1, 0, 0, 0),
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
                                todaySignalDto.finalScore.toString() + '점',
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
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                  Container(
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Center(
                      child: Text(
                        _resultMessage,
                        style: Theme.of(context).textTheme.bodyText1,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
                  /// 투두 버튼 사이즈 조정 해야함
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Center(
                      child: TextButton(
                        child: Text(
                          "메인",
                          style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                        ),
                        style: TextButton.styleFrom(
                          backgroundColor: const Color(0xffFE9BE6),
                          minimumSize: Size.fromHeight(50),
                        ),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(routePage: 0,)));
                        },
                      )
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
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
                          KakaoShareManager().shareMyCode(_myProfileInfo.nickName.toString(), _myProfileInfo.coupleNickName.toString(), int.parse(todaySignalDto.finalScore.toString()));
                          print('카카오톡 설치!!');
                        } else {
                          print('카카오톡 미설치!!');
                        }
                      });
                    },
                  )
                ],
              ),
            );
          }
        },
      )
    );
  }

  _getMemberSeq() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    int memberSeq = int.parse(pref.getInt(Glob.memberSeq).toString());
    _memberSeq = memberSeq;
  }
}
