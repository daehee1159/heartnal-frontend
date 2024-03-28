import 'dart:io';

import 'package:couple_signal/src/models/signal/today/today_signal_dto.dart';
import 'package:couple_signal/src/screens/signal/today/today_signal_question2.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/signal/today/today_signal.dart';
import '../../../models/signal/today/today_signal_questions_dto.dart';

String _answer1 = '';
String _answer2 = '';
String _answer3 = '';
String _answer4 = '';
String _answer5 = '';
String _selected = '';

int _answerIndex1 = 0;
int _answerIndex2 = 0;
int _answerIndex3 = 0;
int _answerIndex4 = 0;
int _answerIndex5 = 0;

// sender 일 때 전체 리스트
List<TodaySignalQuestionsDto> allQuestionList = [];
// recipient 일 때 sender 의 리스트
TodaySignalDto todaySignalDto = new TodaySignalDto();

class TodaySignalQuestion1 extends StatefulWidget {
  final String position;
  final List<TodaySignalQuestionsDto> questionList;
  final int todaySignalSeq;
  const TodaySignalQuestion1({Key? key, required this.position, required this.questionList, required this.todaySignalSeq}) : super(key: key);

  @override
  State<TodaySignalQuestion1> createState() => _TodaySignalQuestion1State();
}

class _TodaySignalQuestion1State extends State<TodaySignalQuestion1> {
  @override
  Widget build(BuildContext context) {
    TodaySignal _todaySignal = Provider.of<TodaySignal>(context, listen: false);

    // TodaySignalQuestion1 List
    List<TodaySignalQuestionsDto> _questionList = [];

    // TodaySignalQuestion2 에 넘겨줄 List
    List<TodaySignalQuestionsDto> _parameterList = [];

    _questionList = this.widget.questionList.sublist(0, 5);
    _parameterList = this.widget.questionList.sublist(5, 10);

    List<String> answerList1 = [];
    List<String> answerList2 = [];
    List<String> answerList3 = [];
    List<String> answerList4 = [];
    List<String> answerList5 = [];

    for (int i = 0; i < _questionList.length; i++) {
      for (int j = 0; j < _questionList[i].answerList!.length; j++) {
        switch (i) {
          case 0:
            answerList1.add(_questionList[i].answerList![j].toString());
            break;
          case 1:
            answerList2.add(_questionList[i].answerList![j].toString());
            break;
          case 2:
            answerList3.add(_questionList[i].answerList![j].toString());
            break;
          case 3:
            answerList4.add(_questionList[i].answerList![j].toString());
            break;
          case 4:
            answerList5.add(_questionList[i].answerList![j].toString());
            break;
        }
      }
    }

    return WillPopScope(
      onWillPop: () async {
        /// 뒤로가기 눌렀을 때 초기화
        _answerIndex1 = 0;
        _answerIndex2 = 0;
        _answerIndex3 = 0;
        _answerIndex4 = 0;
        _answerIndex5 = 0;

        answerList1 = [];
        answerList2 = [];
        answerList3 = [];
        answerList4 = [];
        answerList5 = [];

        _todaySignal.initAnswerList = [];
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            '오늘의 시그널 질문지',
            style: Theme.of(context).textTheme.bodyText1,
          ),
          backgroundColor: const Color(0xffFFF8FA),
          elevation: 1.0,
        ),
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                _listTileWidget(1, _questionList[0].question.toString(), answerList1, context),
                _listTileWidget(2, _questionList[1].question.toString(), answerList2, context),
                _listTileWidget(3, _questionList[2].question.toString(), answerList3, context),
                _listTileWidget(4, _questionList[3].question.toString(), answerList4, context),
                _listTileWidget(5, _questionList[4].question.toString(), answerList5, context),
                SizedBox(height: 10.0,),
                TextButton(
                  child: Text(
                    '다음 페이지',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.white),
                  ),
                  style: TextButton.styleFrom(
                    backgroundColor: const Color(0xffFE9BE6),
                    primary: Colors.white,
                    padding: EdgeInsets.fromLTRB(MediaQuery.of(context).size.width * 0.30, 12, MediaQuery.of(context).size.width * 0.30, 12)
                  ),
                  onPressed: () {
                    // answer list init
                    _todaySignal.initAnswerList = [];
                    bool _isToTheNext = false;

                    /// 다음 페이지로 넘어가기 전 provider 에 이번 페이지에서 작성한 5개는 저장해둬야 함
                    List<String> _answerList = [];
                    List<String> _notSelectList = [];
                    /// 이걸 맵에 담아주는게 맞는지 그냥 리스트로 해버리는게 나은지

                    (_answerIndex1 == 0) ? _notSelectList.add(1.toString()) : _answerList.add(_answerIndex1.toString());
                    (_answerIndex2 == 0) ? _notSelectList.add(2.toString()) : _answerList.add(_answerIndex2.toString());
                    (_answerIndex3 == 0) ? _notSelectList.add(3.toString()) : _answerList.add(_answerIndex3.toString());
                    (_answerIndex4 == 0) ? _notSelectList.add(4.toString()) : _answerList.add(_answerIndex4.toString());
                    (_answerIndex5 == 0) ? _notSelectList.add(5.toString()) : _answerList.add(_answerIndex5.toString());

                    _todaySignal.setAnswerList = _answerList;

                    if (_notSelectList.length == 0) {
                      _isToTheNext = true;
                    } else {
                      _isToTheNext = false;
                    }

                    if (_isToTheNext == true) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TodaySignalQuestion2()));
                    } else {
                      return _notSelectAlert(context, _notSelectList);
                    }
                  },
                ),
                (Platform.isIOS) ?
                SizedBox(height: MediaQuery.of(context).size.height * 0.03,) :
                SizedBox(height: 10.0,),
              ],
            ),
          ),
        )
      ),
    );
  }

  _listTileWidget(int questionNumber, String question, List<String> answerList, BuildContext context) {
    _groupValue(int index) {
      switch(index) {
        case 1:
          return _answer1;
        case 2:
          return _answer2;
        case 3:
          return _answer3;
        case 4:
          return _answer4;
        case 5:
          return _answer5;
      }
    }

    List<String> questionList = [];
    if (question.contains('vs')) {
      questionList = question.split('vs');
    }

    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height * 0.18,
          color: const Color(0xffFFF8FA),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: (question.contains('vs')) ?
                Text(
                  questionList[0] + '\nVS\n' + questionList[1].trim(),
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.8, fontSize: 17),
                  textAlign: TextAlign.center,
                ) :
                Text(
                  question,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.8, fontSize: 17),
                  textAlign: TextAlign.center,
                ),
            ),
          ),
        ),
        ListView.builder(
            shrinkWrap: true,
            itemCount: answerList.length,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                children: [
                  RadioListTile(
                    controlAffinity: ListTileControlAffinity.trailing,
                    title: Text(
                      answerList[index],
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    value: answerList[index],
                    groupValue: _groupValue(questionNumber),
                    onChanged: (value) {
                      setState(() {
                        switch(questionNumber) {
                          case 1:
                            _answer1 = answerList[index];
                            _answerIndex1 = index +1;
                            break;
                          case 2:
                            _answer2 = answerList[index];
                            _answerIndex2 = index +1;
                            break;
                          case 3:
                            _answer3 = answerList[index];
                            _answerIndex3 = index +1;
                            break;
                          case 4:
                            _answer4 = answerList[index];
                            _answerIndex4 = index +1;
                            break;
                          case 5:
                            _answer5 = answerList[index];
                            _answerIndex5 = index +1;
                            break;
                        }
                      });
                    },
                  ),
                  (index == answerList.length -1) ?
                  Container():
                  Divider(height: 1,)
                ],
              );
            }
        )
      ],
    );
  }
  _notSelectAlert(BuildContext context, List<String> notSelectList) async {
    /// alert type 1은 sender 가 보낸 후 recipient 가 아직 전송을 안한 상태
    /// alert type 2는 오늘 기회를 모두 소진한 상태
    String message = '';

    for (int i = 0; i < notSelectList.length; i++) {
      if (i == 0) {
        message = message + notSelectList[i].toString();
      } else {
        message = message + ',' + notSelectList[i].toString();
      }
    }

    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "답변 미선택",
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
        '선택하지 않은 답변이 있어요!\n미선택 리스트 = $message',
        style: Theme.of(context).textTheme.bodyText2!.copyWith(height: 1.5),
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
