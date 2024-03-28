import 'package:couple_signal/src/models/signal/today/today_signal_questions_dto.dart';
import 'package:couple_signal/src/screens/signal/today/today_signal_question1.dart';
import 'package:couple_signal/src/service/global_func.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

import '../../../models/signal/today/today_signal.dart';

class TodaySignalMain extends StatelessWidget {
  const TodaySignalMain({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TodaySignal _todaySignal = Provider.of<TodaySignal>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          '오늘의 시그널',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        elevation: 0.0,
      ),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text(
                '오늘 우리의 시그널 점수는?',
                style: Theme.of(context).textTheme.bodyText1,
              ),
            ),
            Center(
              child: Lottie.asset(
                'images/json/icon/icon_today_signal.json',
                width: MediaQuery.of(context).size.width * 0.55,
                height: MediaQuery.of(context).size.height * 0.45,
              ),
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '10가지 문제를 풀고',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ]
                ),
              ),
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '오늘 우리의 ',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(height: 1.5),
                    ),
                    TextSpan(
                      text: '시그널 점수를',
                      style: Theme.of(context).textTheme.bodyText1!.copyWith(color: const Color(0xffFE9BE6)),
                    ),
                  ]
                ),
              ),
            ),
            Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '확인해보세요!',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ]
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.05,),
            Center(
              child: TextButton(
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
                  var result = await _todaySignal.getIsMyTurn();

                  int _todaySignalSeq = int.parse(result['todaySignalSeq'].toString());
                  String _isMyTurn = result['isMyTurn'];
                  String _isComplete = result['isComplete'];
                  String _position = '';

                  /// position == sender, 오늘 첫 시도
                  if (_todaySignalSeq == 0 && _isMyTurn == 'Y' && _isComplete == 'N') {
                    _position = 'sender';
                    /// 파라미터로 넘겨서 FutureBuilder 를 사용할 경우 radio button 의 setState 때문에 FutureBuilder 가 계속 호출되어 여기서 호출해서 가져가야함
                    List<TodaySignalQuestionsDto> questionList = await _todaySignal.getTodaySignalQuestions('sender', _todaySignalSeq);
                    _todaySignal.setTodaySignalSeq = _todaySignalSeq;
                    _todaySignal.setPosition = 'sender';
                    _todaySignal.setAllQuestionList = questionList;

                    Navigator.push(context, MaterialPageRoute(builder: (context) => TodaySignalQuestion1(position: 'sender', questionList: questionList, todaySignalSeq: _todaySignalSeq,)));
                  } else if (_todaySignalSeq != 0 && _isMyTurn == 'Y' && _isComplete == 'N') {
                    /// position == recipient, 내 차례
                    _position = 'recipient';
                    List<TodaySignalQuestionsDto> questionList = await _todaySignal.getTodaySignalQuestions('recipient', _todaySignalSeq);
                    _todaySignal.setTodaySignalSeq = _todaySignalSeq;
                    _todaySignal.setPosition = 'recipient';
                    _todaySignal.setAllQuestionList = questionList;

                    Navigator.push(context, MaterialPageRoute(builder: (context) => TodaySignalQuestion1(position: 'recipient', questionList: questionList, todaySignalSeq: _todaySignalSeq,)));
                  } else if (_todaySignalSeq != 0 && _isMyTurn == 'N' && _isComplete == 'N') {
                    /// 내 차례는 아니지만 상대방이 아직 답변을 하지 않은 경우
                    _position = 'sender';
                    /// alert type 1
                    _todaySignalProgressAlert(context, 1);
                  } else if (_todaySignalSeq == 0 && _isMyTurn == 'N' && _isComplete == 'Y') {
                    /// 오늘의 시그널 기능을 오늘 모두 이용한 경우
                    _todaySignalProgressAlert(context, 2);
                  } else {
                    GlobalFunc().setErrorLog('today_signal_main.dart 시그널 보내기 버튼 else 일 때');
                  }
                },
              )
            )
          ],
        ),
      ),
    );
  }
  _todaySignalProgressAlert(BuildContext context, int alertType) async {
    /// alert type 1은 sender 가 보낸 후 recipient 가 아직 전송을 안한 상태
    /// alert type 2는 오늘 기회를 모두 소진한 상태
    String _message = '';

    if (alertType == 1) {
      _message = '상대방의 답변을 기다리고 있어요!';
    } else {
      _message = '오늘 전송 횟수를 초과했어요.\n시그널 진행상황을 확인해주세요!';
    }

    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "진행 불가",
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
        _message,
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
}
