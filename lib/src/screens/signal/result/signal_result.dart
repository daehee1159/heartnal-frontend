import 'dart:convert';

import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:couple_signal/src/models/signal/play_signal_item.dart';
import 'package:couple_signal/src/screens/signal/result/result_search.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:couple_signal/src/models/signal/eat_signal_item.dart';
import 'package:http/http.dart' as http;

class SignalResult extends StatefulWidget {
  final String resultItem;
  final String category;
  const SignalResult({Key? key, required this.resultItem, required this.category}) : super(key: key);

  @override
  _SignalResultState createState() => _SignalResultState(resultItem);
}

class _SignalResultState extends State<SignalResult> {
  String result = '';
  List data = [];
  ScrollController _scrollController = ScrollController();
  int page = 1;
  String successItem = '';

  _SignalResultState(String resultItem) {
    switch (resultItem) {
      case "라면먹고 갈래?":
        resultItem = "모텔";
        break;
      case "드라이브":
        resultItem = "관광";
        break;
      case "한잔 할래?":
        resultItem = "술집";
        break;
      case "쇼핑":
        resultItem = "백화점";
        break;
    }
    successItem = resultItem;
  }

  @override
  void initState() {
    super.initState();
    data = [];
    _scrollController = new ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
        page++;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    String resultItemImgAddr = "";
    switch (widget.category) {
      case "eatSignal":
        EatSignalItem _eatSignalItem = Provider.of<EatSignalItem>(context, listen: false);
        resultItemImgAddr = _eatSignalItem.getEatSignalItemImgAddr(widget.resultItem);
        break;
      case "playSignal":
        PlaySignalItem _playSignalItem = Provider.of<PlaySignalItem>(context, listen: false);
        resultItemImgAddr = _playSignalItem.getPlaySignalItemImgAddr(widget.resultItem);
        break;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '시그널 매칭 결과',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: '다른 지역으로 검색하기',
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ResultSearch(category: widget.category,)));
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _locationTest(successItem),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Column(
              children: [
                Center(
                  child: Text(
                    '데이터를 불러오는 중이에요.',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                const CircularProgressIndicator()
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            );
          }
          else if (snapshot.hasError) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Error : ${snapshot.error}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
            );
          }
          else if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return Card(
                    child: Row(
                      children: [
                        Image.asset(
                          resultItemImgAddr,
                          fit: BoxFit.fill,
                          height: 100,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => WebViewPage(initUrl: data[index]['place_url'])));
                          },
                          child: Column(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width - 150,
                                child: Text(
                                  data[index]['place_name'].toString(),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Text(
                                '위치 : ${data[index]['address_name'].toString()}',
                                maxLines: 2,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                              Text(
                                '연락처 : ${data[index]['phone'].toString()}',
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
                itemCount: data.length,
                controller: _scrollController,
              ),
            );
          } else {
            return Column(
              children: [
                Center(
                  child: Text(
                    '데이터를 불러오는 중이에요.',
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                ),
                const CircularProgressIndicator()
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            );
          }
        },
      ),
    );
  }
  _locationTest(query) async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();

    Map<String, String> headers = {
      'Authorization': Glob.kakaoAuthorization
    };

    var url = Uri.parse(
        'https://dapi.kakao.com/v2/local/search/keyword.json?page=1&size=15&sort=accuracy&query=$query&x=${_locationData.longitude}&y=${_locationData.latitude}');

    var response = await http.get(url,headers: headers);
    var dataConvertedToJSON = json.decode(response.body);
    List result = dataConvertedToJSON['documents'];
    data.addAll(result);
  }
}
