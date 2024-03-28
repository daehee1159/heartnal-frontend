import 'dart:convert';

import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/models/signal/eat_signal_item.dart';
import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/signal/signal.dart';
import 'package:couple_signal/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

int _seq = 0;

class SenderEatSignalCategoryPage extends StatefulWidget {
  const SenderEatSignalCategoryPage({Key? key}) : super(key: key);

  @override
  _SenderEatEatSignalCategoryPageState createState() => _SenderEatEatSignalCategoryPageState();
}

class _SenderEatEatSignalCategoryPageState extends State<SenderEatSignalCategoryPage> {

  @override
  Widget build(BuildContext context) {
    EatSignalItem _eatSignalItem = Provider.of<EatSignalItem>(context, listen: false);

    // 마지막에 API 통신을 위해 첫번째 시도라면 여기서 초기화 할 필요가 있음
    setState(() {
    });

    final eatSignalCategoryList = _eatSignalItem.getEatSignalCategoryList();
    final _random = new Random();

    var myGridView = new GridView.builder(
      itemCount: eatSignalCategoryList.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return new GestureDetector(
          child: new Card(
            elevation: 5.0,
            child: new Container(
              alignment: Alignment.centerLeft,
              margin: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: 18 / 15.3,
                    child: Image.asset(
                      _eatSignalItem.getEatSignalCategoryImgAddr(eatSignalCategoryList[index]),
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.004,),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.003),
                    child: Center(
                      child: Text(
                        eatSignalCategoryList[index],
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    ),
                  )
                ],
              )
            ),
          ),
          onTap: () {
            while (eatSignalCategoryList[index] == '랜덤 선택') {
              var element = eatSignalCategoryList[_random.nextInt(eatSignalCategoryList.length)];
              if (element != '랜덤 선택') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SenderEatSignalDetailList(senderEatSignalCategory: element)));
                break;
              }
            }
            if (eatSignalCategoryList[index] != '랜덤 선택') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SenderEatSignalDetailList(senderEatSignalCategory: eatSignalCategoryList[index],)));
            }
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
  Container _buildDivider() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0.0),
      width: double.infinity,
      height: 1.0,
      color: Colors.grey.shade400,
    );
  }
}

class SenderEatSignalDetailList extends StatelessWidget {
  final String senderEatSignalCategory;
  const SenderEatSignalDetailList({Key? key, required this.senderEatSignalCategory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Signal _signal = Provider.of<Signal>(context, listen: false);
    EatSignalItem _eatSignalItem = Provider.of<EatSignalItem>(context, listen: false);

    final _random = new Random();

    var detailList = [];

    detailList = _eatSignalItem.getEatSignalCategory(senderEatSignalCategory);

    var myGridView = new GridView.builder(
      itemCount: detailList.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      itemBuilder: (BuildContext context, int index) {
        return new GestureDetector(
          child: new Card(
            elevation: 5.0,
            child: new Container(
                alignment: Alignment.centerLeft,
                margin: new EdgeInsets.only(top: 0.0, bottom: 0.0, left: 0.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AspectRatio(
                      aspectRatio: 18.0 / 13.0,
                      child: Image.asset(
                        _eatSignalItem.getEatSignalItemImgAddr(detailList[index]),
                        fit: BoxFit.fill,
                      ),
                    ),
                    Center(
                      child: Text(
                        detailList[index],
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    )
                  ],
                )
            ),
          ),
          onTap: () {
            while (detailList[index] == '랜덤 선택') {
              var element = detailList[_random.nextInt(detailList.length)];
              if (element != '랜덤 선택') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => FirstSenderEatSelect(senderSelectSignal: element)));
                _signal.setSenderSelected = element;
                break;
              }
            }

            if (detailList[index] != '랜덤 선택') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FirstSenderEatSelect(senderSelectSignal: detailList[index],)));
              _signal.setSenderSelected = detailList[index];
            }
          },
        );
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          senderEatSignalCategory,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        centerTitle: true,
      ),
      body: myGridView,
    );
  }
}

class FirstSenderEatSelect extends StatefulWidget {
  final String senderSelectSignal;
  const FirstSenderEatSelect({Key? key, required this.senderSelectSignal,}) : super(key: key);

  @override
  State<FirstSenderEatSelect> createState() => _FirstSenderEatSelectState();
}

class _FirstSenderEatSelectState extends State<FirstSenderEatSelect> {
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
            const SizedBox(
              height: 30.0,
            ),
            Center(
              child: Image.asset(
                _eatSignalItem.getEatSignalItemImgAddr(widget.senderSelectSignal),
                width: MediaQuery.of(context).size.width * 0.30,
                height: MediaQuery.of(context).size.height * 0.15,
                fit: BoxFit.fill,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Center(
                child: Text(
                  widget.senderSelectSignal,
                  style: Theme.of(context).textTheme.bodyText1!.copyWith(fontSize: 30.0),
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
                  _sendEatSignal(widget.senderSelectSignal, context);
                  _press = true;
                }
              },
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ),
    );
  }

  _sendEatSignal(senderSelect, context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.eatSignalUrl + '/sender');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var saveData;

    saveData = jsonEncode({
      "username": username.toString(),
      "category": 'eatSignal',
      "senderPrimarySelected": senderSelect
    });

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
      GlobalAlert().onLoading(context);
      await Future.delayed(Duration(seconds: 2));
      return GlobalAlert().globErrorAlert(context);
    }
  }
}
