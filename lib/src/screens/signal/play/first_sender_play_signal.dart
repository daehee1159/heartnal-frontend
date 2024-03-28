import 'dart:convert';

import 'package:couple_signal/src/models/global/global_alert.dart';
import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/signal/play_signal_item.dart';
import 'package:couple_signal/src/models/signal/signal.dart';
import 'package:couple_signal/src/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:math';

int _seq = 0;

class PlayPrimaryCategory extends StatefulWidget {
  const PlayPrimaryCategory({Key? key}) : super(key: key);

  @override
  _PlayPrimaryCategoryState createState() => _PlayPrimaryCategoryState();
}

class _PlayPrimaryCategoryState extends State<PlayPrimaryCategory> {

  @override
  Widget build(BuildContext context) {
    PlaySignalItem _playSignalItem = Provider.of<PlaySignalItem>(context, listen: false);

    var playSignalCategoryList = _playSignalItem.getPlaySignalCategoryList();
    final _random = new Random();

    var myGridView = new GridView.builder(
      itemCount: playSignalCategoryList.length,
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
                        _playSignalItem.getPlaySignalCategoryImgAddr(playSignalCategoryList[index]),
                        fit: BoxFit.fill,
                      ),
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    Center(
                      child: Text(
                        playSignalCategoryList[index],
                        style: Theme.of(context).textTheme.bodyText2,
                      ),
                    )
                  ],
                )
            ),
          ),
          onTap: () {
            while (playSignalCategoryList[index] == '랜덤 선택') {
              var element = playSignalCategoryList[_random.nextInt(playSignalCategoryList.length)];
              if (element != '랜덤 선택') {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SenderPlaySignalDetailList(senderPlaySignalCategory: element)));
                break;
              }
            }
            if (playSignalCategoryList[index] != '랜덤 선택') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => SenderPlaySignalDetailList(senderPlaySignalCategory: playSignalCategoryList[index])));
            }
          },
        );
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '오늘 뭐하지?',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        centerTitle: true,
      ),
      body: myGridView,
    );
  }
}

class SenderPlaySignalDetailList extends StatelessWidget {
  final String senderPlaySignalCategory;
  const SenderPlaySignalDetailList({Key? key, required this.senderPlaySignalCategory}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Signal _signal = Provider.of<Signal>(context, listen: false);
    PlaySignalItem _playSignalItem = Provider.of<PlaySignalItem>(context, listen: false);

    final _random = new Random();

    var detailList = _playSignalItem.getPlaySignalCategory(senderPlaySignalCategory);

    var myGridView = new GridView.builder(
      itemCount: detailList.length,
      gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
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
                        _playSignalItem.getPlaySignalItemImgAddr(detailList[index]),
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => FirstSenderPlaySelect(senderSelectSignal: element)));
                _signal.setSenderSelected = element;
                break;
              }
            }
            if (detailList[index] != '랜덤 선택') {
              Navigator.push(context, MaterialPageRoute(builder: (context) => FirstSenderPlaySelect(senderSelectSignal: detailList[index],)));
              _signal.setSenderSelected = detailList[index];
            }
          },
        );
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text(
          senderPlaySignalCategory,
          style: Theme.of(context).textTheme.bodyText1,
        ),
        centerTitle: true,
      ),
      body: myGridView,
    );
  }
}

class FirstSenderPlaySelect extends StatefulWidget {
  final String senderSelectSignal;
  const FirstSenderPlaySelect({Key? key, required this.senderSelectSignal}) : super(key: key);

  @override
  State<FirstSenderPlaySelect> createState() => _FirstSenderPlaySelectState();
}

class _FirstSenderPlaySelectState extends State<FirstSenderPlaySelect> {
  bool _press = false;

  @override
  void initState() {
    super.initState();
    _press = false;
  }

  @override
  Widget build(BuildContext context) {
    PlaySignalItem _playSignalItem = Provider.of<PlaySignalItem>(context);
    Signal _signal = Provider.of<Signal>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '오늘 뭐하지?',
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
                _playSignalItem.getPlaySignalItemImgAddr(widget.senderSelectSignal),
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
                  _sendPlaySignal(widget.senderSelectSignal, context);
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

  _sendPlaySignal(senderSelect, context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.playSignalUrl + '/sender');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    var saveData;

    saveData = jsonEncode({
      "username": username.toString(),
      "category": 'playSignal',
      "senderPrimarySelected": senderSelect
    });

    http.Response response = await http.post(
        url,
        headers: headers,
        body: saveData
    );

    if (response.body.toString() == "1") {
      await Future.delayed(Duration(seconds: 2));
      Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(routePage: 0,)));
      return GlobalAlert().globSignalSuccessAlert(context);
    } else {
      await Future.delayed(Duration(seconds: 2));
      return GlobalAlert().globErrorAlert(context);
    }
  }
}
