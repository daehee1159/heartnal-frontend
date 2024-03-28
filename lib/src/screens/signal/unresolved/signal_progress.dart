import 'dart:convert';

import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/signal/check_my_turn_dto.dart';
import 'package:couple_signal/src/models/signal/check_signal_dto.dart';
import 'package:couple_signal/src/models/signal/signal.dart';
import 'package:couple_signal/src/models/signal/check_signal.dart';
import 'package:couple_signal/src/models/signal/temp_signal.dart';
import 'package:couple_signal/src/models/signal/unresolved_signal_dto.dart';
import 'package:couple_signal/src/screens/signal/unresolved/message/message_of_the_day_progress.dart';
import 'package:couple_signal/src/screens/signal/unresolved/signal_progress_detail.dart';
import 'package:couple_signal/src/screens/signal/unresolved/today/today_signal_progress.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get_it/get_it.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

class SignalProgress extends StatelessWidget {
  final bool hasUnResolved;
  final int eatSignalSeq;
  final int playSignalSeq;
  final int messageOfTheDaySeq;
  final int todaySignalSeq;
  const SignalProgress({Key? key, required this.hasUnResolved, required this.eatSignalSeq, required this.playSignalSeq, required this.messageOfTheDaySeq, required this.todaySignalSeq}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CheckSignal _checkSignal = Provider.of<CheckSignal>(context, listen: false);
    _eatSignalStatus(BuildContext context) {
      if (this.eatSignalSeq == 0) {
        return TextButton(
          child: Text(
            '진행중인 시그널이 없어요!',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 17.0, color: Colors.grey),
          ),
          onPressed: () {

          },
        );
      } else {
        return Padding(
          padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.01, 0, 0),
          child: TextButton(
            child: Text(
              '현황 보기',
              style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xffFE9BE6),
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.15, vertical: MediaQuery.of(context).size.height * 0.005)
            ),
            onPressed: () async {
              await _getUnResolvedSignal(context);
              /// 같은 종류의 시그널이 끝나기 전에 다시 보낼 수 없게 수정할 계획이기에 여기엔 sender, recipient 둘 중 하나만 존재함
              if (_checkSignal.getSenderEatSignalSeq != 0 && _checkSignal.getRecipientEatSignalSeq == 0) {
                _unResolvedCheckSignal('sender', 'eatSignal', _checkSignal.getSenderEatSignalSeq, context);
              } else if (_checkSignal.getSenderEatSignalSeq == 0 && _checkSignal.getRecipientEatSignalSeq != 0) {
                _unResolvedCheckSignal('recipient', 'eatSignal', _checkSignal.getRecipientEatSignalSeq, context);
              } else {
                _checkMyTurn("eatSignal", this.eatSignalSeq, context);
              }
            },
          ),
        );
      }
    }

    _playSignalStatus(BuildContext context) {
      if (this.playSignalSeq == 0) {
        return TextButton(
          child: Text(
            '진행중인 시그널이 없어요!',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 17.0, color: Colors.grey),
          ),
          onPressed: () {

          },
        );
      } else {
        return Padding(
          padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.01, 0, 0),
          child: TextButton(
            child: Text(
              '현황 보기',
              style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
            ),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xffFE9BE6),
              padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.15, vertical: MediaQuery.of(context).size.height * 0.005)
            ),
            onPressed: () async {
              await _getUnResolvedSignal(context);

              if (_checkSignal.getSenderPlaySignalSeq != 0 && _checkSignal.getRecipientPlaySignalSeq == 0) {
                _unResolvedCheckSignal('sender', 'playSignal', _checkSignal.getSenderPlaySignalSeq, context);
              } else if (_checkSignal.getSenderPlaySignalSeq == 0 && _checkSignal.getRecipientPlaySignalSeq != 0) {
                _unResolvedCheckSignal('recipient', 'playSignal', _checkSignal.getRecipientPlaySignalSeq, context);
              } else {
                _checkMyTurn("playSignal", this.playSignalSeq, context);
              }
            },
          ),
        );
      }
    }

    _messageOfTheDayStatus(BuildContext context) {
      if (this.messageOfTheDaySeq == 0) {
        return TextButton(
          child: Text(
            '진행중인 시그널이 없어요!',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 17.0, color: Colors.grey),
          ),
          onPressed: () {

          },
        );
      } else {
        return Padding(
          padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.01, 0, 0),
          child: TextButton(
            child: Text(
              '현황 보기',
              style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
            ),
            style: TextButton.styleFrom(
                backgroundColor: const Color(0xffFE9BE6),
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.15, vertical: MediaQuery.of(context).size.height * 0.005)
            ),
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => MessageOfTheDayProgress()));
            },
          ),
        );
      }
    }

    _todaySignalStatus(BuildContext context) {
      if (this.todaySignalSeq == 0) {
        return TextButton(
          child: Text(
            '진행중인 시그널이 없어요!',
            style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 17.0, color: Colors.grey),
          ),
          onPressed: () {

          },
        );
      } else {
        return Padding(
          padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.01, 0, 0),
          child: TextButton(
            child: Text(
              '현황 보기',
              style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
            ),
            style: TextButton.styleFrom(
                backgroundColor: const Color(0xffFE9BE6),
                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.15, vertical: MediaQuery.of(context).size.height * 0.005)
            ),
            onPressed: () async {
              Navigator.push(context, MaterialPageRoute(builder: (context) => TodaySignalProgress()));
            },
          ),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '시그널 현황보기',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.25,
                child: Card(
                  elevation: 4.0,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: SizedBox(
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
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.02, 0, 0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Text(
                                        "오늘 뭐먹지?",
                                        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 20),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    // SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: _eatSignalStatus(context),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.25,
                child: Card(
                  elevation: 4.0,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: SizedBox(
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
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.02, 0, 0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Text(
                                        "오늘 뭐하지?",
                                        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 20),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    // SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: _playSignalStatus(context),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.25,
                child: Card(
                  elevation: 4.0,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: SizedBox(
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
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.02, 0, 0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Text(
                                        "오늘의 한마디",
                                        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 20),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    // SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: _messageOfTheDayStatus(context),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.25,
                child: Card(
                  elevation: 4.0,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width * 0.25,
                                      height: MediaQuery.of(context).size.height * 0.13,
                                      child: OverflowBox(
                                        minHeight: MediaQuery.of(context).size.height * 0.13,
                                        maxHeight: MediaQuery.of(context).size.height * 0.13,
                                        minWidth: MediaQuery.of(context).size.width * 0.25,
                                        maxWidth: MediaQuery.of(context).size.width * 0.25,
                                        child: Lottie.asset(
                                          'images/json/icon/icon_today_signal.json',
                                          width: MediaQuery.of(context).size.width * 0.25,
                                          height: MediaQuery.of(context).size.height * 0.13
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(0, MediaQuery.of(context).size.height * 0.02, 0, 0),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Text(
                                        "오늘의 시그널",
                                        style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 20),
                                        textAlign: TextAlign.start,
                                      ),
                                    ),
                                    // SizedBox(height: MediaQuery.of(context).size.height * 0.02,),
                                    Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: _todaySignalStatus(context),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.95,
                height: MediaQuery.of(context).size.height * 0.25,
                child: Card(
                  elevation: 4.0,
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "모든 미완료건 삭제하기",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        SizedBox(height: MediaQuery.of(context).size.height * 0.01,),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: TextButton(
                            child: Text(
                              '삭제하기',
                              style: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.white),
                            ),
                            style: TextButton.styleFrom(
                                backgroundColor: const Color(0xffFE9BE6),
                                padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width * 0.2, vertical: MediaQuery.of(context).size.height * 0.005)
                            ),
                            onPressed: () async {
                              await deleteConfirmAlert(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _deleteUnresolvedSignal(BuildContext context) async {
    CheckSignal _checkSignal = Provider.of<CheckSignal>(context, listen: false);

    SharedPreferences pref = await SharedPreferences.getInstance();

    String username = pref.getString(Glob.email).toString();
    String coupleCode = pref.getString(Glob.coupleCode).toString();
    var accessToken = pref.getString(Glob.accessToken);
    var url = Uri.parse(Glob.memberUrl + '/delete/unresolved/signal');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var saveData;

    saveData = jsonEncode({
      "email": username.toString(),
      "coupleCode": coupleCode.toString()
    });

    http.Response response = await http.post(
        url,
        headers: headers,
        body: saveData
    );

    if (response.body.toString() == "true") {
      _checkSignal.setSenderEatSignalSeq = 0;
      _checkSignal.setSenderPlaySignalSeq = 0;
      _checkSignal.setRecipientEatSignalSeq = 0;
      _checkSignal.setRecipientPlaySignalSeq = 0;
      _checkSignal.setHasUnResolved = false;
    }

    return jsonDecode(response.body);
  }

  deleteConfirmAlert(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "삭제 여부 확인",
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
          // SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
          Text(
            '삭제시 복구가 불가해요.\n그래도 삭제할까요?',
            style: Theme.of(context).textTheme.bodyText2,
            textAlign: TextAlign.center,
          ),
        ],
      ),
      actions: [
        TextButton(
          child: Text(
            '삭제',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          onPressed: () async {
            Navigator.of(context).pop();
            /// 미완료 삭제 API
            bool result = await _deleteUnresolvedSignal(context);
            if (result) {
              GlobalAlert().globDeleteSuccessAlert(context);
            } else {
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

_getUnResolvedSignal(BuildContext context) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  String username = pref.getString(Glob.email).toString();

  var accessToken = pref.getString(Glob.accessToken);

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ' + accessToken.toString()
  };

  var url = Uri.parse(Glob.memberUrl + '/check/signal/$username');

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

}

_unResolvedCheckSignal(String position, String category, int signalSeq, BuildContext context) async {
  SharedPreferences pref = await SharedPreferences.getInstance();

  String username = pref.getString(Glob.email).toString();
  var accessToken = pref.getString(Glob.accessToken);
  var url = Uri.parse(Glob.memberUrl + '/check/signal');

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ' + accessToken.toString()
  };

  String inputSignalSeq = '';

  if (category == 'eatSignal') {
    inputSignalSeq = 'eatSignalSeq';
  } else {
    inputSignalSeq = 'playSignalSeq';
  }

  final saveData = jsonEncode({
    "position": position,
    "category": category,
    inputSignalSeq: signalSeq
  });

  http.Response response = await http.post(
      url,
      headers: headers,
      body: saveData
  );

  /// 미완료 시그널이 있지만 자기 차례가 아닐 때 데이터 전달이 필요함
  UnResolvedSignalDto unResolvedSignalDto = UnResolvedSignalDto.fromJson(jsonDecode(response.body));

  Signal _signal = Provider.of<Signal>(context, listen: false);

  _signal.setPosition = unResolvedSignalDto.position;
  _signal.setCategory = unResolvedSignalDto.category;
  _signal.setTryCount = unResolvedSignalDto.tryCount;

  /// 미확인 시그널이 1개일때 + detail 페이지로 보내서 해당 페이지에서 보낼지 말지 처리하기
  Navigator.push(context, MaterialPageRoute(builder: (context) => SignalProgressDetail(
    isMyTurn: true,
    position: unResolvedSignalDto.position.toString(),
    category: unResolvedSignalDto.category.toString(),
    tryCount: int.parse(unResolvedSignalDto.tryCount.toString()),
    signalSeq: signalSeq,
    senderSelected: unResolvedSignalDto.senderSelected.toString(),
    recipientSelected: unResolvedSignalDto.recipientSelected.toString(),
  )));
}

_checkMyTurn(String category, int signalSeq, BuildContext context) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  int memberSeq = int.parse(pref.getInt(Glob.memberSeq).toString());
  var accessToken = pref.getString(Glob.accessToken);

  Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ' + accessToken.toString()
  };

  var url = Uri.parse(Glob.memberUrl + '/signal/turn/$category/$signalSeq/$memberSeq');

  http.Response response = await http.get(
    url,
    headers: headers,
  );

  CheckMyTurn checkMyTurn = CheckMyTurn.fromJson(jsonDecode(response.body));

  if (checkMyTurn.isMyTurn == false) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => SignalProgressDetail(
      isMyTurn: false,
      position: checkMyTurn.myPosition.toString(),
      category: checkMyTurn.category.toString(),
      tryCount: int.parse(checkMyTurn.tryCount.toString()),
      signalSeq: signalSeq,
      senderSelected: "",
      recipientSelected: "",
    )));
  } else {
    GlobalAlert().globErrorAlert(context);
  }
}
