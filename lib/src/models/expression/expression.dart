import 'dart:convert';

import 'package:couple_signal/src/models/global/global_variable.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class Expression extends ChangeNotifier {
  String? myExpression;
  String? coupleExpression;

  Widget? myExpressionWidget;
  String? myExpressionText;
  Widget? coupleExpressionWidget;
  String? coupleExpressionText;

  Widget? expressionList;

  _getExpressionList() {
    expressionList = Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.faceGrinHearts,
                    color: Colors.blue,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
                Text('사랑해')
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.faceGrinSquint,
                    color: Colors.blue,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
                Text('베리굿')
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.faceKissWinkHeart,
                    color: Colors.blue,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
                Text('라면먹고 갈래?')
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.faceDizzy,
                    color: Colors.blue,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
                Text('아파요')
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.faceFrown,
                    color: Colors.blue,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
                Text('짜증나')
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.faceGrinBeamSweat,
                    color: Colors.blue,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
                Text('어이가 없네~?')
              ],
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.faceSmileBeam,
                    color: Colors.blue,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
                Text('좋아요')
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.faceFlushed,
                    color: Colors.blue,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
                Text('멍멍멍')
              ],
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.handshake,
                    color: Colors.blue,
                    size: 30,
                  ),
                  onPressed: () {},
                ),
                Text('우리 화해할래?')
              ],
            ),
          ],
        ),
      ],
    );

    notifyListeners();
  }

  getExpression() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/expression/$username');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    http.Response response = await http.get(
      url,
      headers: headers,
    );

    Expression expression = Expression.formJson(jsonDecode(response.body));

    myExpression = expression.myExpression;
    coupleExpression = expression.coupleExpression;
    await _returnExpression(myExpression, coupleExpression);
    notifyListeners();
  }

  _returnExpression(myExpression, coupleExpression) {
    switch (myExpression.toString()) {
      case 'null':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceGrinHearts,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '사랑해';
        notifyListeners();
        break;

      case 'grinHearts':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceGrinHearts,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '사랑해';
        notifyListeners();
        break;

      case 'faceGrinHearts':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceGrinHearts,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '사랑해';
        notifyListeners();
        break;

      case 'grinSquint':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceGrinSquint,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '베리굿';
        notifyListeners();
        break;

      case 'faceGrinSquint':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceGrinSquint,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '베리굿';
        notifyListeners();
        break;

      case 'kissWinkHeart':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceKissWinkHeart,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '라면먹고 갈래?';
        notifyListeners();
        break;

      case 'faceKissWinkHeart':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceKissWinkHeart,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '라면먹고 갈래?';
        notifyListeners();
        break;

      case 'dizzy':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceDizzy,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '아파요';
        notifyListeners();
        break;

      case 'faceDizzy':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceDizzy,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '아파요';
        notifyListeners();
        break;

      case 'frown':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceFrown,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '짜증나';
        notifyListeners();
        break;

      case 'faceFrown':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceFrown,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '짜증나';
        notifyListeners();
        break;

      case 'grinBeamSweat':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceGrinBeamSweat,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '어이가 없네~?';
        notifyListeners();
        break;

      case 'faceGrinBeamSweat':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceGrinBeamSweat,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '어이가 없네~?';
        notifyListeners();
        break;

      case 'smileBeam':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceSmileBeam,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '좋아요';
        notifyListeners();
        break;

      case 'faceSmileBeam':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceSmileBeam,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '좋아요';
        notifyListeners();
        break;

      case 'flushed':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceFlushed,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '멍';
        notifyListeners();
        break;

      case 'faceFlushed':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceFlushed,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '멍';
        notifyListeners();
        break;

      case 'handshake':
        myExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.handshake,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '우리 화해할래?';
        notifyListeners();
        break;
    }

    switch (coupleExpression.toString()) {
      case 'null':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.userLarge,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '커플 미등록';
        notifyListeners();
        break;

      case 'grinHearts':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceGrinHearts,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '사랑해';
        notifyListeners();
        break;
      case 'faceGrinHearts':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceGrinHearts,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        myExpressionText = '사랑해';
        notifyListeners();
        break;

      case 'grinSquint':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceGrinSquint,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '베리굿';
        notifyListeners();
        break;
      case 'faceGrinSquint':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceGrinSquint,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '베리굿';
        notifyListeners();
        break;

      case 'kissWinkHeart':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceKissWinkHeart,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '라면먹고 갈래?';
        notifyListeners();
        break;
      case 'faceKissWinkHeart':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceKissWinkHeart,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '라면먹고 갈래?';
        notifyListeners();
        break;

      case 'dizzy':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceDizzy,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '아파요';
        notifyListeners();
        break;
      case 'faceDizzy':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceDizzy,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '아파요';
        notifyListeners();
        break;

      case 'frown':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceFrown,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '짜증나';
        notifyListeners();
        break;
      case 'faceFrown':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceFrown,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '짜증나';
        notifyListeners();
        break;

      case 'grinBeamSweat':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceGrinBeamSweat,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '어이가 없네~?';
        notifyListeners();
        break;
      case 'faceGrinBeamSweat':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceGrinBeamSweat,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '어이가 없네~?';
        notifyListeners();
        break;

      case 'smileBeam':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceSmileBeam,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '좋아요';
        notifyListeners();
        break;
      case 'faceSmileBeam':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceSmileBeam,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '좋아요';
        notifyListeners();
        break;

      case 'flushed':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceFlushed,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '멍';
        notifyListeners();
        break;
      case 'faceFlushed':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.faceFlushed,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '멍';
        notifyListeners();
        break;

      case 'handshake':
        coupleExpressionWidget = IconButton(
          icon: Icon(
            FontAwesomeIcons.handshake,
            color: const Color(0xffFE9BE6),
            size: 30.0,
          ),
          onPressed: () {

          },
        );
        coupleExpressionText = '우리 화해할래?';
        notifyListeners();
        break;
    }
  }

  setExpression(myExpression) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    var username = pref.getString(Glob.email);
    var accessToken = pref.getString(Glob.accessToken);

    var url = Uri.parse(Glob.memberUrl + '/expression');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ' + accessToken.toString()
    };

    final saveData = jsonEncode({
      "username": username.toString(),
      "myExpression": myExpression.toString(),
    });

    http.Response response = await http.post(
      url,
      headers: headers,
      body: saveData
    );

    await _returnExpression(myExpression, coupleExpression);
  }

  Expression.formJson(Map<String, dynamic> json) {
    myExpression = json['myExpression'];
    coupleExpression = json['coupleExpression'];
  }

  Expression() {
    _getExpressionList();
  }
}
