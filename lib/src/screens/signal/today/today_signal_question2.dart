import 'dart:io';

import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/models/signal/today/today_signal.dart';
import 'package:couple_signal/src/service/global_func.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../../models/signal/today/today_signal_questions_dto.dart';
import '../../home.dart';

String _answer6 = '';
String _answer7 = '';
String _answer8 = '';
String _answer9 = '';
String _answer10 = '';

int _answerIndex6 = 0;
int _answerIndex7 = 0;
int _answerIndex8 = 0;
int _answerIndex9 = 0;
int _answerIndex10 = 0;

class TodaySignalQuestion2 extends StatefulWidget {
  const TodaySignalQuestion2({Key? key,}) : super(key: key);

  @override
  State<TodaySignalQuestion2> createState() => _TodaySignalQuestion2State();
}

class _TodaySignalQuestion2State extends State<TodaySignalQuestion2> {
  @override
  Widget build(BuildContext context) {
    TodaySignal _todaySignal = Provider.of<TodaySignal>(context, listen: false);

    // TodaySignalQuestion1 List
    List<TodaySignalQuestionsDto> _questionList = [];

    // TodaySignalQuestion2 에 넘겨줄 List
    List<TodaySignalQuestionsDto> _parameterList = [];

    _questionList = _todaySignal.getAllQuestionList.sublist(0, 5);
    _parameterList = _todaySignal.getAllQuestionList.sublist(5, 10);

    List<String> answerList1 = [];
    List<String> answerList2 = [];
    List<String> answerList3 = [];
    List<String> answerList4 = [];
    List<String> answerList5 = [];

    for (int i = 0; i < _parameterList.length; i++) {
      for (int j = 0; j < _parameterList[i].answerList!.length; j++) {
        switch (i) {
          case 0:
            answerList1.add(_parameterList[i].answerList![j].toString());
            break;
          case 1:
            answerList2.add(_parameterList[i].answerList![j].toString());
            break;
          case 2:
            answerList3.add(_parameterList[i].answerList![j].toString());
            break;
          case 3:
            answerList4.add(_parameterList[i].answerList![j].toString());
            break;
          case 4:
            answerList5.add(_parameterList[i].answerList![j].toString());
            break;
        }
      }
    }

    return Scaffold(
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
              _listTileWidget(6, _parameterList[0].question.toString(), answerList1, context),
              _listTileWidget(7, _parameterList[1].question.toString(), answerList2, context),
              _listTileWidget(8, _parameterList[2].question.toString(), answerList3, context),
              _listTileWidget(9, _parameterList[3].question.toString(), answerList4, context),
              _listTileWidget(10, _parameterList[4].question.toString(), answerList5, context),
              SizedBox(height: 10.0,),
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
                  GlobalAlert().onLoading(context);

                  bool _isComplete = false;

                  List<String> _answerList = [];
                  List<String> _notSelectList = [];

                  (_answerIndex6 == 0) ? _notSelectList.add(1.toString()) : _answerList.add(_answerIndex6.toString());
                  (_answerIndex7 == 0) ? _notSelectList.add(2.toString()) : _answerList.add(_answerIndex7.toString());
                  (_answerIndex8 == 0) ? _notSelectList.add(3.toString()) : _answerList.add(_answerIndex8.toString());
                  (_answerIndex9 == 0) ? _notSelectList.add(4.toString()) : _answerList.add(_answerIndex9.toString());
                  (_answerIndex10 == 0) ? _notSelectList.add(5.toString()) : _answerList.add(_answerIndex10.toString());

                  if (_notSelectList.length == 0) {
                    _isComplete = true;
                    _todaySignal.setAnswerList = _answerList;
                  } else {
                    _isComplete = false;
                    return _notSelectAlert(context, _notSelectList);
                  }

                  bool result = false;

                  if (_todaySignal.getPosition == 'sender') {
                    List<String> questionList = [];
                    /// questionSeq list 를 따로 만들지 않았기 때문에 여기서 만들어서 파라미터로 넘겨줌
                    for (int i = 0; i < _todaySignal.getAllQuestionList.length; i++) {
                      questionList.add(_todaySignal.getAllQuestionList[i].todaySignalQuestionSeq.toString());
                    }
                    result = await _todaySignal.setTodaySignal(_todaySignal.getTodaySignalSeq, questionList, _todaySignal.getAnswerList, _todaySignal.getPosition);
                  } else {
                    result = await _todaySignal.setTodaySignal(_todaySignal.getTodaySignalSeq, [], _todaySignal.getAnswerList, _todaySignal.getPosition);
                  }

                  if (result) {
                    if (_todaySignal.getPosition == 'sender') {
                      /// set 성공 후 provider answer list 초기화
                      _todaySignal.initAnswerList = [];
                      await Future.delayed(Duration(seconds: 2));
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(routePage: 0,)));
                      return GlobalAlert().globSignalSuccessAlert(context);
                    } else {
                      /// recipient 의 경우 성공 alert 를 띄우게 되면 fcm 후 받는 alert 와 겹치게 되므로 성공 alert 빼줬음
                      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(routePage: 0,)));
                    }
                  } else {
                    GlobalFunc().setErrorLog('setTodaySignal Error!!' + result.toString());
                    await Future.delayed(Duration(seconds: 2));
                    return GlobalAlert().globErrorAlert(context);
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
    );
  }

  _listTileWidget(int questionNumber, String question, List<String> answerList, BuildContext context) {
    _groupValue(int index) {
      switch(index) {
        case 6:
          return _answer6;
        case 7:
          return _answer7;
        case 8:
          return _answer8;
        case 9:
          return _answer9;
        case 10:
          return _answer10;
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
                          case 6:
                            _answer6 = answerList[index];
                            _answerIndex6 = index +1;
                            break;
                          case 7:
                            _answer7 = answerList[index];
                            _answerIndex7 = index +1;
                            break;
                          case 8:
                            _answer8 = answerList[index];
                            _answerIndex8 = index +1;
                            break;
                          case 9:
                            _answer9 = answerList[index];
                            _answerIndex9 = index +1;
                            break;
                          case 10:
                            _answer10 = answerList[index];
                            _answerIndex10 = index +1;
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
