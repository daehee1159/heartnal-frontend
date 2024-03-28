import 'dart:convert';

import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/models/signal/eat_signal_item.dart';
import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/signal/signal.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../home.dart';

int _tryCount = 0;
int _seq = 0;

class NotFirstSenderEatSignal extends StatefulWidget {
  const NotFirstSenderEatSignal({Key? key}) : super(key: key);

  @override
  _NotFirstSenderEatSignalState createState() => _NotFirstSenderEatSignalState();
}

class _NotFirstSenderEatSignalState extends State<NotFirstSenderEatSignal> {

  @override
  Widget build(BuildContext context) {
    EatSignalItem _eatSignalItem = Provider.of<EatSignalItem>(context, listen: false);
    Signal _signal = Provider.of<Signal>(context, listen: false);

    // 마지막에 API 통신을 위해 첫번째 시도라면 여기서 초기화 할 필요가 있음
    setState(() {

    });

    var retryList = [_signal.getSenderSelected, _signal.getRecipientSelected];

    var myGridView = new GridView.builder(
      itemCount: retryList.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return new GestureDetector(
          child: new Card(
            elevation: 5.0,
            child: new Container(
                alignment: Alignment.centerLeft,
                margin: const EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 18.0 / 13.0,
                      child: Image.asset(
                        _eatSignalItem.getEatSignalItemImgAddr(retryList[index]),
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: Text(
                        retryList[index],
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    )
                  ],
                )
            ),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => NotFirstSenderEatSelect(senderSelectSignal: retryList[index],)));
            _signal.setSenderSelected = retryList[index];
          },
        );
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(
          '오늘 뭐먹지?',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        centerTitle: true,
      ),
      body: myGridView,
    );
  }
}

class NotFirstSenderEatSelect extends StatefulWidget {
  final String senderSelectSignal;
  const NotFirstSenderEatSelect({Key? key, required this.senderSelectSignal}) : super(key: key);

  @override
  State<NotFirstSenderEatSelect> createState() => _NotFirstSenderEatSelectState();
}

class _NotFirstSenderEatSelectState extends State<NotFirstSenderEatSelect> {
  bool _press = false;

  @override
  void initState() {
    super.initState();
    _press = false;
  }

  @override
  Widget build(BuildContext context) {
    Signal _signal = Provider.of<Signal>(context, listen: false);
    EatSignalItem _eatSignalItem = Provider.of<EatSignalItem>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '오늘 뭐먹지?',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        centerTitle: true,
      ),
      body: Container(
        child: Column(
          children: [
            Row(
              children: [
                Center(
                  child: Text(
                    '당신이 선택한 시그널',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 35.0),
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
            Center(
              child: Image.asset(
                _eatSignalItem.getEatSignalItemImgAddr(widget.senderSelectSignal),
                width: MediaQuery.of(context).size.width * 0.30,
                height: MediaQuery.of(context).size.height * 0.15,
                fit: BoxFit.fill,
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Center(
                child: Text(
                  widget.senderSelectSignal,
                  style: Theme.of(context).textTheme.bodyText2!.copyWith(fontSize: 30.0),
                ),
              ),
            ),
            const SizedBox(
              height: 30.0,
            ),
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
              onPressed: () {
                GlobalAlert().onLoading(context);
                if (_press) {
                  return;
                } else {
                  // sender 는 이미 tryCount 를 받았다는 것은 1번 이상 시도이기 때문에 +1 을 해줌
                  switch (_signal.getTryCount) {
                    case 1:
                      _tryCount = 2;
                      _seq = _signal.getEatSignalSeq;
                      break;
                    case 2:
                      _tryCount = 3;
                      _seq = _signal.getEatSignalSeq;
                      break;
                  }
                  _sendEatSignal(widget.senderSelectSignal, _signal.getEatSignalSeq, context);
                  _press = true;
                }
              },
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }

  _sendEatSignal(senderSelected, eatSignalSeq, context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.eatSignalUrl + '/sender');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var saveData;
    switch (_tryCount) {
      case 1:
        /// 이거 나오면 에러임
        break;
      case 2:
        saveData = jsonEncode({
          "username": username.toString(),
          "senderSecondarySelected": senderSelected,
          "eatSignalSeq": eatSignalSeq
        });
        break;
      case 3:
        saveData = jsonEncode({
          "username": username.toString(),
          "senderTertiarySelected": senderSelected,
          "eatSignalSeq": eatSignalSeq
        });
        break;
    }

    http.Response response = await http.post(
        url,
        headers: headers,
        body: saveData
    );

    if (response.body.toString() == "1") {
      await Future.delayed(Duration(seconds: 2));
      Navigator.of(context).pop();
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(routePage: 0,)));
      return GlobalAlert().globSignalSuccessAlert(context);
    } else {
      await Future.delayed(Duration(seconds: 2));
      return GlobalAlert().globErrorAlert(context);
    }
  }
}
