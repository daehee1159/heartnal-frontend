import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:webview_flutter/webview_flutter.dart';

class ResultSearch extends StatefulWidget {
  final String category;
  const ResultSearch({Key? key, required this.category}) : super(key: key);

  @override
  _ResultSearchState createState() => _ResultSearchState();
}

class _ResultSearchState extends State<ResultSearch> {
  String result = '';
  List data = [];
  List testData = [];
  TextEditingController _editingController = TextEditingController();
  ScrollController _scrollController = ScrollController();
  int page = 1;

  @override
  void initState() {
    super.initState();
    data = [];
    _editingController = new TextEditingController();
    _scrollController = new ScrollController();

    _scrollController.addListener(() {
      if (_scrollController.offset >= _scrollController.position.maxScrollExtent && !_scrollController.position.outOfRange) {
        page++;
        getJSONData();
      }
    });
  }

  FocusNode focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Container(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
          child: TextField(
            controller: _editingController,
            style: Theme.of(context).textTheme.bodyText2,
            keyboardType: TextInputType.text,
            focusNode: focusNode,
            /// InputDecoration.collapse
            decoration: InputDecoration(
              hintText: 'ex) 강남구 파스타',
              hintStyle: Theme.of(context).textTheme.bodyText2!.copyWith(color: Colors.grey),
              contentPadding: EdgeInsets.fromLTRB(5, MediaQuery.of(context).size.height * 0.025, 0, 0),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: const Color(0xffFE9BE6))
              ),
              suffixIcon: IconButton(
                padding: EdgeInsets.fromLTRB(10, MediaQuery.of(context).size.height * 0.015, 0, 0),
                icon: Icon(Icons.search, color: focusNode.hasFocus ? const Color(0xffFE9BE6) : Colors.grey,),
                onPressed: () {
                  if (_editingController.text.isEmpty || _editingController.text == '') {
                    _textEmptyErrorAlert(context);
                  } else {
                    page = 1;
                    data.clear();
                    getJSONData();
                  }
                },
              )
            ),
            onTap: () {
              FocusScope.of(context).requestFocus(focusNode);
            },
          ),
        ),
      ),
      body: Container(
        child: Center(
            child: data.length == 0 && testData.length == 0 ? Text('데이터가 없어요.', style: Theme.of(context).textTheme.bodyText2, textAlign: TextAlign.center,) :
            ListView.builder(
              itemBuilder: (context, index) {
                return Card(
                    child: Row(
                      children: [
                        widget.category == "eatSignal" ?
                        Image.asset(
                          "images/title_eat_signal.png",
                          fit: BoxFit.fill,
                          height: 100,
                        ) :
                        Image.asset(
                          "images/title_play_signal.png",
                          fit: BoxFit.fill,
                          height: 100,
                        ) ,
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
                              Container(
                                width: MediaQuery.of(context).size.width - 150,
                                child: Text(
                                  '위치 : ${data[index]['address_name'].toString()}',
                                  maxLines: 2,
                                  style: Theme.of(context).textTheme.bodyText2,
                                  // overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
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
            )
        ),
      ),
    );
  }
  Future<String> getJSONData() async {
    Map<String, String> headers = {
      'Authorization': 'KakaoAK ee733080356564f96bc38d4e0d3ab5cf'
    };

    var url = Uri.parse('https://dapi.kakao.com/v2/local/search/keyword.json?page=1&size=15&sort=accuracy&query=${_editingController.value.text}');

    var uri = Uri.parse('https://dapi.kakao.com/v3/search/book?target=title&page=$page&query=${_editingController.value.text}');

    var response = await http.get(url,headers: headers);
    setState(() {
      // data.clear();
      var dataConvertedToJSON = json.decode(response.body);
      List result = dataConvertedToJSON['documents'];
      data.addAll(result);
    });

    return response.body;
  }

  _textEmptyErrorAlert(BuildContext context) async {
    AlertDialog alertDialog = AlertDialog(
      title: TextButton.icon(
        label: Padding(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          child: Text(
            "검색어 오류",
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
        '검색어를 입력해주세요!\nex) 강남구 파스타',
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

class WebViewPage extends StatelessWidget {
  final String initUrl;
  const WebViewPage({Key? key, required this.initUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '검색 결과',
          style: Theme.of(context).textTheme.bodyText1,
        ),
        centerTitle: true,
      ),
      body: Container(
        child: WebView(
          initialUrl: initUrl,
          javascriptMode: JavascriptMode.unrestricted,
        ),
      ),
    );
  }
}

